#!/bin/bash

echo "🔍 Diagnostic du projet Adyen Transaction"
echo "=========================================="
echo ""

# Vérifier si le backend est en cours d'exécution
echo "1️⃣ Vérification du backend (port 8080)..."
if curl -s http://localhost:8080/health > /dev/null 2>&1; then
    echo "✅ Backend répond sur http://localhost:8080"
    echo "   Réponse du health check:"
    curl -s http://localhost:8080/health | head -20
else
    echo "❌ Backend ne répond pas sur http://localhost:8080"
    echo "   Le backend n'est peut-être pas démarré"
fi
echo ""

# Vérifier si le frontend est en cours d'exécution
echo "2️⃣ Vérification du frontend (port 3000)..."
if curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo "✅ Frontend répond sur http://localhost:3000"
else
    echo "❌ Frontend ne répond pas sur http://localhost:3000"
fi
echo ""

# Vérifier les processus Node.js
echo "3️⃣ Processus Node.js en cours d'exécution..."
ps aux | grep -E "(node|vite)" | grep -v grep | head -10
echo ""

# Vérifier les fichiers .env
echo "4️⃣ Vérification des fichiers .env..."
if [ -f .env ]; then
    echo "✅ .env existe (frontend)"
else
    echo "❌ .env manquant (frontend)"
fi

if [ -f server/.env ]; then
    echo "✅ server/.env existe (backend)"
else
    echo "❌ server/.env manquant (backend)"
fi
echo ""

# Tester l'endpoint de session Adyen
echo "5️⃣ Test de l'endpoint /adyen/session..."
if curl -s http://localhost:8080/adyen/session -X POST -H "Content-Type: application/json" > /dev/null 2>&1; then
    echo "✅ Endpoint /adyen/session répond"
    echo "   Réponse:"
    curl -s http://localhost:8080/adyen/session -X POST -H "Content-Type: application/json" | head -20
else
    echo "❌ Endpoint /adyen/session ne répond pas"
    echo "   Erreur:"
    curl -v http://localhost:8080/adyen/session -X POST -H "Content-Type: application/json" 2>&1 | tail -20
fi
echo ""

echo "=========================================="
echo "🏁 Diagnostic terminé"
echo ""
echo "💡 Conseils:"
echo "   - Si le backend ne répond pas, lancez: cd server && npm start"
echo "   - Si le frontend ne répond pas, lancez: yarn start"
echo "   - Ou utilisez: make dev (pour lancer les deux)"
echo "   - Vérifiez les logs dans la console pour plus de détails"