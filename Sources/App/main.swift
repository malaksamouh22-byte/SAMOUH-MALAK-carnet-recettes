import Foundation
import Hummingbird
import NIOCore

let router = Router(context: BasicRequestContext.self)
let database = try Database()

router.get("/") { _, _ async throws -> Response in
    let recipes = try database.getAllRecipes()
    let html = Views.index(recipes: recipes)

    return Response(
        status: .ok,
        headers: [.contentType: "text/html; charset=utf-8"],
        body: .init(byteBuffer: ByteBuffer(string: html))
    )
}

router.post("/create") { request, context async throws -> Response in
    let data = try await request.decode(as: [String: String].self, context: context)

    let recipe = Recipe(
        id: nil,
        name: data["name"] ?? "",
        ingredients: data["ingredients"] ?? "",
        steps: data["steps"] ?? "",
        category: data["category"] ?? "",
        isFavorite: false
    )

    try database.createRecipe(recipe)

    return Response(
        status: .seeOther,
        headers: [.location: "/"]
    )
}

router.post("/delete/:id") { _, context async throws -> Response in
    let recipeId = Int64(context.parameters.get("id") ?? "") ?? 0
    try database.deleteRecipe(recipeId)

    return Response(
        status: .seeOther,
        headers: [.location: "/"]
    )
}

router.post("/favorite/:id") { _, context async throws -> Response in
    let recipeId = Int64(context.parameters.get("id") ?? "") ?? 0
    try database.toggleFavorite(recipeId)

    return Response(
        status: .seeOther,
        headers: [.location: "/"]
    )
}

let app = Application(
    router: router,
    configuration: .init(address: .hostname("0.0.0.0", port: 8080))
)

try await app.runService()