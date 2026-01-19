//
//  MyPageRepositoryImpl.swift
//  Hambug
//
//  Created by 강동영 on 10/30/25.
//

import Foundation
import UIKit
import MyPageDomain
import NetworkInterface
import SharedDomain
import CommunityDomain

// MARK: - MyPage Repository Implementation
public final class MyPageRepositoryImpl: MyPageRepository {
  
  private let networkService: NetworkServiceInterface
  
  public init(networkService: NetworkServiceInterface) {
    self.networkService = networkService
  }
  
  public func fetchProfile() async throws -> SharedDomain.User {
    let endpoint = MyPageEndpoint.authMe
    do {
      let response = try await networkService.request(
        endpoint,
        responseType: SuccessResponse<UserProfileDTO>.self
      )
        .async()
      
      self.currentUserId = response.data.userId
      return response.data.toDomain()
    } catch {
      print(error.localizedDescription)
      throw error
    }
  }
  
  public func updateNickname(_ nickName: String) async {
    guard let userId = currentUserId else {
      return
    }
    
    let endpoint = MyPageEndpoint.updateNickname(userID: userId, nickname: nickName)
    do {
      _ = try await networkService.request(
        endpoint,
        responseType: SuccessResponse<UserProfileDTO>.self
      )
      .async()
    } catch {
      
    }
    
  }
  
  public func changeProfileImage(_ image: UIImage?) async throws -> ProfileURL {
    guard let userId = currentUserId else {
      let error = NSError(domain: "incorrect user id", code: -1)
      throw error
    }
    
    let endpoint = MyPageEndpoint.updateProfile(userId: userId)
    
    if let image = image {
      guard let imageData = image.jpegData(compressionQuality: 0.9) else {
        throw NSError(domain: "", code: -0000)
      }
      let fileName = "image_\(UUID().uuidString).jpg"
      let imagePart = MultiPartFormType(
        data: imageData,
        fiedlName: "file",
        fileName: fileName,
        mimeType: "image/jpeg"
      )
      
      return try await networkService.uploadMultipartWithJsonRequest(
        endpoint,
        multiparts: [imagePart],
        responseType: SuccessResponse<UserProfileDTO>.self
      )
      .map { $0.data.profileImageUrl }
      .async()
    } else {
      return try await networkService.request(
        endpoint, responseType: SuccessResponse<UserProfileDTO>.self
      )
      .map { $0.data.profileImageUrl }
      .async()
    }
  }
  
  public func applyDefaultImage() async throws {
    do {
      _ = try await changeProfileImage(nil)
    } catch {
      throw error
    }
    
  }
  
  public func logout() async {
    let endpoint = MyPageEndpoint.logout
    do {
      _ = try await networkService.request(
        endpoint,
        responseType: SuccessResponse<Bool>.self
      )
      .async()
    } catch {
      
    }
    
  }
  
  public func deleteAccount(provider: String) async {
    let endpoint = MyPageEndpoint.deleteAccount(provider: provider)
    do {
      _ = try await networkService.request(
        endpoint,
        responseType: SuccessResponse<Bool>.self
      )
      .async()
    } catch {

    }

  }

  // MARK: - Activities
  public func fetchMyBoards(lastId: Int?, limit: Int, order: String) async throws -> BoardListData {
    let query = CursorPagingQuery(lastId: lastId, limit: limit, order: order)
    let endpoint = MyPageEndpoint.getMyBoards(query: query)

    let response = try await networkService.request(
      endpoint,
      responseType: SuccessResponse<MyBoardsResponseDTO>.self
    ).async()

    return response.data.toDomain()
  }

  public func fetchMyComments(lastId: Int?, limit: Int, order: String) async throws -> MyCommentActivityListData {
    let query = CursorPagingQuery(lastId: lastId, limit: limit, order: order)
    let endpoint = MyPageEndpoint.getMyComments(query: query)

    let response = try await networkService.request(
      endpoint,
      responseType: SuccessResponse<MyCommentsResponseDTO>.self
    ).async()

    return response.data.toDomain()
  }

  private var currentUserId: Int?
}
