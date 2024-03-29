import Foundation
import NetworkKit

enum MockAPI {
    case getPopularMovies(page: Int)
}

extension MockAPI: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.themoviedb.org/") else {
            fatalError("Missing out api base url in MoviesDBApi")
        }
        return url
    }
    
    var preferredLanguage: String {
        guard let preferredLanguage = Locale.preferredLanguages.first else {
            fatalError("Missing out preferred language in MoviesDBApi")
        }
        return preferredLanguage
    }
    
    var version: String {
        switch self {
            case .getPopularMovies:
                return "3"
        }
    }
    
    var path: String {
        switch self {
            case .getPopularMovies:
                return "/movie/popular"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
            case .getPopularMovies:
                return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
            case .getPopularMovies(let page):
                return .requestParametersAndHeaders(bodyParameters: nil,
                                                    bodyEncoding: .urlEncoding,
                                                    urlParameters: ["language": "en-US", "page": "\(page)"],
                                                    additionHeaders: headers)
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
            default:
                return [
                    "Authorization": "Bearer "
                ]
        }
    }
}
