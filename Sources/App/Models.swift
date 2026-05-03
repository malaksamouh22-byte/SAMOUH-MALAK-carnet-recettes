import Foundation

struct Recipe: Codable, Sendable {
    var id: Int64?
    var name: String
    var ingredients: String
    var steps: String
    var category: String
    var isFavorite: Bool
}
