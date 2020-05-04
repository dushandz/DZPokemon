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
    
    
    @Published var appState = AppState()
    
    static func reduce(_ state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand?
        switch action {
            
        case .login(let email, let pwd):
            guard !appState.setting.isRequestLogin else {
                break
            }
            appState.setting.isRequestLogin = true
            appCommand = LoginAppCommand(email: email, password: pwd)
            
        case .accountBehaviorDone(let res):
            appState.setting.isRequestLogin = false
            switch res {
            case .success(let user):
                appState.setting.user = user
                appCommand = WriteUserAppCommand(user: user)
            case .failure(let error):
                appState.setting.loginErr = error
            }
            
        case .logout:
            appState.setting.user = nil
            
        case .emailValid(let isEmailValid):
            appState.setting.isEmailValid = isEmailValid
            
        case .isInfoValid(let isValid):
            appState.setting.isInfoValid = isValid
            
        case .register(let email, let pwd):
            appCommand = RegstierAppCommand(email: email, password: pwd)
            
        case .loadPokemons:
            guard !appState.pokemonList.isLoading else {
                break
            }
            appCommand = LoadPokemonsAppCommand()
            
        case .loadPokemonsDone(let res):
            switch res {
            case .failure(_): break
            case .success(let list):
                appState.pokemonList.pokemons = Dictionary(uniqueKeysWithValues: list.map{($0.id, $0)})
            }
            
        case .clearLocalData:
            appCommand = ClearLocalDataAppCommand()
            
        case .toggleListSelection(let idx):
            let expanding = appState.pokemonList.selectionState.expandingIndex
            if expanding == idx {
                appState.pokemonList.selectionState.expandingIndex = nil
                appState.pokemonList.selectionState.panelPresented = false
                appState.pokemonList.selectionState.radarProgress = 0
            } else {
                appState.pokemonList.selectionState.expandingIndex = idx
                appState.pokemonList.selectionState.panelIndex = idx
                appState.pokemonList.selectionState.radarShouldAnimate =
                    appState.pokemonList.selectionState.radarProgress == 1 ? false : true
            }
            
        case .loadPokemonAbility(let pokemon):
            appCommand = LoadAbilitiesAppCommand(pokemon: pokemon)
            
        case .loadPokemonAbilityDone(let res):
            switch res {
            case .success(let list):
                var abilities = appState.pokemonList.abilities ?? [:]
                for ability in list {
                    abilities[ability.id] = ability
                }
                appState.pokemonList.abilities = abilities
            case .failure(_):break
                
            }
        case .togglePanelPresenting(let show):
            appState.pokemonList.selectionState.panelPresented = show
            appState.pokemonList.selectionState.radarProgress = show ? 1 : 0
        }
        return (appState, appCommand)
    }
    
    func dispatch(_ action: AppAction) {
        #if DEBUG
        print("[Action]:\(action)")
        #endif
        let res = Store.reduce(appState, action: action)
        appState = res.0
        
        if let command = res.1 {
            print("[Command]:\(command)")
            command.execute(in: self)
        }
        
    }
    
    func setupObservers() {
        appState.setting.checker.isEmailValid.sink { (res) in
            self.dispatch(.emailValid(valid: res))
        }.store(in: &disposeBag)
        appState.setting.checker.isValid.sink { (res) in
            self.dispatch(.isInfoValid(valid: res))
        }.store(in: &disposeBag)
    }
}
