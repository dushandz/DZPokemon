//
//  AppCommand.swift
//  DZPokemon
//
//  Created by dushandz on 2020/5/3.
//  Copyright © 2020 dushandz. All rights reserved.
//

import Foundation
import Combine

protocol AppCommand {
    func execute(in store: Store)
}

struct LoginAppCommand: AppCommand {
    let email: String
    let password: String
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        LoginRequest(email: email, password: password).publisher.sink(receiveCompletion: { cmp in
            if case .failure(let err)  = cmp {
                store.dispatch(.accountBehaviorDone(res: .failure(err)))
            }
            token.unseal()
        }, receiveValue: { user in
            store.dispatch(.accountBehaviorDone(res: .success(user)))
        }).seal(in: token)
    }
}


struct WriteUserAppCommand: AppCommand {
    let user: User
    func execute(in store: Store) {
        try? FileHelper.writeJSON(user, to: .documentDirectory, fileName: "user.json")
    }
}


class SubscriptionToken {
    var cancellable: AnyCancellable?
    func unseal() { cancellable = nil }
}

extension AnyCancellable {
    func seal(in token: SubscriptionToken) {
        token.cancellable = self
    }
}
