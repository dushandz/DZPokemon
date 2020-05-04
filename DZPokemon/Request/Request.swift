//
//  Request.swift
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
                let user: User? = try? FileHelper.loadJSON(from: .documentDirectory, fileName: "user.json")
                if let user = user {
                    if user.passsWord == self.password {
                        promise(.success(user))
                    } else {
                        promise(.failure(AppError.pwdErr))
                    }
                } else {
                    promise(.failure(AppError.userNotFounds))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

struct EmailCheckingRequest {
    let email: String
    
    var publisher: AnyPublisher<Bool, Never> {
        Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                promise(.success(self.email.lowercased().isValidEmailAddress))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}


struct ReigsterRequest {
    let email: String
    let password: String
    
    var publisher: AnyPublisher<User, AppError> {
        Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
                let user = User(email: self.email, passsWord: self.password, favoritePokemonIDSet: Set<Int>())
                promise(.success(user))
            }
        }.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
}

struct LoadPokemonRequest {
    let id: Int
    
    func pokemonPublisher(_ id: Int) -> AnyPublisher<Pokemon,Error> {
        URLSession.shared.dataTaskPublisher(
            for: URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)")!
        )
        .map{$0.data}
        .decode(type: Pokemon.self, decoder: appDecoder)
        .eraseToAnyPublisher()
    }
    
    func speciesPublisher(_ pokemon: Pokemon) -> AnyPublisher<(Pokemon,PokemonSpecies), Error> {
        URLSession.shared.dataTaskPublisher(
            for: pokemon.species.url
        )
        .map{$0.data}
        .decode(type: PokemonSpecies.self, decoder: appDecoder)
        .map{(pokemon, $0)}
        .eraseToAnyPublisher()
    }
    
    var publisher: AnyPublisher<PokemonViewModel, AppError> {
        pokemonPublisher(id)
            .flatMap{ self.speciesPublisher($0) }
            .map{PokemonViewModel(pokemon: $0, species: $1)}
            .mapError{ AppError.netErr($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static var all: AnyPublisher<[PokemonViewModel], AppError> {
        (1...30).map{ LoadPokemonRequest(id:$0).publisher }.zipAll
    }
}


struct LoadPokemonAbilityRequest {
    let pokemon: Pokemon
    
    func abilityPublisher(abilityURL: URL) -> AnyPublisher<AbilityViewModel, Error> {
        URLSession.shared.dataTaskPublisher(for: abilityURL)
            .map{$0.data}
            .decode(type: Ability.self, decoder: appDecoder)
            .map{AbilityViewModel(ability: $0)}
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    var all: AnyPublisher<[AbilityViewModel], Error> {
        pokemon.abilities.map{ abilityPublisher(abilityURL: $0.ability.url) }.zipAll
    }
}

extension Array where Element: Publisher {
    var zipAll: AnyPublisher<[Element.Output], Element.Failure> {
        let inital = Just([Element.Output]()).setFailureType(to: Element.Failure.self).eraseToAnyPublisher()
        return reduce(inital) { res, publisher in
            res.zip(publisher){ $0 + [$1] }.eraseToAnyPublisher()
        }
    }
}
