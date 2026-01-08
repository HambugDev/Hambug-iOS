//
//  NetworkServiceV2.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import Combine
import NetworkInterface

import Alamofire

public final class NetworkServiceImpl: NetworkServiceInterface {
  
  // MARK: - Properties
  private let session: Session
  private let decoder: JSONDecoder
  private let logger: NetworkLogger?
  
  public init(session: Session = AF, interceptor: RequestInterceptor? = nil, logger: NetworkLogger? = nil) {
    if let interceptor {
      self.session = Session(interceptor: Interceptor(interceptors: [interceptor]))
    } else {
      self.session = session
    }
    self.logger = logger
    self.decoder = JSONDecoder()
    
    // Date formatting 설정
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
  }
  
  public init(configuration: URLSessionConfiguration, logger: NetworkLogger? = nil) {
    self.session = Session(configuration: configuration)
    self.logger = logger
    self.decoder = JSONDecoder()
    
    // Date formatting 설정
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
  }
  
  public func request<T: Decodable>(_ endpoint: any Endpoint, responseType: T.Type) -> AnyPublisher<T, NetworkError> {
    do {
      let urlRequest = try endpoint.createURLRequest()
      
#if DEBUG
      logger?.requestLogger(request: urlRequest)
#endif
      
      return session.request(urlRequest)
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
          
#if DEBUG
          if let httpResponse = response.response {
            self.logger?.responseLogger(response: httpResponse, data: data)
          }
#endif
          
          return data
        }
        .decode(type: T.self, decoder: decoder)
        .mapError { error in
          self.mapError(error)
        }
        .eraseToAnyPublisher()
    } catch {
      return Fail(error: mapError(error))
        .eraseToAnyPublisher()
    }
  }
  
  // MARK: - Private Methods
  private func alamofireMethod(from httpMethod: NetworkInterface.HTTPMethod) -> Alamofire.HTTPMethod {
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
