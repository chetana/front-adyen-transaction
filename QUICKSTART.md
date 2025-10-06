# 🚀 Guide de Démarrage Rapide - Adyen Transaction

## Démarrage en 5 minutes

### 1. Prérequis
- Docker et Docker Compose installés
- Clé API Adyen avec le rôle "Transactions Overview Component: View"
- Account Holder ID Adyen

### 2. Configuration

```bash
# Copier le fichier d'exemple
cp .env.docker.example .env.docker

# Éditer le fichier avec vos informations Adyen
nano .env.docker
```

Remplissez ces valeurs :
```env
ADYEN_API_KEY=votre_clé_api_adyen
ADYEN_ACCOUNT_HOLDER_ID=votre_account_holder_id
```

### 3. Lancement

```bash
# Construire et démarrer
docker-compose --env-file .env.docker up -d

# Voir les logs
docker-compose logs -f
```

### 4. Accès

Ouvrez votre navigateur : http://localhost:3000

### 5. Arrêt

```bash
docker-compose down
```

## Développement Local

Si vous préférez développer sans Docker :

```bash
# 1. Installer les dépendances
yarn install
cd server && npm install && cd ..

# 2. Configurer les variables d'environnement
cp .env.example .env
cp server/.env.example server/.env
# Éditer les fichiers .env avec vos informations

# 3. Démarrer le backend (terminal 1)
cd server && npm start

# 4. Démarrer le frontend (terminal 2)
yarn start
```

## Obtenir vos identifiants Adyen

1. **Clé API** : 
   - Connectez-vous à https://ca-test.adyen.com/
   - Allez dans Developers > API credentials
   - Créez ou sélectionnez une clé API
   - Assurez-vous qu'elle a le rôle "Transactions Overview Component: View"

2. **Account Holder ID** :
   - Dans le Customer Area, allez dans Balance Platform > Account holders
   - Sélectionnez votre compte
   - Copiez l'ID (format : AH00000000000000000000001)

## Problèmes courants

### Le conteneur ne démarre pas
```bash
# Vérifier les logs
docker-compose logs

# Vérifier que les ports 3000 et 8080 sont libres
lsof -i :3000
lsof -i :8080
```

### Erreur d'authentification Adyen
- Vérifiez que votre clé API est correcte
- Vérifiez que la clé a les bons rôles
- Vérifiez que l'Account Holder ID est correct

### Le composant ne s'affiche pas
- Ouvrez la console du navigateur (F12)
- Vérifiez que le backend répond : http://localhost:8080/health
- Vérifiez les logs du conteneur

## Support

Pour plus d'informations, consultez le [README.md](README.md) complet.