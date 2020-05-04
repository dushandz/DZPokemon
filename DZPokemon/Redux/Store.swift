//
//  Store.swift
//  DZPokemon
//
//  Created by dushandz on 2020/5/3.
//  Copyright © 2020 dushandz. All rights reserved.
//

import Combine

class Store: ObservableObject {
    var disposeBag = [AnyCancellable]()
    
    init() {
        setupObservers()
    }
    
    
    @Published var appSate = AppState()
    
    static func reduce(_ state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appSate = state
        var appCommand: AppCommand?
        switch action {
        case .login(let email, let pwd):
            guard !appSate.setting.isRequestLogin else {
                break
            }
            appSate.setting.isRequestLogin = true
            appCommand = LoginAppCommand(email: email, password: pwd)
        case .accountBehaviorDone(let res):
            appSate.setting.isRequestLogin = false
            switch res {
            case .success(let user):
                appSate.setting.user = user
            case .failure(let error):
                appSate.setting.loginErr = error
            }
        case .logout:
            appSate.setting.user = nil
        case .emailValid(let isEmailValid):
            appSate.setting.isEmailValid = isEmailValid
        }
        return (appSate, appCommand)
    }
    
    func dispatch(_ action: AppAction) {
        #if DEBUG
        print("[Action]:\(action)")
        #endif
        let res = Store.reduce(appSate, action: action)
        appSate = res.0
        
        if let command = res.1 {
            print("[Command]:\(command)")
            command.execute(in: self)
        }
        
    }
    
    func setupObservers() {
        appSate.setting.checker.isEmailValid.sink { (res) in
            self.dispatch(.emailValid(valid: res))
        }.store(in: &disposeBag)
    }
}
