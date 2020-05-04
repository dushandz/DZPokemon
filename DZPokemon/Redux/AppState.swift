//
//  AppState.swift
//  DZPokemon
//
//  Created by dushandz on 2020/5/3.
//  Copyright © 2020 dushandz. All rights reserved.
//

import Foundation
import Combine


struct AppState {
    var setting = Settings()
    
}

extension AppState {
    struct Settings {
        
        enum Sorting: String, Codable, CaseIterable {
            case id, name, color, favorite
        }
        @UserDefaultsStorage(initialValue: false, keyName: "showEnglishName")
        var showEnglishName
        
        @UserDefaultsStorage(initialValue: Sorting.id, keyName: "sorting")
        var sorting
        
        @UserDefaultsStorage(initialValue: false, keyName: "showEnglishName")
        var showFavoriteOnly
        
        enum AccountBehavior: CaseIterable {
            case register, login
        }
        
        var isRequestLogin = false
        var loginErr: AppError?
        
        @FileStorage(directory: .documentDirectory, fileName: "user.json")
        var user: User?
        
        var isEmailValid = false
        
        class AccountChecker {
            @Published var accountBehavior = AccountBehavior.login
            @Published var email = ""
            @Published var password = ""
            @Published var verifyPassword = ""
            
            var isEmailValid: AnyPublisher<Bool, Never> {
                let remoteVerify = $email.debounce(for: .milliseconds(500), scheduler: DispatchQueue.main).removeDuplicates().flatMap { email -> AnyPublisher<Bool, Never> in
                    let isValid = email.isValidEmailAddress
                    let canSkip = self.accountBehavior == .login
                    switch(isValid, canSkip) {
                    case(false, _):
                        return Just(false).eraseToAnyPublisher()
                    case (true, false):
                        return EmailCheckingRequest(email: email).publisher
                    case (true, true):
                        return Just(true).eraseToAnyPublisher()
                    }
                }
                let emailLocalValid = $email.map{$0.isValidEmailAddress}
                let canSkip = $accountBehavior.map{$0 == .login}
                
                return Publishers.CombineLatest3(remoteVerify, emailLocalValid, canSkip).map{$0 && ($1 || $2) }.eraseToAnyPublisher()
            }
        }
        var checker = AccountChecker()
    }
}

extension AppState.Settings.Sorting {
    var text: String {
        switch self {
        case .id: return "ID"
        case .name: return "名字"
        case .favorite: return "最爱"
        case .color: return "颜色"
        }
    }
}


extension AppState.Settings.AccountBehavior {
    var text: String {
        switch self {
        case .register: return "注册"
        case .login: return "登录"
        }
    }
}

struct User: Codable {
    var email: String
    var favoritePokemonIDSet: Set<Int>
    func isFavoritePokemon(id: Int) -> Bool {
        favoritePokemonIDSet.contains(id)
    }
    
}


enum AppError: Error, Identifiable {
    var id: String  { localizedDescription }
    case pwdErr
}

extension AppError {
    var localizedDescription: String {
        switch self {
        case .pwdErr: return "密码错误"
        }
    }
}
