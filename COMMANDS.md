# 📝 Commandes Utiles - Adyen Transaction

Guide de référence rapide pour toutes les commandes du projet.

## 🚀 Démarrage Rapide

```bash
# Configuration initiale complète
./SETUP_MISSING_FILES.sh    # Créer les fichiers manquants
./scripts/setup.sh           # Configuration automatique
./scripts/check-env.sh       # Vérifier la configuration
make dev                     # Démarrer en mode développement
```

## 📦 Installation

### Installation des dépendances

```bash
# Frontend
yarn install

# Backend
cd server && npm install

# Tout en une fois
make install
```

### Configuration initiale

```bash
# Script automatique
./scripts/setup.sh

# Ou manuellement
cp .env.example .env
cp server/.env.example server/.env
cp .env.docker.example .env.docker
```

## 🔧 Développement

### Démarrer l'application

```bash
# Frontend + Backend ensemble
make dev

# Frontend uniquement
make dev-frontend
# ou
yarn start

# Backend uniquement
make dev-backend
# ou
cd server && npm start
```

### Vérifications

```bash
# Vérifier la configuration
./scripts/check-env.sh

# Vérifier le code (lint)
make lint
yarn lint

# Formater le code
make format
yarn prettier:format

# Corriger automatiquement les erreurs
make lint-fix
yarn lint:fix
```

## 🏗️ Build

### Compilation

```bash
# Compiler pour la production
make build
# ou
yarn build

# Prévisualiser la version de production
yarn preview
```

## 🐳 Docker

### Construction de l'image

```bash
# Avec make
make docker-build

# Avec le script
./scripts/docker-build.sh

# Avec docker-compose
docker-compose --env-file .env.docker build

# Avec docker directement
docker build -t adyen-transaction:latest .
```

### Démarrage des conteneurs

```bash
# Avec make
make docker-up

# Avec docker-compose
docker-compose --env-file .env.docker up -d

# Voir les logs
make docker-logs
# ou
docker-compose logs -f

# Arrêter les conteneurs
make docker-down
# ou
docker-compose down

# Redémarrer
make docker-restart
```

### Gestion des conteneurs

```bash
# Voir les conteneurs en cours
docker ps

# Voir tous les conteneurs
docker ps -a

# Voir les logs d'un conteneur spécifique
docker logs adyen-transaction

# Entrer dans un conteneur
docker exec -it adyen-transaction sh

# Supprimer un conteneur
docker rm adyen-transaction

# Supprimer l'image
docker rmi adyen-transaction:latest
```

## 🧪 Tests

```bash
# Lancer les tests
make test
# ou
yarn test

# Tests en mode watch
yarn test --watch

# Tests avec couverture
yarn test --coverage
```

## 🧹 Nettoyage

```bash
# Nettoyer les fichiers générés
make clean

# Nettoyer les node_modules
rm -rf node_modules server/node_modules

# Nettoyer les builds
rm -rf dist build

# Nettoyer Docker
docker-compose down -v
docker system prune -a
```

## 🔍 Vérifications

### Santé de l'application

```bash
# Vérifier le backend
make health
# ou
curl http://localhost:8080/health

# Vérifier le frontend
curl http://localhost:3000
```

### Vérifier les ports

```bash
# Voir ce qui utilise le port 3000
lsof -i :3000

# Voir ce qui utilise le port 8080
lsof -i :8080

# Tuer un processus sur un port
kill -9 $(lsof -t -i:3000)
```

## 📊 Logs

### Voir les logs

```bash
# Logs Docker
docker-compose logs -f

# Logs d'un service spécifique
docker-compose logs -f adyen-transaction

# Logs du backend (en dev)
cd server && npm start
# Les logs s'affichent dans le terminal

# Logs du frontend (en dev)
yarn start
# Les logs s'affichent dans le terminal
```

## 🔄 Git

### Commandes Git courantes

```bash
# Initialiser le repo (si pas déjà fait)
git init

# Ajouter tous les fichiers
git add .

# Commit
git commit -m "Initial commit: Adyen Transaction project"

# Ajouter un remote
git remote add origin <url-du-repo>

# Push
git push -u origin main

# Voir le statut
git status

# Voir les différences
git diff
```

## 🌐 URLs de l'Application

```bash
# Frontend
http://localhost:3000

# Backend API
http://localhost:8080

# Health check
http://localhost:8080/health

# Créer une session (avec curl)
curl -X POST http://localhost:8080/api/adyen/session
```

## 🔑 Variables d'Environnement

### Afficher les variables

```bash
# Frontend
cat .env

# Backend
cat server/.env

# Docker
cat .env.docker
```

### Éditer les variables

```bash
# Frontend
nano .env
# ou
vim .env

# Backend
nano server/.env

# Docker
nano .env.docker
```

## 📝 Scripts Personnalisés

### Créer un nouveau composant

```bash
# Créer un nouveau composant React
mkdir -p src/components/MonComposant
touch src/components/MonComposant/MonComposant.tsx
touch src/components/MonComposant/index.ts
```

### Ajouter une nouvelle page

```bash
# Créer une nouvelle page
touch src/pages/MaNouvellePage.tsx
```

## 🔧 Dépannage

### Réinstaller les dépendances

```bash
# Frontend
rm -rf node_modules yarn.lock
yarn install

# Backend
cd server
rm -rf node_modules package-lock.json
npm install
```

### Réinitialiser complètement

```bash
# Nettoyer tout
make clean
rm -rf node_modules server/node_modules
rm -rf dist build

# Réinstaller
make install

# Reconfigurer
./scripts/setup.sh
```

### Problèmes de cache

```bash
# Nettoyer le cache Vite
rm -rf node_modules/.vite

# Nettoyer le cache Yarn
yarn cache clean

# Nettoyer le cache npm
npm cache clean --force
```

## 📚 Documentation

### Générer la documentation

```bash
# Si vous ajoutez TypeDoc
npx typedoc --out docs src
```

### Voir la documentation

```bash
# Ouvrir le README
cat README.md

# Ouvrir le guide rapide
cat QUICKSTART.md

# Ouvrir la doc technique
cat TECHNICAL.md

# Ouvrir les exemples
cat EXAMPLES.md
```

## 🚀 Déploiement

### Build pour la production

```bash
# Build frontend
yarn build

# Tester le build localement
yarn preview
```

### Déployer avec Docker

```bash
# Build l'image
docker build -t adyen-transaction:prod .

# Tag pour le registry
docker tag adyen-transaction:prod registry.example.com/adyen-transaction:latest

# Push vers le registry
docker push registry.example.com/adyen-transaction:latest

# Déployer sur le serveur
ssh user@server "cd /opt/adyen-transaction && docker-compose pull && docker-compose up -d"
```

## 💡 Astuces

### Alias utiles

Ajoutez ces alias dans votre `~/.bashrc` ou `~/.zshrc` :

```bash
# Alias pour le projet
alias adyen-dev='cd /home/cyin/djust/adyen-transaction && make dev'
alias adyen-build='cd /home/cyin/djust/adyen-transaction && make build'
alias adyen-docker='cd /home/cyin/djust/adyen-transaction && make docker-up'
alias adyen-logs='cd /home/cyin/djust/adyen-transaction && make docker-logs'
```

### Raccourcis Make

```bash
make help           # Affiche toutes les commandes disponibles
make setup          # Configuration initiale
make dev            # Développement
make build          # Build production
make docker-up      # Démarrer Docker
make docker-down    # Arrêter Docker
make clean          # Nettoyer
```

## 📞 Aide

### Obtenir de l'aide

```bash
# Aide Make
make help

# Aide Yarn
yarn --help

# Aide npm
npm help

# Aide Docker
docker --help
docker-compose --help
```

### Ressources

- Documentation Adyen : https://docs.adyen.com/
- Documentation React : https://react.dev/
- Documentation Vite : https://vitejs.dev/
- Documentation Docker : https://docs.docker.com/

---

**💡 Conseil** : Gardez ce fichier à portée de main pour référence rapide !