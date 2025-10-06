# Documentation Technique - Adyen Transaction

## Architecture

### Vue d'ensemble

```
┌─────────────────────────────────────────────────────────────┐
│                         Browser                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │           React Application (Port 3000)                │ │
│  │                                                        │ │
│  │  ┌──────────────────────────────────────────────┐    │ │
│  │  │  Adyen Platform Experience Components        │    │ │
│  │  │  - TransactionsOverview                      │    │ │
│  │  │  - TransactionDetails                        │    │ │
│  │  └──────────────────────────────────────────────┘    │ │
│  │                      ↓                                 │ │
│  │  ┌──────────────────────────────────────────────┐    │ │
│  │  │  API Service Layer                           │    │ │
│  │  │  - createAdyenSession()                      │    │ │
│  │  │  - refreshAdyenSession()                     │    │ │
│  │  └──────────────────────────────────────────────┘    │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                            ↓ HTTP
┌─────────────────────────────────────────────────────────────┐
│              Node.js Backend (Port 8080)                     │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  Express Server                                        │ │
│  │  - POST /api/adyen/session                            │ │
│  │  - POST /api/adyen/session/refresh                    │ │
│  │  - GET /health                                        │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                            ↓ HTTPS
┌─────────────────────────────────────────────────────────────┐
│                    Adyen API                                 │
│  - Authentication API (authe.adyen.com)                     │
│  - Balance Platform API                                     │
└─────────────────────────────────────────────────────────────┘
```

## Stack Technique

### Frontend
- **React 18.2** : Framework UI
- **TypeScript 5.1** : Typage statique
- **Vite 5.0** : Build tool et dev server
- **React Router 6** : Routing
- **Axios** : Client HTTP
- **@adyen/adyen-platform-experience-web** : Composants Adyen

### Backend
- **Node.js 22** : Runtime JavaScript
- **Express 4** : Framework web
- **Axios** : Client HTTP pour les appels Adyen
- **CORS** : Gestion des requêtes cross-origin
- **dotenv** : Gestion des variables d'environnement

### DevOps
- **Docker** : Containerisation
- **Docker Compose** : Orchestration
- **GitLab CI/CD** : Pipeline d'intégration continue

## Flux de Données

### 1. Initialisation de la Session

```
User → React Component → API Service → Backend Server → Adyen API
                                                            ↓
User ← React Component ← API Service ← Backend Server ← Session Token
```

1. L'utilisateur accède à la page des transactions
2. Le composant React appelle `createAdyenSession()`
3. Le service API fait une requête POST vers `/api/adyen/session`
4. Le backend fait une requête vers l'API Adyen avec la clé API
5. Adyen retourne un token de session
6. Le token est transmis au composant React
7. Le composant Adyen s'initialise avec le token

### 2. Affichage des Transactions

```
Adyen Component → Adyen API (avec session token) → Transaction Data
                                                         ↓
Adyen Component ← Adyen API ← Transaction List
```

Une fois initialisé, le composant Adyen communique directement avec l'API Adyen en utilisant le token de session.

## Structure des Fichiers

```
adyen-transaction/
├── src/
│   ├── components/
│   │   ├── TransactionsOverview.tsx    # Composant liste des transactions
│   │   └── TransactionDetails.tsx      # Composant détails d'une transaction
│   ├── pages/
│   │   └── TransactionsPage.tsx        # Page principale
│   ├── services/
│   │   ├── api.ts                      # Client API
│   │   └── config.ts                   # Configuration
│   ├── types/
│   │   └── adyen.ts                    # Types TypeScript
│   ├── App.tsx                         # Composant racine
│   ├── index.tsx                       # Point d'entrée
│   ├── index.css                       # Styles globaux
│   └── env.d.ts                        # Déclarations TypeScript
├── server/
│   ├── index.js                        # Serveur Express
│   └── package.json                    # Dépendances backend
├── public/                             # Fichiers statiques
├── Dockerfile                          # Configuration Docker
├── docker-compose.yml                  # Orchestration Docker
├── vite.config.ts                      # Configuration Vite
├── tsconfig.json                       # Configuration TypeScript
└── package.json                        # Dépendances frontend
```

## API Backend

### POST /api/adyen/session

Crée une nouvelle session d'authentification Adyen.

**Request:**
```http
POST /api/adyen/session
Content-Type: application/json
```

**Response:**
```json
{
  "id": "EC1234-1234-1234-1234",
  "token": "xxxxx.yyyyy.zzzzzz"
}
```

### POST /api/adyen/session/refresh

Rafraîchit une session d'authentification existante.

**Request:**
```http
POST /api/adyen/session/refresh
Content-Type: application/json
```

**Response:**
```json
{
  "id": "EC1234-1234-1234-1234",
  "token": "xxxxx.yyyyy.zzzzzz"
}
```

### GET /health

Vérifie l'état du serveur.

**Request:**
```http
GET /health
```

**Response:**
```json
{
  "status": "ok",
  "environment": "test",
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

## Variables d'Environnement

### Frontend (.env)

| Variable | Description | Exemple |
|----------|-------------|---------|
| `VITE_ADYEN_API_KEY` | Clé API Adyen (non utilisée côté client) | `AQE...` |
| `VITE_ADYEN_ENVIRONMENT` | Environnement Adyen | `test` ou `live` |
| `VITE_ADYEN_ACCOUNT_HOLDER_ID` | ID du compte Adyen | `AH00000000000000000000001` |
| `VITE_ALLOW_ORIGIN` | Origine autorisée | `http://localhost:3000` |
| `VITE_API_BASE_URL` | URL de l'API backend | `http://localhost:8080` |

### Backend (server/.env)

| Variable | Description | Exemple |
|----------|-------------|---------|
| `PORT` | Port du serveur | `8080` |
| `ADYEN_API_KEY` | Clé API Adyen | `AQE...` |
| `ADYEN_ENVIRONMENT` | Environnement Adyen | `test` ou `live` |
| `ADYEN_ACCOUNT_HOLDER_ID` | ID du compte Adyen | `AH00000000000000000000001` |
| `ALLOW_ORIGIN` | Origine autorisée pour CORS | `http://localhost:3000` |

## Sécurité

### Bonnes Pratiques Implémentées

1. **Clé API côté serveur uniquement**
   - La clé API n'est jamais exposée au client
   - Toutes les requêtes Adyen passent par le backend

2. **CORS configuré**
   - Seules les origines autorisées peuvent accéder à l'API
   - Configuration via `ALLOW_ORIGIN`

3. **Variables d'environnement**
   - Toutes les informations sensibles sont dans des fichiers `.env`
   - Les fichiers `.env` sont exclus du contrôle de version

4. **HTTPS en production**
   - Utilisation obligatoire de HTTPS en environnement `live`
   - Configuration dans `ALLOW_ORIGIN`

### Recommandations Supplémentaires

1. **Rate Limiting**
   - Implémenter un rate limiting sur les endpoints API
   - Utiliser `express-rate-limit`

2. **Authentification**
   - Ajouter une authentification utilisateur
   - Utiliser JWT ou sessions

3. **Logging**
   - Implémenter un système de logging robuste
   - Utiliser Winston ou Pino

4. **Monitoring**
   - Ajouter des métriques de performance
   - Utiliser Prometheus + Grafana

## Performance

### Optimisations Implémentées

1. **Code Splitting**
   - Vite gère automatiquement le code splitting
   - Chargement lazy des composants

2. **Caching**
   - Cache des dépendances dans le Dockerfile
   - Cache des assets statiques

3. **Minification**
   - Minification automatique en production
   - Compression des assets

### Métriques Cibles

- **Time to First Byte (TTFB)** : < 200ms
- **First Contentful Paint (FCP)** : < 1.5s
- **Time to Interactive (TTI)** : < 3s
- **Lighthouse Score** : > 90

## Tests

### Tests à Implémenter

1. **Tests Unitaires**
   - Composants React avec React Testing Library
   - Services API avec Jest
   - Backend avec Supertest

2. **Tests d'Intégration**
   - Flux complet de création de session
   - Affichage des transactions

3. **Tests E2E**
   - Cypress ou Playwright
   - Scénarios utilisateur complets

## Déploiement

### Environnements

1. **Development** : Tests et développement
2. **Staging** : Tests pré-production
3. **Production** : Environnement live

### Pipeline CI/CD

1. **Install** : Installation des dépendances
2. **Lint** : Vérification du code
3. **Build** : Compilation
4. **Test** : Exécution des tests
5. **Docker** : Construction de l'image
6. **Deploy** : Déploiement

## Monitoring et Logs

### Logs Backend

Le serveur backend log les événements suivants :
- Création de session
- Rafraîchissement de session
- Erreurs API
- Requêtes HTTP

### Logs Frontend

Les erreurs frontend sont loggées dans la console du navigateur.

### Health Checks

- **Endpoint** : `/health`
- **Fréquence** : Toutes les 30 secondes
- **Timeout** : 10 secondes

## Maintenance

### Mises à Jour

1. **Dépendances** : Mise à jour mensuelle
2. **Sécurité** : Mise à jour immédiate en cas de vulnérabilité
3. **Adyen SDK** : Suivre les releases Adyen

### Backup

- Pas de données persistantes dans l'application
- Les transactions sont stockées chez Adyen

## Support

Pour toute question technique, consultez :
- [Documentation Adyen](https://docs.adyen.com/)
- [React Documentation](https://react.dev/)
- [Vite Documentation](https://vitejs.dev/)