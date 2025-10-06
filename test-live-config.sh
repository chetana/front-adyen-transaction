#!/bin/bash

# Script de test pour valider la configuration Live d'Adyen
# Usage: ./test-live-config.sh

echo "🧪 Test de configuration Adyen Live"
echo "===================================="
echo ""

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Vérifier si le fichier .env existe
if [ ! -f "server/.env" ]; then
    echo -e "${RED}❌ Fichier server/.env non trouvé${NC}"
    echo "   Créez-le à partir de server/.env.example"
    exit 1
fi

# Charger les variables d'environnement
source server/.env

echo "📋 Variables d'environnement détectées :"
echo "   ADYEN_ENVIRONMENT: ${ADYEN_ENVIRONMENT:-non défini}"
echo "   ADYEN_ACCOUNT_HOLDER_ID: ${ADYEN_ACCOUNT_HOLDER_ID:-non défini}"
echo "   ADYEN_API_KEY: ${ADYEN_API_KEY:0:20}... (${#ADYEN_API_KEY} caractères)"
echo ""

# Vérifier l'environnement
if [ "$ADYEN_ENVIRONMENT" = "live" ]; then
    echo -e "${YELLOW}🔴 Mode LIVE détecté${NC}"
    echo ""
    
    # Vérifier le préfixe Live
    if [ -z "$ADYEN_LIVE_URL_PREFIX" ]; then
        echo -e "${RED}❌ ERREUR : ADYEN_LIVE_URL_PREFIX n'est pas défini${NC}"
        echo ""
        echo "Pour l'environnement live, vous devez définir ADYEN_LIVE_URL_PREFIX"
        echo ""
        echo "Comment le trouver :"
        echo "1. Connectez-vous à https://ca-live.adyen.com/"
        echo "2. Allez dans Developers > API URLs"
        echo "3. Copiez le préfixe (format: [random]-[company name])"
        echo ""
        echo "Exemple dans server/.env :"
        echo "ADYEN_LIVE_URL_PREFIX=1797a841fbb37ca7-AdyenDemo"
        echo ""
        exit 1
    else
        echo -e "${GREEN}✅ ADYEN_LIVE_URL_PREFIX est défini : $ADYEN_LIVE_URL_PREFIX${NC}"
        echo ""
        echo "URLs qui seront utilisées :"
        echo "   Balance Platform API:"
        echo "   https://${ADYEN_LIVE_URL_PREFIX}-balanceplatform-api-live.adyenpayments.com"
        echo ""
        echo "   Authentication API:"
        echo "   https://${ADYEN_LIVE_URL_PREFIX}-authe-live.adyenpayments.com/authe/api/v1/sessions"
        echo ""
    fi
elif [ "$ADYEN_ENVIRONMENT" = "test" ]; then
    echo -e "${GREEN}🟢 Mode TEST détecté${NC}"
    echo ""
    echo "URLs qui seront utilisées :"
    echo "   Balance Platform API:"
    echo "   https://balanceplatform-api-test.adyen.com"
    echo ""
    echo "   Authentication API:"
    echo "   https://test.adyen.com/authe/api/v1/sessions"
    echo ""
    
    if [ ! -z "$ADYEN_LIVE_URL_PREFIX" ]; then
        echo -e "${YELLOW}⚠️  Note : ADYEN_LIVE_URL_PREFIX est défini mais ne sera pas utilisé en mode test${NC}"
        echo ""
    fi
else
    echo -e "${RED}❌ ERREUR : ADYEN_ENVIRONMENT doit être 'test' ou 'live'${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Configuration valide !${NC}"
echo ""
echo "Pour démarrer le serveur :"
echo "   cd server && npm start"
echo ""
echo "Pour tester le health check :"
echo "   curl http://localhost:8080/health"