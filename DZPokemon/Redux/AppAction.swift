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
    case accountBehaviorDone(res: Result<User,AppError>)
    case logout
}
