//
//  SettingModel.swift
//  DZPokemon
//
//  Created by dushandz on 2020/4/19.
//  Copyright © 2020 dushandz. All rights reserved.
//

import Combine


//class Settings1: ObservableObject {
//    
//    enum AccountBehavior: CaseIterable {
//        case register, login
//    }
//    
//    enum Sorting: CaseIterable {
//        case id, name, color, favorite
//    }
//    
//    @Published var accountBehavior = AccountBehavior.login
//    @Published var email = ""
//    @Published var password = ""
//    @Published var verifyPassword = ""
//    
//    @Published var showEnglishName = true
//    @Published var sorting = Sorting.id
//    @Published var showFavoriteOnly = false
//}
//
//extension Settings.Sorting {
//    var text: String {
//        switch self {
//        case .id: return "ID"
//        case .name: return "名字"
//        case .favorite: return "最爱"
//        case .color: return "颜色"
//        }
//    }
//}
//
//extension Settings.AccountBehavior {
//    var text: String {
//        switch self {
//        case .register: return "注册"
//        case .login: return "登录"
//        }
//    }
//}
