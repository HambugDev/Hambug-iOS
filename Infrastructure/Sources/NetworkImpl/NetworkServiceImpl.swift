//
//  NetworkServiceV2.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import Combine
import NetworkInterface
import UIKit

import Alamofire

public final class NetworkServiceImpl: NetworkServiceInterface {
  
  // MARK: - Properties
  private let session: Session
  private let decoder: JSONDecoder
  private let logger: NetworkLogable?
  
  public init(session: Session = AF, interceptor: RequestInterceptor? = nil, logger: NetworkLogable? = nil) {
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
  
  public init(configuration: URLSessionConfiguration, logger: NetworkLogable? = nil) {
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
            print("❌ Network Error: \(error.localizedDescription)")
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

  public func uploadMultipart<T: Decodable>(
    _ endpoint: any Endpoint,
    images: [UIImage],
    responseType: T.Type
  ) -> AnyPublisher<T, NetworkError> {
    do {
      let urlRequest = try endpoint.createURLRequest()
      
#if DEBUG
      logger?.requestLogger(request: urlRequest)
#endif
      
      guard let url = endpoint.createURL() else {
        throw NetworkError.invalidURL
      }
      
      return session.upload(
        multipartFormData: { multipartFormData in
          // 1. JSON body의 텍스트 필드 추가 (title, content, category)
          if let body = endpoint.body,
             let jsonObject = try? JSONSerialization.jsonObject(with: body) as? [String: Any] {
            for (key, value) in jsonObject {
              if let stringValue = "\(value)".data(using: .utf8) {
                multipartFormData.append(stringValue, withName: key)
              }
            }
          }

          // 2. 이미지 파일 추가
          for (index, image) in images.enumerated() {
            // ImageProcessor는 Util 모듈에 있으므로 여기서는 기본 압축 사용
            if let imageData = image.jpegData(compressionQuality: 0.85) {
              let fileName = "image_\(index)_\(UUID().uuidString).jpg"
              multipartFormData.append(
                imageData,
                withName: "images",
                fileName: fileName,
                mimeType: "image/jpeg"
              )
            }
          }
        },
        to: url,
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
