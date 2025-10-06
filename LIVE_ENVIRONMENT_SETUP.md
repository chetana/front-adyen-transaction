# Configuration de l'environnement Live Adyen

## 🔴 Important : Préfixe d'URL Live

Pour utiliser l'application avec l'environnement **live** d'Adyen, vous devez configurer un **préfixe d'URL unique** à votre compte.

### Pourquoi ce préfixe ?

Adyen utilise des URLs différentes pour l'environnement de production (live) :
- **Test** : URLs génériques comme `https://test.adyen.com`
- **Live** : URLs personnalisées comme `https://[votre-prefix]-authe-live.adyenpayments.com`

Ce préfixe est unique à votre compte et améliore la sécurité et les performances.

## 📋 Comment trouver votre préfixe Live

1. Connectez-vous à votre [Customer Area Adyen Live](https://ca-live.adyen.com/)
2. Allez dans **Developers** > **API URLs**
3. Vous verrez vos URLs d'API avec le préfixe
4. Le préfixe a le format : `[random]-[company name]`
   - Exemple : `1797a841fbb37ca7-AdyenDemo`

## ⚙️ Configuration

### Variables d'environnement requises

Ajoutez cette variable dans votre fichier `.env` du serveur :

```env
ADYEN_LIVE_URL_PREFIX=1797a841fbb37ca7-AdyenDemo
```

### URLs construites automatiquement

Avec ce préfixe, l'application construira automatiquement les URLs suivantes :

1. **Balance Platform API** :
   ```
   https://1797a841fbb37ca7-AdyenDemo-balanceplatform-api-live.adyenpayments.com
   ```

2. **Authentication API** :
   ```
   https://1797a841fbb37ca7-AdyenDemo-authe-live.adyenpayments.com/authe/api/v1/sessions
   ```

## 🚀 Exemple de configuration complète

### Fichier `server/.env` pour Live

```env
PORT=8080
ADYEN_API_KEY=AQEyhmfxK4rPaBxLw0m...  # Votre clé API Live
ADYEN_ENVIRONMENT=live
ADYEN_ACCOUNT_HOLDER_ID=AH32272223222B5GXD2P5QPCF
ADYEN_LIVE_URL_PREFIX=1797a841fbb37ca7-AdyenDemo
ALLOW_ORIGIN=https://votre-domaine.com
```

### Avec Docker

```bash
docker run -d \
  --name adyen-transaction-prod \
  -p 80:3000 \
  -p 8080:8080 \
  -e ADYEN_API_KEY="AQEyhmfxK4rPaBxLw0m..." \
  -e ADYEN_ENVIRONMENT="live" \
  -e ADYEN_ACCOUNT_HOLDER_ID="AH32272223222B5GXD2P5QPCF" \
  -e ADYEN_LIVE_URL_PREFIX="1797a841fbb37ca7-AdyenDemo" \
  -e ALLOW_ORIGIN="https://votre-domaine.com" \
  --restart unless-stopped \
  adyen-transaction:latest
```

## ✅ Validation

Au démarrage du serveur, si le préfixe est manquant en mode live, vous verrez :

```
❌ Missing required environment variables: ADYEN_LIVE_URL_PREFIX
ℹ️  For live environment, you need to set ADYEN_LIVE_URL_PREFIX
   Example: ADYEN_LIVE_URL_PREFIX=1797a841fbb37ca7-AdyenDemo
   Find your prefix in Adyen Customer Area > Developers > API URLs
```

## 🔒 Sécurité

- ⚠️ Ne commitez **jamais** votre préfixe live dans Git
- Utilisez des variables d'environnement ou des secrets managers
- Le préfixe live est différent du préfixe test

## 📚 Références

- [Adyen API URLs Documentation](https://docs.adyen.com/development-resources/live-endpoints/)
- [Balance Platform API](https://docs.adyen.com/api-explorer/balanceplatform/latest/overview)
- [Authentication API](https://docs.adyen.com/marketplaces-and-platforms/platform-experience-components/authentication/)