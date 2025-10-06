# Backend Server - Adyen Transaction

Serveur Node.js/Express pour gérer les sessions d'authentification Adyen.

## 🎯 Objectif

Ce serveur backend agit comme un proxy sécurisé entre le frontend React et l'API Adyen. Il est responsable de :

1. Créer des sessions d'authentification Adyen
2. Rafraîchir les sessions expirées
3. Protéger la clé API Adyen (ne jamais l'exposer au client)

## 📦 Installation

```bash
npm install
```

## ⚙️ Configuration

Créez un fichier `.env` à partir de `.env.example` :

```bash
cp .env.example .env
```

Éditez `.env` avec vos informations Adyen :

```env
PORT=8080
ADYEN_API_KEY=your_adyen_balance_platform_api_key_here
ADYEN_ENVIRONMENT=test
ADYEN_ACCOUNT_HOLDER_ID=AH00000000000000000000001
ALLOW_ORIGIN=http://localhost:3000
```

## 🚀 Démarrage

### Mode développement

```bash
npm start
```

### Mode watch (redémarre automatiquement)

```bash
npm run dev
```

Le serveur démarre sur http://localhost:8080

## 📡 API Endpoints

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

**Erreurs possibles:**
- `500` : Erreur lors de la création de la session
- `401` : Clé API invalide
- `403` : Permissions insuffisantes

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

## 🔒 Sécurité

### Bonnes pratiques implémentées

1. **Clé API côté serveur uniquement**
   - La clé API n'est jamais exposée au client
   - Toutes les requêtes Adyen passent par ce serveur

2. **CORS configuré**
   - Seules les origines autorisées peuvent accéder à l'API
   - Configuration via `ALLOW_ORIGIN`

3. **Variables d'environnement**
   - Toutes les informations sensibles sont dans `.env`
   - Le fichier `.env` est exclu du contrôle de version

4. **Validation des variables**
   - Le serveur vérifie que toutes les variables requises sont présentes
   - Arrêt immédiat si une variable manque

### Recommandations supplémentaires

Pour la production, ajoutez :

1. **Rate Limiting**
```javascript
import rateLimit from 'express-rate-limit'

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limite à 100 requêtes par fenêtre
})

app.use('/api/', limiter)
```

2. **Helmet pour la sécurité HTTP**
```javascript
import helmet from 'helmet'
app.use(helmet())
```

3. **Logging**
```javascript
import winston from 'winston'

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' })
  ]
})
```

## 🐛 Dépannage

### Erreur : "Missing required environment variables"

Vérifiez que votre fichier `.env` contient toutes les variables requises :
- `ADYEN_API_KEY`
- `ADYEN_ENVIRONMENT`
- `ADYEN_ACCOUNT_HOLDER_ID`
- `ALLOW_ORIGIN`

### Erreur : "Failed to create Adyen session"

1. Vérifiez que votre clé API est valide
2. Assurez-vous que la clé a le rôle "Transactions Overview Component: View"
3. Vérifiez que l'Account Holder ID est correct
4. Vérifiez que l'environnement (test/live) correspond à votre clé API

### Port déjà utilisé

Si le port 8080 est déjà utilisé, changez-le dans `.env` :
```env
PORT=8081
```

N'oubliez pas de mettre à jour `VITE_API_BASE_URL` dans le frontend.

### CORS Error

Si vous obtenez une erreur CORS, vérifiez que `ALLOW_ORIGIN` correspond exactement à l'URL de votre frontend :
```env
ALLOW_ORIGIN=http://localhost:3000
```

## 📊 Logs

Le serveur log les événements suivants :

- ✅ Démarrage du serveur
- 📝 Création de session
- 🔄 Rafraîchissement de session
- ❌ Erreurs API

Exemple de logs :
```
🚀 Adyen Transaction Server running on port 8080
📍 Environment: test
🔗 Health check: http://localhost:8080/health
📝 Creating Adyen session...
✅ Adyen session created successfully
```

## 🧪 Tests

Pour ajouter des tests (à implémenter) :

```bash
npm install --save-dev jest supertest
```

Exemple de test :

```javascript
import request from 'supertest'
import app from './index.js'

describe('POST /api/adyen/session', () => {
  it('should create a session', async () => {
    const response = await request(app)
      .post('/api/adyen/session')
      .expect(200)
    
    expect(response.body).toHaveProperty('id')
    expect(response.body).toHaveProperty('token')
  })
})
```

## 📚 Documentation

- [Express.js](https://expressjs.com/)
- [Adyen Balance Platform API](https://docs.adyen.com/api-explorer/balanceplatform/latest/overview)
- [Adyen Authentication API](https://docs.adyen.com/marketplaces-and-platforms/platform-experience-components/authentication/)

## 🔗 Liens Utiles

- Documentation principale : `../README.md`
- Documentation technique : `../TECHNICAL.md`
- Exemples : `../EXAMPLES.md`