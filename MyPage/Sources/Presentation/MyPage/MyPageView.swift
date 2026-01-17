//
//  MyPageView.swift
//  Hambug
//
//  Created by 강동영 on 10/27/25.
//

import SwiftUI
import PhotosUI
import DesignSystem
import Util
import CommunityDI
import CommunityPresentation

public protocol ActivitesFactory {
  func makeMyActivitiesViewModel() -> MyActivitiesViewModel
}

public struct MyPageView: View {
  @Bindable var viewModel: MyPageViewModel
  @State private var showMyActivitiesView: Bool = false

  // MARK: popup state
  @State private var popupState: MyPageView.PopupState = .none
  @State private var showInfoActionSheet: Bool = false
  
  // MARK: Photo picker state
  @State private var selectedPhotoItem: PhotosPickerItem?
  @State private var selectedImageData: Data?
  @State private var showPhotoPicker: Bool = false
  
  private let activitesFactory: ActivitesFactory
  private let dependency: CommunityDependency
  
  public init(
    viewModel: MyPageViewModel,
    activitesFactory: ActivitesFactory,
    dependency: CommunityDependency
  ) {
    self._viewModel = Bindable(viewModel)
    self.activitesFactory = activitesFactory
    self.dependency = dependency
  }
  
  public var body: some View {
    NavigationStack {
      ZStack {
        Color.white
          .ignoresSafeArea(.container, edges: .vertical)
        
        VStack(spacing: 0) {
          headerSection
          imageSection
          nicknameSection
          navigationSection
          
          Spacer()
        }
        .navigationDestination(isPresented: $showMyActivitiesView, destination: {
          MyActivitiesView(
            viewModel: activitesFactory.makeMyActivitiesViewModel(),
            dependency: dependency
          )
        })
      }
      .confirmationDialog("프로필 편집", isPresented: $showInfoActionSheet, actions: {
        Button(Strings.ActionSheetTitle.changeImage) {
          showPhotoPicker = true
        }
        Button(Strings.ActionSheetTitle.defaultImage) {
          Task {
            await viewModel.applyDefaultImage()
            popupState = .none
          }
        }
        Button(Strings.ActionSheetTitle.changeNickname) {
          popupState = .changeNickname
        }
        Button("취소", role: .cancel) {
          popupState = .none
        }
      })
      .photosPicker(
        isPresented: $showPhotoPicker,
        selection: $selectedPhotoItem,
        matching: .images
      )
      .onChange(of: selectedPhotoItem) { _, newItem in
        Task {
          guard let newItem = newItem,
                let imageData = try? await newItem.loadTransferable(type: Data.self),
                let image = UIImage(data: imageData) else {
            return
          }

          let originalSize = imageData.count
          print("\(originalSize / (1024 * 1024))MB")
          // 크기 검증 (10MB)
          if originalSize > ImageProcessor.maxFileSize {
            // 크기 초과 시 이미지 처리 시도
            if let processedData = ImageProcessor.process(image) {
              // 처리 성공 - 압축된 이미지로 업로드
              selectedImageData = processedData
              await viewModel.changeProfileImage(processedData)
              popupState = .none
              
            } else {
              // 처리 실패 - 알림 표시
              viewModel.showImageSizeAlert = true
            }
          } else {
            // 크기가 괜찮으면 원본 데이터로 업로드
            selectedImageData = imageData
            await viewModel.changeProfileImage(imageData)
            popupState = .none
          }
        }
      }
      .overlay(content: {
        if popupState != .none && popupState != .infoAction {
          currentPopup()
        }
      })
      .overlay(content: {
        if viewModel.isLoading {
          Color.black.opacity(0.3)
            .ignoresSafeArea()
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .scaleEffect(1.5)
        }
      })
      .alert("오류", isPresented: $viewModel.showError) {
        Button("확인", role: .cancel) {
          viewModel.showError = false
        }
      } message: {
        if let errorMessage = viewModel.errorMessage {
          Text(errorMessage)
        }
      }
      .alert("이미지 크기 초과", isPresented: $viewModel.showImageSizeAlert) {
        Button("확인", role: .cancel) {
          viewModel.showImageSizeAlert = false
        }
      } message: {
        Text("이미지 크기가 너무 큽니다. 10MB 이하의 이미지를 선택해주세요.")
      }
    }
    .toolbar(.hidden, for: .navigationBar)
    .onAppear {
      Task {
        await viewModel.fetchProfile()
      }
    }
    .onChange(of: viewModel.shouldNavigateToLogin) { _, shouldNavigate in
      if shouldNavigate {
        NotificationCenter.default.post(name: .userDidLogout, object: nil)
      }
    }
  }
  
  // MARK: - Sections
  private var headerSection: some View {
    HeaderBar(type: .myPage)
      .safeAreaPadding(18)
  }
  
  private var imageSection: some View {
    ProfileImageView(
      with: viewModel.user?.profileImageURL ?? "",
      width: 110,
      height: 110
    )
    .applyCilpShape()
    .overlay(content: {
      Circle()
        .stroke(Color.primaryHambugRed, lineWidth: 2)
        .scaleEffect(1.08)
    })
    .overlay(content: {
      // 우측 하단 펜슬 버튼
      Color.bgPencil
        .frame(width: 30, height: 30)
        .clipShape(Circle())
        .overlay {
          Image(.communityPencil)
            .resizable()
            .foregroundColor(.white)
            .frame(width: 16, height: 16)
        }
        .offset(x: 40, y: 50)

    })
    .onTapGesture {
      showInfoActionSheet = true
    }
    .padding(.top, 20)
  }
  
  private var nicknameSection: some View {
    Text(viewModel.profileNickName.isEmpty ? "nickName" : viewModel.profileNickName)
      .pretendard(.body(.base))
      .foregroundStyle(Color.textG800)
      .padding(.top, 22)
  }
  
  private var navigationSection: some View {
    VStack(spacing: 0) {
      MyPageCardView(config: .activity) {
        showMyActivitiesView = true
      }
      
      Spacer()
        .frame(height: 24)
      
      MyPageCardView(config: .logout) {
        print("로그아웃")
        popupState = .logout
      }

      MyPageCardView(config: .accountDelete) {
        print("탈퇴하기")
        popupState = .accountDelete
      }
      .foregroundColor(.textR100)
    }
    .padding(.top, 40)
    .padding(.leading, 32)
    .padding(.trailing, 38)
  }
  
  // MARK: - Popup
  
  @ViewBuilder
  private func currentPopup() -> some View {
    switch popupState {
    case .none, .infoAction:
      EmptyView()
    case .changeNickname:
      changeNicknamePopup
    case .logout:
      logoutPopup
    case .accountDelete:
      accountDeletePopup
    case .accountDeleteSuccess:
      accountDeleteSuccessPopup
    }
  }
  
  private var changeNicknamePopup: some View {
    HambugCommonAlertView(
      isPresented: Binding(
        get: { popupState == .changeNickname },
        set: { if !$0 { popupState = .none }}
      ),
      content: {
        VStack {
          Text(Strings.PopupTitle.changeNickname)
            .pretendard(.title(.t2))
            .foregroundStyle(Color.textG900)
            .padding(.top, 16)
          
          MyPageBottomLineTextField(
            title: $viewModel.currentNickName,
            isCorrected: $viewModel.isCorrectedNickName
          )
          .padding(.horizontal, 45)
        }
        
      },
      secondaryButton: AlertButton(.cancel) {
        print("취소")
        
      },
      primaryButton: AlertButton(.save) {
        print("저장")
        Task { await viewModel.updateNickname() }
      }
    )
  }
  
  private var logoutPopup: some View {
    HambugCommonAlertView(
      isPresented: Binding(
        get: { popupState == .logout },
        set: { if !$0 { popupState = .none }}
      ),
      content: {
        VStack {
          Text(Strings.PopupTitle.logout)
            .pretendard(.title(.t2))
            .foregroundStyle(Color.textG900)
            .padding(.top, 16)
        }
        .padding(.horizontal, 10)
        
      },
      secondaryButton: AlertButton(.cancel) {
        print("취소")
        
      },
      primaryButton: AlertButton(.ok) {
        print("확인")
        Task { await viewModel.logout() }
      }
    )
  }
  
  private var accountDeletePopup: some View {
    HambugCommonAlertView(
      isPresented: Binding(
        get: { popupState == .accountDelete },
        set: { if !$0 { popupState = .none }}
      ),
      content: {
        VStack {
          Text(Strings.PopupTitle.deleteAccount)
            .pretendard(.title(.t2))
            .foregroundStyle(Color.textG900)
            .padding(.top, 16)
          
          Text(Strings.PopupMessage.deleteAccount)
            .pretendard(.body(.small))
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.textG600)
            .padding(.top, 16)
          
        }
        .padding(.horizontal, 10)
        
      },
      secondaryButton: .init(.cancel) {
        print("취소")
        
      },
      primaryButton: .init(.accountDelete) {
        print("탈퇴")
        Task { await viewModel.deleteAccount() }
      }
    )
  }
  
  private var accountDeleteSuccessPopup: some View {
    HambugCommonAlertView(
      isPresented: Binding(
        get: { popupState == .accountDeleteSuccess },
        set: { if !$0 { popupState = .none }}
      ),
      content: {
        VStack {
          Text(Strings.PopupTitle.deleteSuccess)
            .pretendard(.title(.t2))
            .foregroundStyle(Color.textG900)
            .padding(.top, 16)
        }
        .padding(.horizontal, 10)
        
      },
      secondaryButton: nil,
      primaryButton: AlertButton(.ok) {
        print("확인")
      }
    )
  }
}

extension MyPageView {
  enum PopupState {
    case none
    case infoAction
    case changeNickname
    case logout
    case accountDelete
    case accountDeleteSuccess
  }
}

#Preview {
//  MyPageView(viewModel: .: MyPageDIContainer())
}

struct MyPageBottomLineTextField: View {
  @Binding var title: String
  @Binding var isCorrected: Bool
  
  var body: some View {
    VStack(spacing: 4) {
      TextField("", text: $title)
        .pretendard(.body(.base))
        .multilineTextAlignment(.center)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .overlay(
          Rectangle()
            .frame(height: 1)
            .foregroundColor(isCorrected ? Color.borderG500 : Color.borderR100),
          alignment: .bottom
        )
      
      if !isCorrected {
        Text(Strings.PopupMessage.isCorrected)
          .pretendard(.caption(.base))
          .foregroundColor(Color.textR100)
      }
    }
  }
  
  init(
    title: Binding<String>,
    isCorrected: Binding<Bool>
  ) {
    self._title = title
    self._isCorrected = isCorrected
  }
}

extension MyPageView {
  enum Strings {
    enum ActionSheetTitle {
      static let profile = "프로필 설정"
      static let changeNickname = "닉네임 변경"
      static let changeImage = "프로필 이미지 변경"
      static let defaultImage = "기본 이미지 적용"
    }
    
    enum PopupTitle {
      static let changeNickname = "닉네임 변경"
      static let logout = "로그아웃 하시겠어요?"
      static let deleteAccount = "정말 탈퇴하시겠어요?"
      static let deleteSuccess = "회원 탈퇴가 완료되었습니다."
    }
    
    enum PopupMessage {
      static let deleteAccount = "회원탈퇴 후 계정 복구가 불가능하며, 작성한 게시글과 댓글은 유지됩니다. 탈퇴하시겠습니까?"
    }
  }
}


extension MyPageBottomLineTextField {
  enum Strings {
    enum PopupMessage {
      static let isCorrected = "닉네임을 다시 확인해주세요"
    }
  }
}
