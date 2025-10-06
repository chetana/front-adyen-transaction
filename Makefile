.PHONY: help install dev build docker-build docker-up docker-down docker-logs clean

help: ## Affiche cette aide
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Installe toutes les dépendances
	@echo "📦 Installation des dépendances frontend..."
	yarn install
	@echo "📦 Installation des dépendances backend..."
	cd server && npm install
	@echo "✅ Installation terminée"

dev: ## Démarre l'application en mode développement
	@echo "🚀 Démarrage du mode développement..."
	@echo "⚠️  Assurez-vous d'avoir configuré les fichiers .env"
	@make -j2 dev-backend dev-frontend

dev-backend: ## Démarre uniquement le backend
	@echo "🔧 Démarrage du backend..."
	cd server && npm start

dev-frontend: ## Démarre uniquement le frontend
	@echo "⚛️  Démarrage du frontend..."
	yarn start

build: ## Compile l'application pour la production
	@echo "🏗️  Compilation de l'application..."
	yarn build
	@echo "✅ Compilation terminée"

docker-build: ## Construit l'image Docker
	@echo "🐳 Construction de l'image Docker..."
	docker-compose --env-file .env.docker build
	@echo "✅ Image Docker construite"

docker-up: ## Démarre les conteneurs Docker
	@echo "🚀 Démarrage des conteneurs..."
	docker-compose --env-file .env.docker up -d
	@echo "✅ Conteneurs démarrés"
	@echo "📍 Frontend: http://localhost:3000"
	@echo "📍 Backend: http://localhost:8080"
	@echo "📍 Health: http://localhost:8080/health"

docker-down: ## Arrête les conteneurs Docker
	@echo "🛑 Arrêt des conteneurs..."
	docker-compose down
	@echo "✅ Conteneurs arrêtés"

docker-logs: ## Affiche les logs des conteneurs
	docker-compose logs -f

docker-restart: docker-down docker-up ## Redémarre les conteneurs Docker

setup: ## Configuration initiale du projet
	@echo "⚙️  Configuration initiale..."
	@if [ ! -f .env ]; then \
		echo "📝 Création du fichier .env..."; \
		cp .env.example .env; \
		echo "⚠️  Veuillez éditer le fichier .env avec vos informations Adyen"; \
	fi
	@if [ ! -f server/.env ]; then \
		echo "📝 Création du fichier server/.env..."; \
		cp server/.env.example server/.env; \
		echo "⚠️  Veuillez éditer le fichier server/.env avec vos informations Adyen"; \
	fi
	@if [ ! -f .env.docker ]; then \
		echo "📝 Création du fichier .env.docker..."; \
		cp .env.docker.example .env.docker; \
		echo "⚠️  Veuillez éditer le fichier .env.docker avec vos informations Adyen"; \
	fi
	@echo "✅ Configuration initiale terminée"
	@echo "📝 N'oubliez pas de remplir les fichiers .env avec vos informations Adyen"

clean: ## Nettoie les fichiers générés
	@echo "🧹 Nettoyage..."
	rm -rf node_modules
	rm -rf server/node_modules
	rm -rf dist
	rm -rf build
	@echo "✅ Nettoyage terminé"

lint: ## Vérifie le code avec ESLint
	@echo "🔍 Vérification du code..."
	yarn lint

lint-fix: ## Corrige automatiquement les erreurs ESLint
	@echo "🔧 Correction du code..."
	yarn lint:fix

format: ## Formate le code avec Prettier
	@echo "✨ Formatage du code..."
	yarn prettier:format

test: ## Lance les tests
	@echo "🧪 Lancement des tests..."
	yarn test

health: ## Vérifie la santé de l'application
	@echo "🏥 Vérification de la santé..."
	@curl -s http://localhost:8080/health | json_pp || echo "❌ Le serveur ne répond pas"