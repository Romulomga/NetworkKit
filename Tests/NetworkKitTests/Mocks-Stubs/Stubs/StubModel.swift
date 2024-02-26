import Foundation

struct StubMovie: Codable, Equatable {
    let id: Int
    let originalLanguage: String
    let overview: String
    let title: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case originalLanguage = "original_language"
        case overview
        case title
        case voteAverage = "vote_average"
    }
}

struct StubResponse: Equatable {
    let page: Int
    let results: [StubMovie]
    let totalPages: Int
    let totalResults: Int?
}

extension StubResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
