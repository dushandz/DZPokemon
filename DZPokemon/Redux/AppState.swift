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
    var pokemonList = PokemonList()
}

extension AppState {
    struct Settings {
        //MARK: - 列表数据
        
        //MARK: - 偏好设置
        enum Sorting: String, Codable, CaseIterable {
            case id, name, color, favorite
        }
        @UserDefaultsStorage(initialValue: false, keyName: "showEnglishName")
        var showEnglishName
        
        @UserDefaultsStorage(initialValue: Sorting.id, keyName: "sorting")
        var sorting
        
        @UserDefaultsStorage(initialValue: false, keyName: "showEnglishName")
        var showFavoriteOnly
        
        //MARK: - 账号相关
        enum AccountBehavior: CaseIterable {
            case register, login
        }
        var isEmailValid = false
        var isInfoValid = false
        var isRequestLogin = false
        var loginErr: AppError?
        
        @FileStorage(directory: .documentDirectory, fileName: "user.json")
        var user: User?
        
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
            
            var isValid: AnyPublisher<Bool, Never> {
                isEmailValid
                    .combineLatest($accountBehavior, $password, $verifyPassword)
                    .map { validEmail, accountBehavior, password, verifyPassword -> Bool in
                        guard validEmail && !password.isEmpty else {
                            return false
                        }
                        switch accountBehavior {
                        case .login:
                            return true
                        case .register:
                            return password == verifyPassword
                        }
                    }
                    .eraseToAnyPublisher()
            }
        }
        var checker = AccountChecker()
    }
}

extension AppState {
    struct PokemonList {
        @FileStorage(directory: .documentDirectory, fileName: "pokemons.json")
        var pokemons: [Int : PokemonViewModel]?
        
        @FileStorage(directory: .documentDirectory, fileName: "abilities.json")
        var abilities: [Int : AbilityViewModel]?
        
        var expanedInex: Int?
        var isLoading = false
        var searchText = ""
        
        var allPokemonsByID: [PokemonViewModel] {
            guard let pokemons = pokemons?.values else {
                return []
            }
            return pokemons.sorted{ $0.id < $1.id }
        }
        
        func abilityViewModels(for pokemon: Pokemon) -> AbilityViewModel? {
            guard let abilities = abilities else {
                return nil
            }
            return abilities[pokemon.id]
        }
        
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
    var passsWord: String
    var favoritePokemonIDSet: Set<Int>
    func isFavoritePokemon(id: Int) -> Bool {
        favoritePokemonIDSet.contains(id)
    }
    
}


enum AppError: Error, Identifiable {
    var id: String  { localizedDescription }
    case pwdErr, netErr(Error), userNotFounds, registerFailed
}

extension AppError {
    var localizedDescription: String {
        switch self {
        case .pwdErr: return "密码错误"
        case .netErr(let err): return err.localizedDescription
        case .userNotFounds: return "用户不存在"
        case .registerFailed: return "注册失败"
        }
    }
}
