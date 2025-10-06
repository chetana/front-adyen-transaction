#!/bin/bash

# Script de configuration initiale du projet Adyen Transaction
# Usage: ./scripts/setup.sh

set -e

echo "🚀 Configuration initiale du projet Adyen Transaction"
echo "=================================================="
echo ""

# Vérifier Node.js
echo "📦 Vérification de Node.js..."
if ! command -v node &> /dev/null; then
    echo "❌ Node.js n'est pas installé. Veuillez installer Node.js >= 22.0.0"
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 22 ]; then
    echo "⚠️  Version de Node.js trop ancienne. Version actuelle: $(node -v)"
    echo "   Version requise: >= 22.0.0"
    exit 1
fi
echo "✅ Node.js $(node -v) détecté"

# Vérifier Yarn
echo ""
echo "📦 Vérification de Yarn..."
if ! command -v yarn &> /dev/null; then
    echo "⚠️  Yarn n'est pas installé. Installation..."
    npm install -g yarn
fi
echo "✅ Yarn $(yarn -v) détecté"

# Créer les fichiers .env s'ils n'existent pas
echo ""
echo "⚙️  Configuration des variables d'environnement..."

if [ ! -f .env ]; then
    echo "📝 Création du fichier .env..."
    cp .env.example .env
    echo "⚠️  Veuillez éditer le fichier .env avec vos informations Adyen"
else
    echo "✅ Le fichier .env existe déjà"
fi

if [ ! -f server/.env ]; then
    echo "📝 Création du fichier server/.env..."
    cp server/.env.example server/.env
    echo "⚠️  Veuillez éditer le fichier server/.env avec vos informations Adyen"
else
    echo "✅ Le fichier server/.env existe déjà"
fi

if [ ! -f .env.docker ]; then
    echo "📝 Création du fichier .env.docker..."
    cp .env.docker.example .env.docker
    echo "⚠️  Veuillez éditer le fichier .env.docker avec vos informations Adyen"
else
    echo "✅ Le fichier .env.docker existe déjà"
fi

# Installation des dépendances
echo ""
echo "📦 Installation des dépendances..."
echo "   Cela peut prendre quelques minutes..."

echo ""
echo "📦 Installation des dépendances frontend..."
yarn install

echo ""
echo "📦 Installation des dépendances backend..."
cd server && npm install && cd ..

echo ""
echo "✅ Configuration terminée !"
echo ""
echo "📋 Prochaines étapes :"
echo "   1. Éditez les fichiers .env avec vos informations Adyen"
echo "   2. Lancez le projet avec 'make dev' ou 'docker-compose up'"
echo ""
echo "📚 Documentation :"
echo "   - Guide rapide : QUICKSTART.md"
echo "   - Documentation complète : README.md"
echo "   - Exemples : EXAMPLES.md"
echo ""
echo "🎉 Bon développement !"