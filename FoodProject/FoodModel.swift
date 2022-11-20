
import Foundation


// MARK: - Welcome
struct FoodModel: Codable {
    let results: [Result]
    let offset, number, totalResults: Int
}

// MARK: - Result
struct Result: Codable {
    let id: Int
    let title: String
    let image: String
    let imageType: ImageType
}

enum ImageType: String, Codable {
    case jpg = "jpg"
}
