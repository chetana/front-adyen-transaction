# Changelog

Tous les changements notables de ce projet seront documentés dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/),
et ce projet adhère au [Semantic Versioning](https://semver.org/lang/fr/).

## [1.0.0] - 2024-01-15

### Ajouté
- ✨ Intégration initiale des composants Adyen Platform Experience
- ✨ Composant TransactionsOverview pour afficher la liste des transactions
- ✨ Composant TransactionDetails pour afficher les détails d'une transaction
- ✨ Serveur backend Node.js/Express pour gérer les sessions Adyen
- ✨ Configuration Docker et Docker Compose
- ✨ Pipeline GitLab CI/CD
- ✨ Documentation complète (README, TECHNICAL, EXAMPLES, QUICKSTART)
- ✨ Gestion des variables d'environnement
- ✨ Health check endpoint
- ✨ Support des environnements test et live
- ✨ Gestion des erreurs et validation de configuration
- ✨ Makefile pour faciliter les commandes courantes

### Sécurité
- 🔒 Clé API Adyen stockée uniquement côté serveur
- 🔒 Configuration CORS pour limiter les origines autorisées
- 🔒 Variables d'environnement pour toutes les informations sensibles
- 🔒 Validation des variables d'environnement au démarrage

### Documentation
- 📚 README.md avec guide d'installation complet
- 📚 QUICKSTART.md pour démarrage rapide
- 📚 TECHNICAL.md avec architecture détaillée
- 📚 EXAMPLES.md avec exemples d'utilisation
- 📚 Commentaires dans le code

### DevOps
- 🐳 Dockerfile multi-stage pour optimiser la taille de l'image
- 🐳 Docker Compose pour orchestration facile
- 🔄 Pipeline GitLab CI/CD avec stages (install, lint, build, test, docker, deploy)
- 🔄 Health checks pour monitoring

## [1.1.0] - 2025-10-03

### Ajouté
- ✨ Support du préfixe d'URL Live pour Adyen (`ADYEN_LIVE_URL_PREFIX`)
- 📚 Documentation `LIVE_ENVIRONMENT_SETUP.md` pour la configuration Live
- 🧪 Script de test `test-live-config.sh` pour valider la configuration
- 🔧 Affichage des URLs configurées dans le health check endpoint
- 🔧 Messages d'erreur détaillés si le préfixe Live est manquant

### Modifié
- 🔧 Construction dynamique des URLs Adyen en fonction de l'environnement
- 📚 Mise à jour du README avec instructions pour le préfixe Live
- 🔧 Validation des variables d'environnement améliorée
- 🐳 Docker Compose mis à jour avec la nouvelle variable d'environnement

### Corrigé
- 🐛 URL d'authentification Adyen incorrecte pour l'environnement Live
- 🐛 URL de Balance Platform API incorrecte pour l'environnement Live

## [Non publié]

### À venir
- 🚧 Tests unitaires avec Jest et React Testing Library
- 🚧 Tests E2E avec Cypress
- 🚧 Authentification utilisateur
- 🚧 Rate limiting sur l'API
- 🚧 Logging avancé avec Winston
- 🚧 Monitoring avec Prometheus
- 🚧 Support multi-langues (i18n)
- 🚧 Thème sombre
- 🚧 Export des transactions en CSV/Excel
- 🚧 Filtres avancés
- 🚧 Recherche de transactions
- 🚧 Notifications en temps réel

### Idées futures
- 💡 Dashboard avec statistiques
- 💡 Graphiques et visualisations
- 💡 Rapports personnalisables
- 💡 Webhooks pour événements de transaction
- 💡 API REST pour intégration externe
- 💡 Mobile app (React Native)

---

## Format des Entrées

### Types de changements
- `Ajouté` pour les nouvelles fonctionnalités
- `Modifié` pour les changements dans les fonctionnalités existantes
- `Déprécié` pour les fonctionnalités qui seront bientôt supprimées
- `Supprimé` pour les fonctionnalités supprimées
- `Corrigé` pour les corrections de bugs
- `Sécurité` pour les vulnérabilités corrigées

### Emojis
- ✨ Nouvelle fonctionnalité
- 🐛 Correction de bug
- 🔒 Sécurité
- 📚 Documentation
- 🚀 Performance
- 🎨 UI/UX
- 🔧 Configuration
- 🐳 Docker
- 🔄 CI/CD
- 🧪 Tests
- 🚧 En cours
- 💡 Idée