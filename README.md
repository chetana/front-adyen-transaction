# Adyen Transaction Overview

Application React pour visualiser et gérer les transactions Adyen via les composants Adyen Platform Experience.

## 📋 Prérequis

- Node.js >= 22.0.0
- Yarn >= 1.22.0
- Docker et Docker Compose (pour le déploiement containerisé)
- Compte Adyen avec accès à la Balance Platform API
- Clé API Adyen avec le rôle "Transactions Overview Component: View"

## 🏗️ Architecture

Le projet est composé de deux parties :

1. **Frontend React** (port 3000) : Interface utilisateur avec les composants Adyen
2. **Backend Node.js** (port 8080) : Serveur API pour gérer les sessions d'authentification Adyen

```
adyen-transaction/
├── src/                    # Code source React
│   ├── components/         # Composants React
│   ├── pages/             # Pages de l'application
│   ├── services/          # Services API et configuration
│   └── types/             # Types TypeScript
├── server/                # Serveur backend Node.js
│   ├── index.js          # Point d'entrée du serveur
│   └── package.json      # Dépendances backend
├── public/               # Fichiers statiques
├── Dockerfile           # Configuration Docker
├── docker-compose.yml   # Orchestration Docker
└── package.json        # Dépendances frontend
```

## 🚀 Installation et Démarrage

### Option 1 : Développement Local

#### 1. Installation des dépendances

```bash
# Frontend
cd /home/cyin/djust/adyen-transaction
yarn install

# Backend
cd server
npm install
```

#### 2. Configuration des variables d'environnement

**Frontend (.env) :**
```bash
cp .env.example .env
```

Éditez `.env` et remplissez les valeurs :
```env
VITE_ADYEN_API_KEY=your_adyen_api_key_here
VITE_ADYEN_ENVIRONMENT=test
VITE_ADYEN_ACCOUNT_HOLDER_ID=AH00000000000000000000001
VITE_ALLOW_ORIGIN=http://localhost:3000
VITE_API_BASE_URL=http://localhost:8080
```

**Backend (server/.env) :**
```bash
cd server
cp .env.example .env
```

Éditez `server/.env` et remplissez les valeurs :
```env
PORT=8080
ADYEN_API_KEY=your_adyen_balance_platform_api_key_here
ADYEN_ENVIRONMENT=test
ADYEN_ACCOUNT_HOLDER_ID=AH00000000000000000000001
ALLOW_ORIGIN=http://localhost:3000

# Pour l'environnement live uniquement :
# ADYEN_LIVE_URL_PREFIX=your_live_url_prefix_here
```

#### 3. Démarrage des serveurs

**Terminal 1 - Backend :**
```bash
cd server
npm start
```

**Terminal 2 - Frontend :**
```bash
cd /home/cyin/djust/adyen-transaction
yarn start
```

L'application sera accessible sur http://localhost:3000

### Option 2 : Docker (Recommandé pour la production)

#### 1. Configuration des variables d'environnement

```bash
cp .env.docker.example .env.docker
```

Éditez `.env.docker` et remplissez vos informations Adyen :
```env
FRONTEND_PORT=3000
BACKEND_PORT=8080
ADYEN_API_KEY=your_adyen_balance_platform_api_key_here
ADYEN_ENVIRONMENT=test
ADYEN_ACCOUNT_HOLDER_ID=AH00000000000000000000001
ADYEN_LIVE_URL_PREFIX=your_live_url_prefix_here  # Requis uniquement pour ADYEN_ENVIRONMENT=live
ALLOW_ORIGIN=http://localhost:3000
VITE_API_BASE_URL=http://localhost:8080
```

#### 2. Construction et démarrage avec Docker Compose

```bash
# Construction de l'image
docker-compose --env-file .env.docker build

# Démarrage des conteneurs
docker-compose --env-file .env.docker up -d

# Voir les logs
docker-compose logs -f

# Arrêter les conteneurs
docker-compose down
```

L'application sera accessible sur :
- Frontend : http://localhost:3000
- Backend API : http://localhost:8080
- Health check : http://localhost:8080/health

#### 3. Construction de l'image Docker seule

```bash
docker build -t adyen-transaction:latest \
  --build-arg VITE_API_BASE_URL=http://localhost:8080 \
  .
```

#### 4. Exécution du conteneur

```bash
docker run -d \
  --name adyen-transaction \
  -p 3000:3000 \
  -p 8080:8080 \
  -e ADYEN_API_KEY="your_api_key" \
  -e ADYEN_ENVIRONMENT="test" \
  -e ADYEN_ACCOUNT_HOLDER_ID="AH00000000000000000000001" \
  -e ADYEN_LIVE_URL_PREFIX="your_live_url_prefix" \
  -e ALLOW_ORIGIN="http://localhost:3000" \
  adyen-transaction:latest
```

## 🔧 Configuration Adyen

### 1. Obtenir une clé API

1. Connectez-vous à votre [Customer Area Adyen](https://ca-test.adyen.com/)
2. Allez dans **Developers** > **API credentials**
3. Créez ou sélectionnez une clé API
4. Assurez-vous que la clé a le rôle **"Transactions Overview Component: View"**
5. Pour activer les remboursements, ajoutez aussi **"Transactions Overview Component: Manage Refunds"**

### 2. Obtenir l'Account Holder ID

1. Dans le Customer Area, allez dans **Balance Platform** > **Account holders**
2. Sélectionnez le compte souhaité
3. Copiez l'ID (format : `AH00000000000000000000001`)

### 3. Environnements

- **test** : Pour le développement et les tests (https://test.adyen.com)
- **live** : Pour la production (https://live.adyen.com)

## 📦 Scripts Disponibles

### Frontend

```bash
yarn start          # Démarre le serveur de développement
yarn build          # Compile l'application pour la production
yarn preview        # Prévisualise la version de production
yarn lint           # Vérifie le code avec ESLint
yarn lint:fix       # Corrige automatiquement les erreurs ESLint
yarn prettier:check # Vérifie le formatage du code
yarn prettier:format # Formate le code avec Prettier
```

### Backend

```bash
npm start           # Démarre le serveur backend
npm run dev         # Démarre le serveur en mode watch
```

## 🔒 Sécurité

⚠️ **Important** : Ne jamais exposer votre clé API Adyen côté client !

- La clé API doit **uniquement** être utilisée côté serveur (backend)
- Le frontend communique avec le backend via l'API `/api/adyen/session`
- Le backend crée les sessions d'authentification de manière sécurisée

## 🌐 Déploiement en Production

### Variables d'environnement pour la production

```env
# Frontend
VITE_ADYEN_ENVIRONMENT=live
VITE_ALLOW_ORIGIN=https://votre-domaine.com
VITE_API_BASE_URL=https://api.votre-domaine.com

# Backend
ADYEN_API_KEY=your_live_api_key
ADYEN_ENVIRONMENT=live
ADYEN_ACCOUNT_HOLDER_ID=your_live_account_holder_id
ADYEN_LIVE_URL_PREFIX=your_live_url_prefix  # Trouvez-le dans Customer Area > Developers > API URLs
ALLOW_ORIGIN=https://votre-domaine.com
```

**⚠️ Important pour l'environnement live :**
Le préfixe d'URL live (`ADYEN_LIVE_URL_PREFIX`) est unique à votre compte Adyen. Pour le trouver :
1. Connectez-vous à votre [Customer Area Adyen](https://ca-live.adyen.com/)
2. Allez dans **Developers** > **API URLs**
3. Copiez le préfixe (format : `[random]-[company name]`, exemple : `1797a841fbb37ca7-AdyenDemo`)
4. Ce préfixe sera utilisé pour construire les URLs : `https://[prefix]-authe-live.adyenpayments.com`

### Avec Docker Compose

```bash
# Modifier .env.docker avec les valeurs de production
docker-compose --env-file .env.docker up -d
```

### Avec Docker seul

```bash
docker run -d \
  --name adyen-transaction-prod \
  -p 80:3000 \
  -p 8080:8080 \
  -e ADYEN_API_KEY="your_live_api_key" \
  -e ADYEN_ENVIRONMENT="live" \
  -e ADYEN_ACCOUNT_HOLDER_ID="your_live_account_holder_id" \
  -e ADYEN_LIVE_URL_PREFIX="your_live_url_prefix" \
  -e ALLOW_ORIGIN="https://votre-domaine.com" \
  --restart unless-stopped \
  adyen-transaction:latest
```

## 🧪 Tests

```bash
# Frontend
yarn test

# Backend
cd server
npm test
```

## 📚 Documentation

- [Adyen Platform Experience Components](https://docs.adyen.com/marketplaces-and-platforms/platform-experience-components/)
- [Adyen Balance Platform API](https://docs.adyen.com/api-explorer/balanceplatform/latest/overview)
- [Transactions Overview Component](https://docs.adyen.com/marketplaces-and-platforms/platform-experience-components/transactions-overview/)

## 🐛 Dépannage

### Erreur : "Missing required environment variables"

Vérifiez que tous les fichiers `.env` sont correctement configurés avec vos informations Adyen.

### Erreur : "Failed to create Adyen session"

1. Vérifiez que votre clé API est valide
2. Assurez-vous que la clé a les bons rôles dans le Customer Area
3. Vérifiez que l'Account Holder ID est correct
4. Vérifiez que l'environnement (test/live) correspond à votre clé API
5. **Pour l'environnement live** : Vérifiez que `ADYEN_LIVE_URL_PREFIX` est correctement configuré

### Le composant ne s'affiche pas

1. Ouvrez la console du navigateur pour voir les erreurs
2. Vérifiez que le backend est bien démarré (http://localhost:8080/health)
3. Vérifiez que les CORS sont correctement configurés

## 📝 Licence

Ce projet est privé et propriétaire.

## 👥 Support

Pour toute question ou problème, contactez l'équipe de développement.