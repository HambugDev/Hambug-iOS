//
//  UserDefaultsManager.swift
//  Hambug
//
//  Created by 차상진 on 10/13/25.
//

import Foundation

enum UserDefaultsType: String {
    case userResponse = "userResponse"
}


class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    func saveUserData(_ user: UserResponse) {
        let data = try? JSONEncoder().encode(user)
        if let data = data {
            UserDefaults.standard.set(data, forKey: UserDefaultsType.userResponse.rawValue)
        }
    }
}
