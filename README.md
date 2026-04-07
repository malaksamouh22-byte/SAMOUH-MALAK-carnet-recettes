# 🍳 Carnet de Recettes

##  Description

**Carnet de Recettes** est une application web développée en Swift avec le framework Hummingbird.
Elle permet aux utilisateurs d’ajouter, consulter, supprimer et marquer comme favoris leurs recettes de cuisine.

L’application utilise une base de données SQLite pour stocker les recettes de manière persistante.

---

## ⚙️ Fonctionnalités

*  Ajouter une recette
*  Afficher la liste des recettes
*  Marquer une recette comme favorite
*  Supprimer une recette
*  Rechercher et filtrer les recettes (nom, catégorie, favoris)
*  Interface moderne et responsive

---

##  Structure du projet

* `main.swift` → Configuration du serveur et des routes
* `Database.swift` → Gestion de la base de données SQLite
* `Models.swift` → Définition des modèles (Recipe)
* `Views.swift` → Génération de l’interface HTML

---

##  Routes exposées

| Méthode | Route           | Description                                         |
| ------- | --------------- | --------------------------------------------------- |
| GET     | `/`             | Affiche la page principale avec toutes les recettes |
| POST    | `/create`       | Ajoute une nouvelle recette                         |
| POST    | `/delete/:id`   | Supprime une recette                                |
| POST    | `/favorite/:id` | Active/désactive le statut favori                   |

---

##  Lancer l’application

### 1. Installer les dépendances

```bash
swift package resolve
```

### 2. Compiler le projet

```bash
swift build
```

### 3. Lancer le serveur

```bash
swift run App
```

---

## 🌍 Accès à l’application

Une fois lancée, l’application est accessible via :

```
http://localhost:8080
```

ou via l’URL fournie par GitHub Codespaces.

---

##  Utilisation

1. Remplir le formulaire pour ajouter une recette
2. Cliquer sur "Ajouter"
3. Consulter la liste des recettes
4. Utiliser les boutons pour :

   * supprimer une recette
   * marquer comme favorite
5. Utiliser les filtres pour rechercher

---

##  Technologies utilisées

* Swift
* Hummingbird (framework web)
* SQLite
* HTML / CSS / JavaScript

---

##  Auteur

Projet réalisé par **Malak Samouh** dans le cadre du cours de développement Swift.

---

## 📄 Licence

Ce projet est fourni à des fins éducatives.
