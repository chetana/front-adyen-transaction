#!/bin/bash

# Script de vérification des variables d'environnement
# Usage: ./scripts/check-env.sh

set -e

echo "🔍 Vérification des variables d'environnement"
echo "=============================================="
echo ""

# Fonction pour vérifier un fichier .env
check_env_file() {
    local file=$1
    local required_vars=("${@:2}")
    
    echo "📄 Vérification de $file..."
    
    if [ ! -f "$file" ]; then
        echo "❌ Le fichier $file n'existe pas"
        echo "   Exécutez: cp ${file}.example $file"
        return 1
    fi
    
    local missing_vars=()
    local empty_vars=()
    
    for var in "${required_vars[@]}"; do
        if ! grep -q "^${var}=" "$file"; then
            missing_vars+=("$var")
        else
            value=$(grep "^${var}=" "$file" | cut -d'=' -f2-)
            if [ -z "$value" ] || [[ "$value" == *"your_"* ]] || [[ "$value" == *"here"* ]]; then
                empty_vars+=("$var")
            fi
        fi
    done
    
    if [ ${#missing_vars[@]} -gt 0 ]; then
        echo "❌ Variables manquantes:"
        printf '   - %s\n' "${missing_vars[@]}"
        return 1
    fi
    
    if [ ${#empty_vars[@]} -gt 0 ]; then
        echo "⚠️  Variables non configurées (valeurs par défaut détectées):"
        printf '   - %s\n' "${empty_vars[@]}"
        return 1
    fi
    
    echo "✅ Toutes les variables sont configurées"
    return 0
}

# Variables requises pour le frontend
FRONTEND_VARS=(
    "VITE_ADYEN_API_KEY"
    "VITE_ADYEN_ENVIRONMENT"
    "VITE_ADYEN_ACCOUNT_HOLDER_ID"
    "VITE_ALLOW_ORIGIN"
    "VITE_API_BASE_URL"
)

# Variables requises pour le backend
BACKEND_VARS=(
    "ADYEN_API_KEY"
    "ADYEN_ENVIRONMENT"
    "ADYEN_ACCOUNT_HOLDER_ID"
    "ALLOW_ORIGIN"
)

# Variables requises pour Docker
DOCKER_VARS=(
    "ADYEN_API_KEY"
    "ADYEN_ENVIRONMENT"
    "ADYEN_ACCOUNT_HOLDER_ID"
    "ALLOW_ORIGIN"
    "VITE_API_BASE_URL"
)

# Vérifier les fichiers
frontend_ok=true
backend_ok=true
docker_ok=true

echo ""
check_env_file ".env" "${FRONTEND_VARS[@]}" || frontend_ok=false

echo ""
check_env_file "server/.env" "${BACKEND_VARS[@]}" || backend_ok=false

echo ""
check_env_file ".env.docker" "${DOCKER_VARS[@]}" || docker_ok=false

# Résumé
echo ""
echo "📊 Résumé"
echo "========="
if [ "$frontend_ok" = true ] && [ "$backend_ok" = true ] && [ "$docker_ok" = true ]; then
    echo "✅ Toutes les configurations sont valides"
    echo ""
    echo "🚀 Vous pouvez maintenant lancer l'application :"
    echo "   - Mode développement : make dev"
    echo "   - Mode Docker : docker-compose --env-file .env.docker up"
    exit 0
else
    echo "❌ Certaines configurations sont incomplètes"
    echo ""
    echo "📝 Actions requises :"
    [ "$frontend_ok" = false ] && echo "   - Configurez le fichier .env"
    [ "$backend_ok" = false ] && echo "   - Configurez le fichier server/.env"
    [ "$docker_ok" = false ] && echo "   - Configurez le fichier .env.docker"
    echo ""
    echo "💡 Consultez le fichier README.md pour plus d'informations"
    exit 1
fi