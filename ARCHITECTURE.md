# 🏗️ Architecture - Adyen Transaction

## Vue d'Ensemble

```
┌─────────────────────────────────────────────────────────────────────┐
│                           UTILISATEUR                                │
│                         (Navigateur Web)                             │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                             │ HTTP/HTTPS
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      FRONTEND (Port 3000)                            │
│                         React + Vite                                 │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │                    React Application                          │  │
│  │  ┌─────────────────────────────────────────────────────────┐ │  │
│  │  │  Pages                                                   │ │  │
│  │  │  └─ TransactionsPage.tsx                                │ │  │
│  │  └─────────────────────────────────────────────────────────┘ │  │
│  │  ┌─────────────────────────────────────────────────────────┐ │  │
│  │  │  Components                                              │ │  │
│  │  │  ├─ TransactionsOverview.tsx                            │ │  │
│  │  │  └─ TransactionDetails.tsx                              │ │  │
│  │  └─────────────────────────────────────────────────────────┘ │  │
│  │  ┌─────────────────────────────────────────────────────────┐ │  │
│  │  │  Adyen Platform Experience Components                   │ │  │
│  │  │  (@adyen/adyen-platform-experience-web)                 │ │  │
│  │  └─────────────────────────────────────────────────────────┘ │  │
│  │  ┌─────────────────────────────────────────────────────────┐ │  │
│  │  │  Services                                                │ │  │
│  │  │  ├─ api.ts (HTTP Client)                                │ │  │
│  │  │  └─ config.ts (Configuration)                           │ │  │
│  │  └─────────────────────────────────────────────────────────┘ │  │
│  └───────────────────────────────────────────────────────────────┘  │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                             │ HTTP POST
                             │ /api/adyen/session
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      BACKEND (Port 8080)                             │
│                      Node.js + Express                               │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  Express Server                                               │  │
│  │  ┌─────────────────────────────────────────────────────────┐ │  │
│  │  │  Routes                                                  │ │  │
│  │  │  ├─ POST /api/adyen/session                             │ │  │
│  │  │  ├─ POST /api/adyen/session/refresh                     │ │  │
│  │  │  └─ GET /health                                         │ │  │
│  │  └─────────────────────────────────────────────────────────┘ │  │
│  │  ┌─────────────────────────────────────────────────────────┐ │  │
│  │  │  Middleware                                              │ │  │
│  │  │  ├─ CORS                                                 │ │  │
│  │  │  └─ JSON Parser                                         │ │  │
│  │  └─────────────────────────────────────────────────────────┘ │  │
│  │  ┌─────────────────────────────────────────────────────────┐ │  │
│  │  │  Environment Variables                                   │ │  │
│  │  │  ├─ ADYEN_API_KEY (🔒 Secret)                           │ │  │
│  │  │  ├─ ADYEN_ENVIRONMENT                                    │ │  │
│  │  │  ├─ ADYEN_ACCOUNT_HOLDER_ID                             │ │  │
│  │  │  └─ ALLOW_ORIGIN                                        │ │  │
│  │  └─────────────────────────────────────────────────────────┘ │  │
│  └───────────────────────────────────────────────────────────────┘  │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                             │ HTTPS POST
                             │ x-api-key: ADYEN_API_KEY
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         ADYEN API                                    │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  Authentication API                                           │  │
│  │  https://test.adyen.com/authe/api/v1/sessions               │  │
│  │  (ou https://authe.adyen.com pour live)                      │  │
│  └───────────────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  Balance Platform API                                         │  │
│  │  - Transactions data                                          │  │
│  │  - Account holder information                                 │  │
│  │  - Refund management                                          │  │
│  └───────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
```

## Flux de Données

### 1. Initialisation de la Session

```
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│          │  1  │          │  2  │          │  3  │          │
│  User    │────▶│ Frontend │────▶│ Backend  │────▶│  Adyen   │
│          │     │          │     │          │     │   API    │
└──────────┘     └──────────┘     └──────────┘     └──────────┘
                      │                 │                 │
                      │                 │                 │
                      │  6              │  5              │  4
                      │◀────────────────│◀────────────────│
                      │                 │                 │
                      ▼                 ▼                 ▼
                 Affichage         Session          Session
                 Transactions       Token            Created
```

**Étapes détaillées :**

1. **User → Frontend** : L'utilisateur accède à la page des transactions
2. **Frontend → Backend** : Le composant React appelle `POST /api/adyen/session`
3. **Backend → Adyen** : Le serveur crée une session avec la clé API
4. **Adyen → Backend** : Adyen retourne un token de session
5. **Backend → Frontend** : Le token est transmis au frontend
6. **Frontend → User** : Le composant Adyen s'initialise et affiche les transactions

### 2. Affichage des Transactions

```
┌──────────┐     ┌──────────┐     ┌──────────┐
│          │     │  Adyen   │     │          │
│ Frontend │────▶│Component │────▶│  Adyen   │
│          │     │          │     │   API    │
└──────────┘     └──────────┘     └──────────┘
     │                 │                 │
     │                 │                 │
     │                 │◀────────────────│
     │                 │                 │
     │◀────────────────│                 │
     │                 │                 │
     ▼                 ▼                 ▼
  Display         Render            Transaction
  Transactions    Data              Data
```

**Note :** Une fois initialisé, le composant Adyen communique directement avec l'API Adyen en utilisant le token de session.

## Structure des Fichiers

```
adyen-transaction/
│
├── 📁 Frontend (React + TypeScript)
│   ├── src/
│   │   ├── components/          # Composants React réutilisables
│   │   │   ├── TransactionsOverview.tsx
│   │   │   └── TransactionDetails.tsx
│   │   │
│   │   ├── pages/               # Pages de l'application
│   │   │   └── TransactionsPage.tsx
│   │   │
│   │   ├── services/            # Services et utilitaires
│   │   │   ├── api.ts          # Client HTTP (Axios)
│   │   │   └── config.ts       # Configuration
│   │   │
│   │   ├── types/               # Types TypeScript
│   │   │   └── adyen.ts
│   │   │
│   │   ├── App.tsx              # Composant racine
│   │   ├── index.tsx            # Point d'entrée
│   │   └── index.css            # Styles globaux
│   │
│   ├── public/                  # Fichiers statiques
│   ├── index.html               # Template HTML
│   ├── package.json             # Dépendances
│   ├── tsconfig.json            # Config TypeScript
│   ├── vite.config.ts           # Config Vite
│   └── .env                     # Variables d'environnement
│
├── 📁 Backend (Node.js + Express)
│   ├── server/
│   │   ├── index.js             # Serveur Express
│   │   ├── package.json         # Dépendances
│   │   └── .env                 # Variables d'environnement
│   │
│   └── README.md                # Documentation backend
│
├── 📁 Docker
│   ├── Dockerfile               # Image Docker multi-stage
│   ├── docker-compose.yml       # Orchestration
│   ├── docker-entrypoint.sh     # Script de démarrage
│   └── .dockerignore            # Fichiers à ignorer
│
├── 📁 Scripts
│   ├── setup.sh                 # Configuration initiale
│   ├── check-env.sh             # Vérification des .env
│   └── docker-build.sh          # Construction Docker
│
└── 📁 Documentation
    ├── README.md                # Documentation principale
    ├── QUICKSTART.md            # Guide rapide
    ├── TECHNICAL.md             # Documentation technique
    ├── EXAMPLES.md              # Exemples d'utilisation
    ├── ARCHITECTURE.md          # Ce fichier
    ├── COMMANDS.md              # Commandes utiles
    └── CHANGELOG.md             # Historique des versions
```

## Technologies Utilisées

### Frontend

| Technologie | Version | Rôle |
|-------------|---------|------|
| React | 18.2 | Framework UI |
| TypeScript | 5.1 | Typage statique |
| Vite | 5.0 | Build tool & dev server |
| React Router | 6.26 | Routing |
| Axios | 1.6 | Client HTTP |
| @adyen/adyen-platform-experience-web | 1.0+ | Composants Adyen |

### Backend

| Technologie | Version | Rôle |
|-------------|---------|------|
| Node.js | 22+ | Runtime JavaScript |
| Express | 4.18 | Framework web |
| Axios | 1.6 | Client HTTP |
| CORS | 2.8 | Gestion CORS |
| dotenv | 16.3 | Variables d'environnement |

### DevOps

| Technologie | Version | Rôle |
|-------------|---------|------|
| Docker | Latest | Containerisation |
| Docker Compose | Latest | Orchestration |
| GitLab CI/CD | - | Pipeline CI/CD |

## Sécurité

### Couches de Sécurité

```
┌─────────────────────────────────────────────────────────────┐
│  1. Frontend (Public)                                        │
│     ❌ Pas de clé API                                        │
│     ✅ Validation des entrées                                │
│     ✅ HTTPS en production                                   │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ HTTPS
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  2. Backend (Privé)                                          │
│     ✅ Clé API stockée en sécurité                           │
│     ✅ CORS configuré                                        │
│     ✅ Variables d'environnement                             │
│     ✅ Validation des requêtes                               │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ HTTPS + API Key
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  3. Adyen API                                                │
│     ✅ Authentification par clé API                          │
│     ✅ Tokens de session temporaires                         │
│     ✅ Permissions granulaires                               │
└─────────────────────────────────────────────────────────────┘
```

### Principes de Sécurité

1. **Séparation des Responsabilités**
   - Frontend : Affichage uniquement
   - Backend : Gestion des secrets et authentification
   - Adyen : Données et logique métier

2. **Principe du Moindre Privilège**
   - Chaque composant a uniquement les permissions nécessaires
   - Les tokens de session ont une durée de vie limitée

3. **Défense en Profondeur**
   - Validation côté client ET serveur
   - CORS pour limiter les origines
   - HTTPS obligatoire en production

## Scalabilité

### Horizontal Scaling

```
                    ┌─────────────┐
                    │ Load        │
                    │ Balancer    │
                    └──────┬──────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
┌───────────────┐  ┌───────────────┐  ┌───────────────┐
│  Frontend     │  │  Frontend     │  │  Frontend     │
│  Instance 1   │  │  Instance 2   │  │  Instance 3   │
└───────┬───────┘  └───────┬───────┘  └───────┬───────┘
        │                  │                  │
        └──────────────────┼──────────────────┘
                           │
                    ┌──────▼──────┐
                    │ Backend     │
                    │ Load        │
                    │ Balancer    │
                    └──────┬──────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
┌───────────────┐  ┌───────────────┐  ┌───────────────┐
│  Backend      │  │  Backend      │  │  Backend      │
│  Instance 1   │  │  Instance 2   │  │  Instance 3   │
└───────────────┘  └───────────────┘  └───────────────┘
```

### Optimisations

1. **Caching**
   - Cache des assets statiques (frontend)
   - Cache des sessions (backend)
   - CDN pour les fichiers statiques

2. **Code Splitting**
   - Chargement lazy des composants
   - Chunks séparés pour les vendors

3. **Compression**
   - Gzip/Brotli pour les assets
   - Minification du code

## Monitoring

### Métriques à Surveiller

```
┌─────────────────────────────────────────────────────────────┐
│  Frontend Metrics                                            │
│  ├─ Page Load Time                                          │
│  ├─ Time to Interactive (TTI)                               │
│  ├─ First Contentful Paint (FCP)                            │
│  └─ JavaScript Errors                                       │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  Backend Metrics                                             │
│  ├─ Response Time                                           │
│  ├─ Request Rate                                            │
│  ├─ Error Rate                                              │
│  ├─ CPU Usage                                               │
│  └─ Memory Usage                                            │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  Adyen API Metrics                                           │
│  ├─ API Call Success Rate                                   │
│  ├─ API Response Time                                       │
│  └─ Session Creation Rate                                   │
└─────────────────────────────────────────────────────────────┘
```

## Déploiement

### Environnements

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│             │     │             │     │             │
│ Development │────▶│   Staging   │────▶│ Production  │
│             │     │             │     │             │
└─────────────┘     └─────────────┘     └─────────────┘
     Local              Test Env           Live Env
  localhost:3000    dev.example.com    example.com
```

### Pipeline CI/CD

```
┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
│          │   │          │   │          │   │          │
│  Commit  │──▶│  Build   │──▶│   Test   │──▶│  Deploy  │
│          │   │          │   │          │   │          │
└──────────┘   └──────────┘   └──────────┘   └──────────┘
     │              │              │              │
     │              │              │              │
     ▼              ▼              ▼              ▼
  Git Push      Compile        Run Tests     Docker Push
                Lint          Coverage       K8s Deploy
```

## Évolutions Futures

### Fonctionnalités Prévues

1. **Authentification Utilisateur**
   - Login/Logout
   - Gestion des rôles
   - Multi-tenant

2. **Analytics**
   - Dashboard de statistiques
   - Graphiques de transactions
   - Rapports personnalisables

3. **Notifications**
   - Alertes en temps réel
   - Webhooks
   - Email notifications

4. **Export de Données**
   - Export CSV/Excel
   - Rapports PDF
   - API REST

5. **Mobile App**
   - React Native
   - iOS & Android

---

**📚 Pour plus d'informations, consultez les autres fichiers de documentation.**