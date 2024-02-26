import Foundation
import XCTest
@testable import NetworkKit

final class NetworkServiceTests: XCTestCase {
    
    var session: URLSession!
    var sut: NetworkService<MockAPI>!
    let mockData = """
    {
        "page": 1,
        "results": [
            {
                "backdrop_path": "/oBIQDKcqNxKckjugtmzpIIOgoc4.jpg",
                "id": 969492,
                "original_language": "en",
                "original_title": "Land of Bad",
                "overview": "When a Delta Force special ops mission goes terribly wrong, Air Force drone pilot Reaper has 48 hours to remedy what has devolved into a wild rescue operation. With no weapons and no communication other than the drone above, the ground mission suddenly becomes a full-scale battle when the team is discovered by the enemy.",
                "poster_path": "/h27WHO2czaY5twDmV3Wfx5IdqoE.jpg",
                "release_date": "2024-01-25",
                "title": "Land of Bad",
                "vote_average": 7.2
            }
        ],
        "total_pages": 42671,
        "total_results": 853403
    }
    """.data(using: .utf8)!
    
    override func setUp() {
        super.setUp()
        
        session = {
            let configuration = URLSessionConfiguration.ephemeral
            configuration.protocolClasses = [MockURLProtocol.self]
            return URLSession(configuration: configuration)
        }()
        sut = NetworkService<MockAPI>(session: session)
    }
    
    override func tearDown() {
        sut = nil
        session = nil
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }
    
    func testGetPopularMoviesSuccess() async throws {
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, self.mockData)
        }

        let result = try await sut.request(ofType: StubResponse.self, .getPopularMovies(page: 1))
        XCTAssertEqual(try result.get().results.count, 1)
    }
    
    func testGetPopularMoviesFailureWithStatusCode() async throws {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 404, // Not Found, por exemplo
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, self.mockData)
        }

        do {
            let result = try await sut.request(ofType: StubResponse.self, .getPopularMovies(page: 1))
            
            switch result {
                case .success(_):
                    XCTFail("Expected to failed a parsing error")
                case .failure(let error):
                    XCTAssertEqual(error as! NetworkResponseError, NetworkResponseError.authenticationError)
            }
            
        } catch {
            XCTAssertEqual(error as! NetworkError, NetworkError.serializationError)
        }
    }
    
    func testGetPopularMoviesWithInvalidData() async throws {
        let invalidData = "Invalid data".data(using: .utf8)!

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, invalidData)
        }

        do {
            let result = try await sut.request(ofType: StubResponse.self, .getPopularMovies(page: 1))
            
            switch result {
                case .success(_):
                    XCTFail("Expected to failed a parsing error")
                case .failure(let error):
                    XCTAssertEqual(error as! NetworkResponseError, NetworkResponseError.unableToDecode)
            }
            
        } catch {
            XCTAssertEqual(error as! NetworkResponseError, NetworkResponseError.unableToDecode)
        }
    }

}
