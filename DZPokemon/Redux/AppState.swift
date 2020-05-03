//
//  AppState.swift
//  DZPokemon
//
//  Created by dushandz on 2020/5/3.
//  Copyright © 2020 dushandz. All rights reserved.
//

import Foundation

struct AppState {
    var setting = Settings()
    
}

extension AppState {
    struct Settings {
        
        enum Sorting: CaseIterable {
            case id, name, color, favorite
        }
        
        var showEnglishName = true
        var sorting = Sorting.id
        var showFavoriteOnly = false
        
        enum AccountBehavior: CaseIterable {
            case register, login
        }
        
        var accountBehavior = AccountBehavior.login
        var email = ""
        var password = ""
        var verifyPassword = ""
        var isRequestLogin = false
        
        var user: User?
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
