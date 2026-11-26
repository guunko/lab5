import Foundation

struct CatBreed: Codable, Identifiable {
    let id: String
    let name: String
    let temperament: String?
    let origin: String?
    let description: String?
    let lifeSpan: String?
    let weight: Weight?
    let wikipediaUrl: String?
    let referenceImageId: String?
    let image: BreedImage?
    let affectionLevel: Int?
    let intelligence: Int?
    let energyLevel: Int?

    struct Weight: Codable {
        let metric: String?
    }

    struct BreedImage: Codable {
        let url: String?
    }

    var imageURL: URL? {
        if let urlString = image?.url, let url = URL(string: urlString) {
            return url
        }
        if let refId = referenceImageId {
            return URL(string: "https://cdn2.thecatapi.com/images/\(refId).jpg")
        }
        return nil
    }

    static let example = CatBreed(
        id: "abys",
        name: "Abyssinian",
        temperament: "Active, Energetic, Independent",
        origin: "Egypt",
        description: "The Abyssinian is easy to care for, and a joy to have in your home.",
        lifeSpan: "14 - 15",
        weight: Weight(metric: "3 - 5"),
        wikipediaUrl: "https://en.wikipedia.org/wiki/Abyssinian_(cat)",
        referenceImageId: "0XYvRd7oD",
        image: nil,
        affectionLevel: 5,
        intelligence: 5,
        energyLevel: 5
    )
}
