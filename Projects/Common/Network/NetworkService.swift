//
//  NetworkServiceV2.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import Combine
import Alamofire

final class NetworkService: NetworkServiceInterface {
    // MARK: - Properties
    private let session: Session
    private let decoder: JSONDecoder
    
    // MARK: - Initialization
    init(session: Session = AF) {
        self.session = session
        self.decoder = JSONDecoder()
        
        // Date formatting 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    func request<T: APIRequest>(_ request: T) -> AnyPublisher<T.Response, NetworkError> {
        let endpoint = request.endpoint
        let url = endpoint.baseURL + endpoint.path
        
        return session.request(
            url,
            method: alamofireMethod(from: endpoint.method),
            headers: alamofireHeaders(from: endpoint.headers)
        )
        .validate()
        .publishData()
        .tryMap { [weak self] response in
            guard let self = self else { throw NetworkError.networkError(NSError()) }
            
            if let error = response.error {
                throw self.mapAlamofireError(error)
            }
            
            guard let data = response.data else {
                throw NetworkError.noData
            }
            
            return data
        }
        .decode(type: APIResponse<T.Response>.self, decoder: decoder)
        .tryMap { response in
            guard response.success, let data = response.data else {
                throw NetworkError.serverError(response.code ?? 500)
            }
            return data
        }
        .mapError { error in
            self.mapError(error)
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Private Methods
    private func alamofireMethod(from httpMethod: HTTPMethod) -> Alamofire.HTTPMethod {
        switch httpMethod {
        case .GET:
            return .get
        case .POST:
            return .post
        case .PUT:
            return .put
        case .DELETE:
            return .delete
        case .PATCH:
            return .patch
        }
    }
    
    private func alamofireHeaders(from headers: [String: String]?) -> Alamofire.HTTPHeaders? {
        guard let headers = headers else { return nil }
        return Alamofire.HTTPHeaders(headers)
    }
    
    private func mapAlamofireError(_ error: AFError) -> NetworkError {
        switch error {
        case .responseValidationFailed(let reason):
            switch reason {
            case .unacceptableStatusCode(let code):
                switch code {
                case 401:
                    return .unauthorized
                case 403:
                    return .forbidden
                case 404:
                    return .notFound
                default:
                    return .serverError(code)
                }
            default:
                return .networkError(error)
            }
        case .responseSerializationFailed:
            return .decodingError(error)
        default:
            return .networkError(error)
        }
    }
    
    private func mapError(_ error: Error) -> NetworkError {
        if let networkError = error as? NetworkError {
            return networkError
        } else if error is DecodingError {
            return NetworkError.decodingError(error)
        } else if let afError = error as? AFError {
            return mapAlamofireError(afError)
        } else {
            return NetworkError.networkError(error)
        }
    }
}
