# Projet Mobile (Flutter + PocketBase)

Ce projet est composé de deux parties principales :
- **app/** : L'application mobile codée en Flutter.
- **server/** : Le backend et la base de données gérés par PocketBase.

---

## 🛠️ Prérequis

Avant de lancer le projet, assurez-vous d'avoir :
1. **[Flutter](https://docs.flutter.dev/get-started/install)** installé sur votre machine.
2. Un émulateur mobile (Android/iOS) démarré, un appareil physique branché, ou Google Chrome installé (pour le Web).

---

## 🚀 Instructions pour démarrer le projet

Vous aurez besoin d'ouvrir **deux terminaux distincts** pour lancer d'une part le serveur, et d'autre part l'application mobile.

### ÉTAPE 1 : Démarrer le backend (PocketBase)

Dans votre **premier terminal**, tapez les commandes suivantes pour vous placer dans le dossier du backend et lancer le serveur :

```bash
# Se déplacer dans le dossier du serveur
cd server

# Lancer la base de données / l'API
.\pocketbase.exe serve
```

> **Note :** Une fois le serveur lancé, il vous affichera deux adresses (souvent `http://127.0.0.1:8090`). 
> Vous pouvez aller sur `http://127.0.0.1:8090/_/` dans votre navigateur pour accéder au panneau d'administration de la base de données.

---

### ÉTAPE 2 : Démarrer l'application mobile (Flutter)

Dans un **second terminal**, tapez les commandes suivantes pour installer les dépendances et exécuter l'application :

```bash
# Se déplacer dans le dossier de l'application
cd app

# Télécharger/mettre à jour les dépendances Flutter du projet
flutter pub get

# Lancer l'application
flutter run
```

> **Note :** Si plusieurs appareils ou émulateurs sont disponibles, la commande `flutter run` s'arrêtera pour vous demander de choisir sur quel appareil développer (tapez le chiffre correspondant, par exemple `1` ou `2`).
