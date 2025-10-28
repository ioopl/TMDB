import Foundation
@testable import TMDB

final class MockAPIManager: APIManaging {

    enum MockResult {
        case success(Any)
        case failure(APIError)
    }

    private let mockResult: MockResult

    init(result: MockResult) {
        self.mockResult = result
    }

    func execute<Value>(_ request: Request<Value>,
                        completion: @escaping (Result<Value, APIError>) -> Void) where Value: Decodable {
        switch mockResult {
        case .success(let payload):
            if let value = payload as? Value {
                completion(.success(value))
            } else {
                completion(.failure(.parsingError))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
