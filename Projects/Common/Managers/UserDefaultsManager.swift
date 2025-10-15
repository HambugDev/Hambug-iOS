//
//  UserDefaultsManager.swift
//  Hambug
//
//  Created by 차상진 on 10/13/25.
//

import Foundation

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    func saveUserData(_ user: UserResponse) {
        let data = try? JSONEncoder().encode(user)
        if let data = data {
            UserDefaults.standard.set(data, forKey: .Storage.userResponse)
        }
    }
    
    func loadUserData() -> UserResponse? {
        guard
            let savedData = UserDefaults.standard.data(forKey: .Storage.userResponse),
            let decoded = try? JSONDecoder().decode(UserResponse.self, from: savedData)
        else { return nil }
        
        return decoded
    }
}
