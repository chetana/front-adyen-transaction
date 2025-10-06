# 🚀 Migration vers l'environnement Live Adyen

## Résumé des changements

Le code a été mis à jour pour supporter correctement l'environnement **Live** d'Adyen avec le préfixe d'URL requis.

## ⚠️ Action requise

Pour utiliser l'application en mode **Live**, vous devez maintenant configurer une nouvelle variable d'environnement :

### `ADYEN_LIVE_URL_PREFIX`

Cette variable contient le préfixe unique à votre compte Adyen Live.

## 📋 Comment obtenir votre préfixe Live

1. **Connectez-vous** à votre Customer Area Live : https://ca-live.adyen.com/
2. **Naviguez** vers : **Developers** > **API URLs**
3. **Copiez** le préfixe affiché (format : `[random]-[company name]`)
   - Exemple : `1797a841fbb37ca7-AdyenDemo`

## ⚙️ Configuration

### Option 1 : Développement local

Éditez le fichier `server/.env` :

```env
PORT=8080
ADYEN_API_KEY=votre_clé_api_live
ADYEN_ENVIRONMENT=live
ADYEN_ACCOUNT_HOLDER_ID=votre_account_holder_id_live
ADYEN_LIVE_URL_PREFIX=1797a841fbb37ca7-AdyenDemo  # ← NOUVEAU
ALLOW_ORIGIN=https://votre-domaine.com
```

### Option 2 : Docker Compose

Éditez le fichier `.env.docker` :

```env
ADYEN_API_KEY=votre_clé_api_live
ADYEN_ENVIRONMENT=live
ADYEN_ACCOUNT_HOLDER_ID=votre_account_holder_id_live
ADYEN_LIVE_URL_PREFIX=1797a841fbb37ca7-AdyenDemo  # ← NOUVEAU
ALLOW_ORIGIN=https://votre-domaine.com
```

Puis démarrez :
```bash
docker-compose --env-file .env.docker up -d
```

### Option 3 : Docker run

```bash
docker run -d \
  --name adyen-transaction-prod \
  -p 80:3000 \
  -p 8080:8080 \
  -e ADYEN_API_KEY="votre_clé_api_live" \
  -e ADYEN_ENVIRONMENT="live" \
  -e ADYEN_ACCOUNT_HOLDER_ID="votre_account_holder_id_live" \
  -e ADYEN_LIVE_URL_PREFIX="1797a841fbb37ca7-AdyenDemo" \
  -e ALLOW_ORIGIN="https://votre-domaine.com" \
  --restart unless-stopped \
  adyen-transaction:latest
```

## 🧪 Validation de la configuration

Utilisez le script de test fourni :

```bash
./test-live-config.sh
```

Ce script vérifiera :
- ✅ Présence du fichier `.env`
- ✅ Variables d'environnement requises
- ✅ Préfixe Live configuré (si environnement = live)
- ✅ URLs qui seront utilisées

## 🔍 Vérification après démarrage

### 1. Vérifiez les logs au démarrage

Vous devriez voir :

```
🚀 Adyen Transaction Server running on port 8080
📍 Environment: live
🔗 Health check: http://localhost:8080/health
🌐 Balance Platform API: https://1797a841fbb37ca7-AdyenDemo-balanceplatform-api-live.adyenpayments.com
🔐 Auth API: https://1797a841fbb37ca7-AdyenDemo-authe-live.adyenpayments.com/authe/api/v1/sessions
🏷️  Live URL Prefix: ✅ Configured
```

### 2. Testez le health check

```bash
curl http://localhost:8080/health
```

Réponse attendue :
```json
{
  "status": "ok",
  "environment": "live",
  "timestamp": "2025-10-03T10:30:00.000Z",
  "config": {
    "balancePlatformApiUrl": "https://1797a841fbb37ca7-AdyenDemo-balanceplatform-api-live.adyenpayments.com",
    "authApiUrl": "https://1797a841fbb37ca7-AdyenDemo-authe-live.adyenpayments.com/authe/api/v1/sessions",
    "hasLivePrefix": true
  }
}
```

## ❌ Erreurs possibles

### Erreur : "Missing required environment variables: ADYEN_LIVE_URL_PREFIX"

**Cause** : Le préfixe Live n'est pas configuré alors que `ADYEN_ENVIRONMENT=live`

**Solution** : Ajoutez `ADYEN_LIVE_URL_PREFIX` dans votre fichier `.env`

### Erreur : "Failed to create Adyen session"

**Causes possibles** :
1. Préfixe Live incorrect
2. Clé API invalide ou expirée
3. Clé API de test utilisée avec environnement live
4. Account Holder ID incorrect

**Solution** : Vérifiez toutes vos variables d'environnement

## 📊 Différences Test vs Live

| Aspect | Test | Live |
|--------|------|------|
| **Balance Platform API** | `https://balanceplatform-api-test.adyen.com` | `https://[prefix]-balanceplatform-api-live.adyenpayments.com` |
| **Auth API** | `https://test.adyen.com/authe/api/v1/sessions` | `https://[prefix]-authe-live.adyenpayments.com/authe/api/v1/sessions` |
| **Préfixe requis** | ❌ Non | ✅ Oui |
| **Customer Area** | https://ca-test.adyen.com/ | https://ca-live.adyen.com/ |

## 📚 Documentation supplémentaire

- **Guide complet** : `LIVE_ENVIRONMENT_SETUP.md`
- **README** : Section "Déploiement en Production"
- **Adyen Docs** : https://docs.adyen.com/development-resources/live-endpoints/

## 🔒 Sécurité

- ⚠️ **Ne commitez JAMAIS** votre préfixe Live dans Git
- ⚠️ **Ne partagez JAMAIS** votre préfixe Live publiquement
- ✅ Utilisez des variables d'environnement ou secrets managers
- ✅ Le préfixe Live est différent du préfixe Test

## ✅ Checklist de migration

- [ ] Obtenir le préfixe Live depuis le Customer Area
- [ ] Ajouter `ADYEN_LIVE_URL_PREFIX` dans `.env` ou `.env.docker`
- [ ] Vérifier que `ADYEN_ENVIRONMENT=live`
- [ ] Vérifier que la clé API est bien une clé Live
- [ ] Vérifier que l'Account Holder ID est bien un ID Live
- [ ] Exécuter `./test-live-config.sh` pour valider
- [ ] Démarrer le serveur et vérifier les logs
- [ ] Tester le health check endpoint
- [ ] Tester la création d'une session Adyen
- [ ] Vérifier que les transactions s'affichent correctement

## 🆘 Support

En cas de problème, vérifiez :
1. Les logs du serveur
2. Le health check endpoint
3. La console du navigateur
4. La documentation Adyen : https://docs.adyen.com/

---

**Version** : 1.1.0  
**Date** : 2025-10-03