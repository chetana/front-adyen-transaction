#!/bin/bash

# Script pour créer les fichiers manquants
# Usage: ./SETUP_MISSING_FILES.sh

echo "📝 Création des fichiers manquants..."
echo ""

# Créer .prettierrc
echo "Création de .prettierrc..."
cat > .prettierrc << 'EOF'
{
  "semi": false,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 100,
  "arrowParens": "always"
}
EOF
echo "✅ .prettierrc créé"

# Créer .env.docker.example
echo "Création de .env.docker.example..."
cat > .env.docker.example << 'EOF'
# Docker Environment Variables
# Copy this file to .env.docker and fill in your Adyen credentials

# Port Configuration
FRONTEND_PORT=3000
BACKEND_PORT=8080

# Adyen Configuration
ADYEN_API_KEY=your_adyen_balance_platform_api_key_here
ADYEN_ENVIRONMENT=test
ADYEN_ACCOUNT_HOLDER_ID=AH00000000000000000000001

# Frontend Configuration
ALLOW_ORIGIN=http://localhost:3000
VITE_API_BASE_URL=http://localhost:8080
EOF
echo "✅ .env.docker.example créé"

# Créer .env.docker si il n'existe pas
if [ ! -f .env.docker ]; then
    echo "Création de .env.docker..."
    cp .env.docker.example .env.docker
    echo "⚠️  N'oubliez pas d'éditer .env.docker avec vos informations Adyen"
else
    echo "ℹ️  .env.docker existe déjà, pas de modification"
fi

echo ""
echo "✅ Tous les fichiers manquants ont été créés !"
echo ""
echo "📋 Prochaines étapes :"
echo "   1. Éditez .env.docker avec vos informations Adyen"
echo "   2. Lancez ./scripts/setup.sh pour configurer le projet"
echo "   3. Ou lancez directement : make dev"