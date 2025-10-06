#!/bin/bash

echo "🧪 Test de la correction"
echo "========================"
echo ""

echo "1️⃣ Test de l'endpoint /api/adyen/session..."
response=$(curl -s -w "\n%{http_code}" http://localhost:8080/api/adyen/session -X POST -H "Content-Type: application/json")
http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | head -n-1)

if [ "$http_code" = "200" ]; then
    echo "✅ Endpoint répond avec succès (200)"
    echo "   Réponse: $body"
elif [ "$http_code" = "500" ]; then
    echo "⚠️  Endpoint répond mais avec une erreur serveur (500)"
    echo "   Cela peut être normal si:"
    echo "   - Vous n'avez pas de connexion internet"
    echo "   - Les credentials Adyen sont invalides"
    echo "   - L'API Adyen n'est pas accessible"
    echo ""
    echo "   Réponse: $body"
    echo ""
    echo "   ℹ️  L'important est que l'endpoint réponde (pas d'erreur 404)"
else
    echo "❌ Endpoint ne répond pas correctement (code: $http_code)"
    echo "   Réponse: $body"
fi

echo ""
echo "========================"
echo "🏁 Test terminé"
echo ""
echo "💡 Prochaines étapes:"
echo "   1. Rechargez la page http://localhost:3000 dans votre navigateur"
echo "   2. Ouvrez la console du navigateur (F12)"
echo "   3. Vérifiez s'il y a des erreurs"
echo "   4. Le module de transaction devrait maintenant s'afficher"
echo ""
echo "   Si le module ne s'affiche toujours pas:"
echo "   - Vérifiez les logs du backend dans le terminal"
echo "   - Vérifiez les erreurs dans la console du navigateur"
echo "   - Assurez-vous que les credentials Adyen sont valides"