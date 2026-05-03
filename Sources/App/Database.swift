import SQLite

struct Database: @unchecked Sendable {
    let db: Connection

    let recipes = Table("recipes")
    let id = Expression<Int64>("id")
    let name = Expression<String>("name")
    let ingredients = Expression<String>("ingredients")
    let steps = Expression<String>("steps")
    let category = Expression<String>("category")
    let isFavorite = Expression<Bool>("isFavorite")

    init() throws {
        db = try Connection("db.sqlite3")

        try db.run(recipes.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(name)
            t.column(ingredients)
            t.column(steps)
            t.column(category)
            t.column(isFavorite)
        })
    }

    func createRecipe(_ recipe: Recipe) throws {
        let insert = recipes.insert(
            name <- recipe.name,
            ingredients <- recipe.ingredients,
            steps <- recipe.steps,
            category <- recipe.category,
            isFavorite <- recipe.isFavorite
        )
        try db.run(insert)
    }

    func getAllRecipes() throws -> [Recipe] {
        try db.prepare(recipes.order(id.desc)).map {
            Recipe(
                id: $0[id],
                name: $0[name],
                ingredients: $0[ingredients],
                steps: $0[steps],
                category: $0[category],
                isFavorite: $0[isFavorite]
            )
        }
    }

    func deleteRecipe(_ recipeId: Int64) throws {
        let item = recipes.filter(id == recipeId)
        try db.run(item.delete())
    }

    func toggleFavorite(_ recipeId: Int64) throws {
        let item = recipes.filter(id == recipeId)
        if let recipe = try db.pluck(item) {
            try db.run(item.update(isFavorite <- !recipe[isFavorite]))
        }
    }
}