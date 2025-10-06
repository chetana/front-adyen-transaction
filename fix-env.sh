#!/bin/bash

# Script pour corriger les fichiers .env
# Ce script crée les bons fichiers .env pour le frontend et le backend

echo "🔧 Correction des fichiers .env..."
echo ""

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Répertoire du projet
PROJECT_DIR="/home/cyin/djust/adyen-transaction"

# Créer le fichier .env du frontend (sans les credentials)
echo -e "${YELLOW}📝 Création du fichier .env (frontend)...${NC}"
cat > "$PROJECT_DIR/.env" << 'EOF'
# Frontend Configuration
# ⚠️ IMPORTANT: Never put your Adyen API key here!
# The API key must be in server/.env for security reasons.

# Backend API URL
VITE_API_BASE_URL=http://localhost:8080

# Adyen Environment (for display purposes only)
VITE_ADYEN_ENVIRONMENT=live
EOF

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Fichier .env créé avec succès${NC}"
else
    echo -e "${RED}❌ Erreur lors de la création du fichier .env${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Configuration terminée !${NC}"
echo ""
echo "📋 Résumé :"
echo "  - Frontend (.env) : Contient uniquement l'URL du backend"
echo "  - Backend (server/.env) : Contient les credentials Adyen (déjà configuré)"
echo ""
echo "🚀 Prochaines étapes :"
echo "  1. Redémarrer le serveur de développement"
echo "  2. Ouvrir http://localhost:3000"
echo ""
echo "Commandes :"
echo "  cd $PROJECT_DIR"
echo "  npm run dev"