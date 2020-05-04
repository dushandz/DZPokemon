//
//  AppAction.swift
//  DZPokemon
//
//  Created by dushandz on 2020/5/3.
//  Copyright © 2020 dushandz. All rights reserved.
//

import Foundation

enum AppAction {
    case login(_ email: String, password: String)
    case accountBehaviorDone(res: Result<User, AppError>)
    case logout
    case emailValid(valid: Bool)
    case isInfoValid(valid: Bool)
    case register(_ email: String, password: String)
    case loadPokemons
    case loadPokemonsDone(res: Result<[PokemonViewModel], AppError>)
    case clearLocalData
    case toggleListSelection(idx: Int?)
    case loadPokemonAbility(pokemon: Pokemon)
    case loadPokemonAbilityDone(res: Result<[AbilityViewModel], AppError>)
}
