//
//  Helper.swift
//  DZPokemon
//
//  Created by dushandz on 2020/4/18.
//  Copyright © 2020 dushandz. All rights reserved.
//

import SwiftUI

let appDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}()

let appEncoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    return encoder
}()


extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
}

extension URL {
    var extractedID: Int? {
        Int(lastPathComponent)
    }
}

extension String {
    var newlineRemoved: String {
        return split(separator: "\n").joined(separator: " ")
    }

    var isValidEmailAddress: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}

extension Pokemon {
    static func sample(id: Int) -> Pokemon {
        return FileHelper.loadBundleJson(file: "pokemon-\(id)")
    }
}


extension PokemonSpecies {
    static func sample(url: URL) -> PokemonSpecies {
        return FileHelper.loadBundleJson(file: "pokemon-species-\(url.extractedID!)")
    }
}


extension Ability {
    static func sample(url: URL) -> Ability {
        sample(id: url.extractedID!)
    }

    static func sample(id: Int) -> Ability {
        return FileHelper.loadBundleJson(file: "ability-\(id)")
    }
}

extension PokemonViewModel {
    static var all: [PokemonViewModel] = {
        (1...30).map { id in
            let pokemon = Pokemon.sample(id: id)
            let species = PokemonSpecies.sample(url: pokemon.species.url)
            return PokemonViewModel(pokemon: pokemon, species: species)
        }
    }()

    static let samples: [PokemonViewModel] = [
        sample(id: 1),
        sample(id: 2),
        sample(id: 3),
    ]

    static func sample(id: Int) -> PokemonViewModel {
        let pokemon = Pokemon.sample(id: id)
        let species = PokemonSpecies.sample(url: pokemon.species.url)
        return PokemonViewModel(pokemon: pokemon, species: species)
    }
}

extension AbilityViewModel {
    static func sample(pokemonID: Int) -> [AbilityViewModel] {
        Pokemon.sample(id: pokemonID).abilities.map {
            AbilityViewModel(ability: Ability.sample(url: $0.ability.url))
        }
    }
}


//MARK: - UI Helper

typealias Constraint = (_ child: UIView, _ parent: UIView) -> NSLayoutConstraint

func equal<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>, _ to: KeyPath<UIView, Anchor>, constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { view, parent in
        view[keyPath: keyPath].constraint(equalTo: parent[keyPath: to], constant: constant)
    }
}

func equal<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>, constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return equal(keyPath, keyPath, constant: constant)
}

extension UIView {
    func addSubview(_ child: UIView, constraints: [Constraint]) {
        addSubview(child)
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints.map { $0(child, self) })
    }
}
