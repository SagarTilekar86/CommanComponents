
import Foundation
import Alamofire

final class NetworkService {
    static let shared = NetworkService()

    private init() {}

    func withRequest<T: Decodable, U: Encodable>(endpoint: EndPoint, parameters: U, headers: HTTPHeaders? = nil, resultData: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let requestURL = endpoint.baseUrl + endpoint.methodName
        let request = AF.request(requestURL, method: endpoint.httpMethod, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: headers)

        request.responseDecodable(of: resultData) { result in
            switch result.result {
            case let .success(result):
                completion(.success(result))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

struct EndPoint {
    let baseUrl = "https://jsonplaceholder.typicode.com/"
    let methodName: String
    let httpMethod: HTTPMethod
}

struct DefaultParameters: Encodable {}
