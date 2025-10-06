#!/bin/bash

# Script de construction de l'image Docker
# Usage: ./scripts/docker-build.sh [tag]

set -e

TAG=${1:-latest}
IMAGE_NAME="adyen-transaction"

echo "🐳 Construction de l'image Docker"
echo "=================================="
echo ""
echo "Image: $IMAGE_NAME:$TAG"
echo ""

# Vérifier que Docker est installé
if ! command -v docker &> /dev/null; then
    echo "❌ Docker n'est pas installé"
    exit 1
fi

# Vérifier que le fichier .env.docker existe
if [ ! -f .env.docker ]; then
    echo "⚠️  Le fichier .env.docker n'existe pas"
    echo "   Création à partir de .env.docker.example..."
    cp .env.docker.example .env.docker
    echo "⚠️  Veuillez éditer le fichier .env.docker avant de continuer"
    exit 1
fi

# Charger les variables d'environnement
source .env.docker

# Construction de l'image
echo "🔨 Construction en cours..."
docker build \
    --build-arg VITE_API_BASE_URL="${VITE_API_BASE_URL}" \
    -t "${IMAGE_NAME}:${TAG}" \
    -t "${IMAGE_NAME}:latest" \
    .

echo ""
echo "✅ Image construite avec succès !"
echo ""
echo "📋 Informations sur l'image :"
docker images | grep "$IMAGE_NAME"

echo ""
echo "🚀 Pour lancer le conteneur :"
echo "   docker run -d \\"
echo "     --name adyen-transaction \\"
echo "     -p 3000:3000 \\"
echo "     -p 8080:8080 \\"
echo "     -e ADYEN_API_KEY=\"\${ADYEN_API_KEY}\" \\"
echo "     -e ADYEN_ENVIRONMENT=\"\${ADYEN_ENVIRONMENT}\" \\"
echo "     -e ADYEN_ACCOUNT_HOLDER_ID=\"\${ADYEN_ACCOUNT_HOLDER_ID}\" \\"
echo "     -e ALLOW_ORIGIN=\"\${ALLOW_ORIGIN}\" \\"
echo "     ${IMAGE_NAME}:${TAG}"
echo ""
echo "Ou utilisez Docker Compose :"
echo "   docker-compose --env-file .env.docker up -d"