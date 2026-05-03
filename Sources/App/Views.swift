struct Views {
    static func index(recipes: [Recipe]) -> String {
        let categories = Array(Set(recipes.map { $0.category })).sorted()

        let categoryOptions = categories.map { category in
            "<option value=\"\(category)\">\(category)</option>"
        }.joined()

        let recipesCount = recipes.count
        let favoritesCount = recipes.filter { $0.isFavorite }.count

        let list = recipes.map { recipe in
            """
            <div class="recipe-card" data-category="\(recipe.category)" data-favorite="\(recipe.isFavorite ? "true" : "false")" data-name="\(recipe.name.lowercased())">
                <div class="recipe-top">
                    <div>
                        <h3>\(recipe.name)</h3>
                        <span class="badge">\(recipe.category)</span>
                    </div>
                    <div class="favorite-pill \(recipe.isFavorite ? "favorite-on" : "favorite-off")">
                        \(recipe.isFavorite ? "⭐ Favori" : "☆ Normal")
                    </div>
                </div>

                <div class="recipe-block">
                    <h4>Ingrédients</h4>
                    <p>\(recipe.ingredients)</p>
                </div>

                <div class="recipe-block">
                    <h4>Étapes</h4>
                    <p>\(recipe.steps)</p>
                </div>

                <div class="recipe-actions">
                    <form action="/favorite/\(recipe.id!)" method="post">
                        <button type="submit" class="btn btn-light">
                            \(recipe.isFavorite ? "Retirer favori" : "Mettre en favori")
                        </button>
                    </form>

                    <form action="/delete/\(recipe.id!)" method="post" onsubmit="return confirm('Supprimer cette recette ?');">
                        <button type="submit" class="btn btn-danger">Supprimer</button>
                    </form>
                </div>
            </div>
            """
        }.joined()

        return """
            <!DOCTYPE html>
            <html lang="fr">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Carnet de recettes</title>
                <style>
                    * {
                        box-sizing: border-box;
                    }

                    body {
                        margin: 0;
                        font-family: "Segoe UI", Arial, sans-serif;
                        background:
                            radial-gradient(circle at top left, #fff1f2 0%, transparent 30%),
                            radial-gradient(circle at top right, #fee2e2 0%, transparent 25%),
                            linear-gradient(180deg, #fff5f5 0%, #f8fafc 100%);
                        color: #1f2937;
                    }

                    .container {
                        max-width: 1120px;
                        margin: 0 auto;
                        padding: 28px 18px 60px;
                    }

                    .hero {
                        background: linear-gradient(135deg, #ef4444 0%, #dc2626 50%, #b91c1c 100%);
                        color: white;
                        border-radius: 30px;
                        padding: 34px 34px 30px;
                        box-shadow: 0 18px 40px rgba(185, 28, 28, 0.28);
                        position: relative;
                        overflow: hidden;
                        margin-bottom: 24px;
                    }

                    .hero::after {
                        content: "";
                        position: absolute;
                        right: -40px;
                        top: -40px;
                        width: 180px;
                        height: 180px;
                        background: rgba(255,255,255,0.10);
                        border-radius: 50%;
                    }

                    .hero h1 {
                        margin: 0 0 10px;
                        font-size: 48px;
                        line-height: 1.1;
                        position: relative;
                        z-index: 1;
                    }

                    .hero p {
                        margin: 0;
                        font-size: 21px;
                        opacity: 0.96;
                        position: relative;
                        z-index: 1;
                    }

                    .stats {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
                        gap: 18px;
                        margin-bottom: 26px;
                    }

                    .stat-card {
                        background: rgba(255, 255, 255, 0.88);
                        backdrop-filter: blur(8px);
                        border: 1px solid rgba(255,255,255,0.7);
                        border-radius: 24px;
                        padding: 22px 24px;
                        box-shadow: 0 12px 30px rgba(15, 23, 42, 0.08);
                        position: relative;
                        overflow: hidden;
                    }

                    .stat-card::before {
                        content: "";
                        position: absolute;
                        left: 0;
                        top: 0;
                        width: 6px;
                        height: 100%;
                        background: linear-gradient(180deg, #ef4444, #b91c1c);
                    }

                    .stat-card h3 {
                        margin: 0 0 14px;
                        font-size: 15px;
                        color: #6b7280;
                        font-weight: 600;
                    }

                    .stat-card p {
                        margin: 0;
                        font-size: 46px;
                        line-height: 1;
                        font-weight: 800;
                        color: #dc2626;
                    }

                    .panel {
                        background: rgba(255,255,255,0.88);
                        backdrop-filter: blur(8px);
                        border: 1px solid rgba(255,255,255,0.7);
                        border-radius: 28px;
                        padding: 28px;
                        box-shadow: 0 16px 34px rgba(15, 23, 42, 0.08);
                        margin-bottom: 24px;
                    }

                    .panel h2 {
                        margin: 0 0 20px;
                        color: #b91c1c;
                        font-size: 24px;
                    }

                    .form-grid {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 16px;
                    }

                    .full {
                        grid-column: 1 / -1;
                    }

                    input, textarea, select {
                        width: 100%;
                        padding: 16px 18px;
                        border: 1px solid #e5e7eb;
                        border-radius: 18px;
                        font-size: 16px;
                        background: #fff;
                        outline: none;
                        transition: 0.2s ease;
                        box-shadow: inset 0 1px 2px rgba(0,0,0,0.03);
                    }

                    input:focus, textarea:focus, select:focus {
                        border-color: #ef4444;
                        box-shadow: 0 0 0 4px rgba(239, 68, 68, 0.12);
                    }

                    textarea {
                        min-height: 120px;
                        resize: vertical;
                    }

                    .submit-row {
                        margin-top: 6px;
                    }

                    .btn {
                        border: none;
                        border-radius: 16px;
                        padding: 13px 20px;
                        font-size: 15px;
                        font-weight: 700;
                        cursor: pointer;
                        transition: transform 0.18s ease, box-shadow 0.18s ease, opacity 0.18s ease;
                    }

                    .btn:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 10px 20px rgba(0,0,0,0.10);
                    }

                    .btn:active {
                        transform: translateY(0);
                    }

                    .btn-primary {
                        background: linear-gradient(135deg, #ef4444, #dc2626);
                        color: white;
                    }

                    .btn-light {
                        background: #fff1f2;
                        color: #b91c1c;
                    }

                    .btn-danger {
                        background: linear-gradient(135deg, #b91c1c, #991b1b);
                        color: white;
                    }

                    .filters {
                        display: grid;
                        grid-template-columns: 1.4fr 1fr 1fr;
                        gap: 14px;
                    }

                    .recipes-grid {
                        display: grid;
                        gap: 20px;
                    }

                    .recipe-card {
                        background: rgba(255,255,255,0.92);
                        backdrop-filter: blur(8px);
                        border: 1px solid rgba(255,255,255,0.75);
                        border-radius: 28px;
                        padding: 24px;
                        box-shadow: 0 14px 35px rgba(15, 23, 42, 0.08);
                        transition: transform 0.18s ease, box-shadow 0.18s ease;
                    }

                    .recipe-card:hover {
                        transform: translateY(-4px);
                        box-shadow: 0 18px 42px rgba(15, 23, 42, 0.12);
                    }

                    .recipe-top {
                        display: flex;
                        justify-content: space-between;
                        align-items: flex-start;
                        gap: 14px;
                        margin-bottom: 18px;
                    }

                    .recipe-top h3 {
                        margin: 0 0 10px;
                        font-size: 30px;
                        color: #111827;
                    }

                    .badge {
                        display: inline-block;
                        background: #fee2e2;
                        color: #b91c1c;
                        padding: 8px 13px;
                        border-radius: 999px;
                        font-size: 13px;
                        font-weight: 700;
                    }

                    .favorite-pill {
                        padding: 9px 13px;
                        border-radius: 999px;
                        font-size: 13px;
                        font-weight: 700;
                        white-space: nowrap;
                    }

                    .favorite-on {
                        background: #fef2f2;
                        color: #b91c1c;
                        border: 1px solid #fecaca;
                    }

                    .favorite-off {
                        background: #f9fafb;
                        color: #6b7280;
                        border: 1px solid #e5e7eb;
                    }

                    .recipe-block {
                        margin-bottom: 18px;
                    }

                    .recipe-block h4 {
                        margin: 0 0 8px;
                        color: #dc2626;
                        font-size: 16px;
                    }

                    .recipe-block p {
                        margin: 0;
                        line-height: 1.8;
                        color: #374151;
                        white-space: pre-line;
                    }

                    .recipe-actions {
                        display: flex;
                        gap: 12px;
                        flex-wrap: wrap;
                        margin-top: 6px;
                    }

                    .empty-state {
                        background: rgba(255,255,255,0.9);
                        border: 1px solid rgba(255,255,255,0.7);
                        border-radius: 28px;
                        padding: 36px;
                        text-align: center;
                        color: #6b7280;
                        box-shadow: 0 14px 35px rgba(15, 23, 42, 0.08);
                    }

                    .hidden {
                        display: none !important;
                    }

                    @media (max-width: 768px) {
                        .hero h1 {
                            font-size: 36px;
                        }

                        .hero p {
                            font-size: 18px;
                        }

                        .form-grid,
                        .filters {
                            grid-template-columns: 1fr;
                        }

                        .recipe-top {
                            flex-direction: column;
                        }

                        .panel {
                            padding: 22px;
                        }
                    }
                </style>
            </head>
            <body>
                <div class="container">
                    <div class="hero">
                        <h1>🍳 Carnet de recettes</h1>
                        <p>Ajoute, organise et retrouve facilement tes recettes préférées.</p>
                    </div>

                    <div class="stats">
                        <div class="stat-card">
                            <h3>Total recettes</h3>
                            <p>\(recipesCount)</p>
                        </div>
                        <div class="stat-card">
                            <h3>Favoris</h3>
                            <p>\(favoritesCount)</p>
                        </div>
                        <div class="stat-card">
                            <h3>Catégories</h3>
                            <p>\(categories.count)</p>
                        </div>
                    </div>

                    <div class="panel">
                        <h2>Ajouter une recette</h2>
                        <form id="recipeForm">
                            <div class="form-grid">
                                <div>
                                    <input type="text" id="name" placeholder="Nom de la recette" required>
                                </div>
                                <div>
                                    <input type="text" id="category" placeholder="Catégorie" required>
                                </div>
                                <div class="full">
                                    <textarea id="ingredients" placeholder="Ingrédients" required></textarea>
                                </div>
                                <div class="full">
                                    <textarea id="steps" placeholder="Étapes de préparation" required></textarea>
                                </div>
                            </div>
                            <div class="submit-row">
                                <button type="submit" class="btn btn-primary">Ajouter la recette</button>
                            </div>
                        </form>
                    </div>

                    <div class="panel">
                        <h2>Explorer les recettes</h2>
                        <div class="filters">
                            <input type="text" id="searchInput" placeholder="Rechercher une recette...">
                            <select id="categoryFilter">
                                <option value="">Toutes les catégories</option>
                                \(categoryOptions)
                            </select>
                            <select id="favoriteFilter">
                                <option value="">Toutes</option>
                                <option value="true">Favoris seulement</option>
                                <option value="false">Non favoris</option>
                            </select>
                        </div>
                    </div>

                    <div id="recipesContainer" class="recipes-grid">
                        \(list.isEmpty ? "<div class=\"empty-state\">Aucune recette pour le moment. Ajoute-en une 🍽️</div>" : list)
                    </div>
                </div>

                <script>
                    document.getElementById("recipeForm").addEventListener("submit", async function(event) {
                        event.preventDefault();

                        const data = {
                            name: document.getElementById("name").value,
                            category: document.getElementById("category").value,
                            ingredients: document.getElementById("ingredients").value,
                            steps: document.getElementById("steps").value
                        };

                        await fetch("/create", {
                            method: "POST",
                            headers: {
                                "Content-Type": "application/json"
                            },
                            body: JSON.stringify(data)
                        });

                        window.location.href = "/";
                    });

                    const searchInput = document.getElementById("searchInput");
                    const categoryFilter = document.getElementById("categoryFilter");
                    const favoriteFilter = document.getElementById("favoriteFilter");
                    const cards = document.querySelectorAll(".recipe-card");

                    function filterRecipes() {
                        const search = searchInput.value.toLowerCase().trim();
                        const category = categoryFilter.value;
                        const favorite = favoriteFilter.value;

                        cards.forEach(card => {
                            const name = card.dataset.name;
                            const cardCategory = card.dataset.category;
                            const cardFavorite = card.dataset.favorite;

                            const matchSearch = name.includes(search);
                            const matchCategory = category === "" || cardCategory === category;
                            const matchFavorite = favorite === "" || cardFavorite === favorite;

                            if (matchSearch && matchCategory && matchFavorite) {
                                card.classList.remove("hidden");
                            } else {
                                card.classList.add("hidden");
                            }
                        });
                    }

                    searchInput.addEventListener("input", filterRecipes);
                    categoryFilter.addEventListener("change", filterRecipes);
                    favoriteFilter.addEventListener("change", filterRecipes);
                </script>
            </body>
            </html>
            """
    }
}
