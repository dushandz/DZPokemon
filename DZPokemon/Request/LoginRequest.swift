//
//  LoginRequest.swift
//  DZPokemon
//
//  Created by dushandz on 2020/5/3.
//  Copyright © 2020 dushandz. All rights reserved.
//

import Foundation
import Combine

struct LoginRequest {
    let email: String
    let password: String
    
    var publisher: AnyPublisher<User, AppError> {
        Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5 ) {
                if self.password ==  "pwd" {
                    let user = User(email: self.email, favoritePokemonIDSet: [])
                    promise(.success(user))
                } else {
                    promise(.failure(AppError.pwdErr))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
