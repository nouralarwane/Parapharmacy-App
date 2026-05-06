# 💊 SmartShop : E-Commerce & Parapharmacie (Monorepo)

> 🚧 **Statut du projet : Work In Progress (WIP)**
> *L'architecture globale (Backend + Mobile) est en place. L'application est actuellement en phase d'ajout de fonctionnalités et d'optimisation de l'interface.*

## 📖 Présentation
**SmartShop** est une solution complète de e-commerce orientée parapharmacie. Ce dépôt est un **Monorepo** regroupant :
1. Une **Application Mobile** performante développée en Flutter pour l'expérience utilisateur.
2. Une **API REST robuste** développée avec Django REST Framework pour la gestion du catalogue, des utilisateurs et du système de commande.

L'objectif de ce projet est de consolider mes compétences en création d'architectures découplées (Client-Serveur) et en intégration d'API sur mobile.

---

## 📸 Aperçu de l'application
<div align="center">
  <img src="screenshots/Home.jpeg" width="250" alt="Accueil" style="margin: 0 10px;">
  <img src="screenshots/Cart.jpeg" width="250" alt="Cart" style="margin: 0 10px;">
  <img src="screenshots/Product.jpeg" width="250" alt="Détail Produit" style="margin: 0 10px;">
  <img src="screenshots/Profile.jpeg" width="250" alt="Profile" style="margin: 0 10px;">
</div>
*(Note: Remplace screen1.png, screen2.png par les vrais noms de tes images dans ton dossier screenshots)*

---

## 🏗️ Architecture du Projet

### 📱 1. Frontend : Application Mobile (`/SmartShop`)
* **Framework :** Flutter
* **Langage :** Dart
* **Architecture :** MVVM (Model-View-ViewModel) pour une séparation propre entre la logique métier et l'interface.
* **Gestion d'état :** Provider pour une gestion réactive de l'état de l'application (panier, authentification).

### ⚙️ 2. Backend : API REST (`/e_commerce_backend`)
* **Framework :** Django & Django REST Framework (DRF)
* **Base de données :** SQLite 
* **Architecture :** MVT (Model-View-Template) adaptée en API REST (Model-Serializer-View).
* **Authentification :** JWT (JSON Web Tokens) pour une gestion d'état *stateless* et sécurisée.

---

## 🚀 Guide d'Installation (Local)

Pour faire tourner le projet en local, vous devez lancer le serveur Django ET l'application Flutter.

### Étape 1 : Lancer le Backend (API)
```bash
# Se déplacer dans le dossier backend
cd e_commerce_backend

# Créer et activer l'environnement virtuel (Windows)
python -m venv env
env\Scripts\activate

# Installer les dépendances
pip install -r requirements.txt

# Appliquer les migrations et lancer le serveur
python manage.py migrate
python manage.py runserver

### Étape 1 : Lancer l'App Mobile

# Se déplacer dans le dossier de l'application
cd SmartShop

# Récupérer les paquets Flutter
flutter pub get

# Lancer l'application (sur émulateur ou appareil physique)
flutter run
