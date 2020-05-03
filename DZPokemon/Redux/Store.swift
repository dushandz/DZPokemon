//
//  Store.swift
//  DZPokemon
//
//  Created by dushandz on 2020/5/3.
//  Copyright © 2020 dushandz. All rights reserved.
//

import Combine

class Store: ObservableObject {
    
    @Published var appSate = AppState()
    
    static func reduce(_ state: AppState, action: AppAction) -> AppState {
        var appSate = state
        switch action {
        case .login(let email, let pwd):
            if pwd == "pwd" {
                let user = User(email: email, favoritePokemonIDSet: [])
                appSate.setting.user = user
            }
        }
        return appSate
    }
    
    func dispatch(_ action: AppAction) {
        #if DEBUG
        print("[Action]:\(action)")
        #endif
        let res = Store.reduce(appSate, action: action)
        appSate = res
    }
}
