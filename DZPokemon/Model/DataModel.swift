//
//  DataModel.swift
//  DZPokemon
//
//  Created by dushandz on 2020/4/18.
//  Copyright © 2020 dushandz. All rights reserved.
//

import Foundation
import SwiftUI

struct Language: Codable {
    let name: String
    let url: URL
    
    var isCN: Bool { name == "zh-Hans"}
    var isEN: Bool { name == "en" }
}

protocol LanguageTextEntry {
    var language: Language { get }
    var text: String { get }
}

extension Array where Element: LanguageTextEntry {
    var CN: String { first { $0.language.isCN }?.text ?? EN }
    var EN: String { first { $0.language.isEN }?.text ?? "UnKnown" }
}


struct Ability: Codable {
    
    struct Name: Codable, LanguageTextEntry {
        let language: Language
        let name: String
        var text: String { name }
    }
    
    struct FlavorTextEntry: Codable, LanguageTextEntry {
        let language: Language
        let flavorText: String
        
        var text: String { flavorText }
    }
    
    let id: Int
    
    let names: [Name]
    let flavorTextEntries: [FlavorTextEntry]
}


struct Pokemon: Codable {
    
    struct `Type`: Codable {
        struct Internal: Codable {
            let name: String
            let url: URL
        }
        
        let slot: Int
        let type: Internal
    }
    
    struct Stat: Codable {
        
        enum Case: String, Codable {
            case speed
            case specialDefense = "special-defense"
            case specialAttack = "special-attack"
            case defense
            case attack
            case hp
        }
        
        struct Internal: Codable {
            let name: Case
        }
        
        let baseStat: Int
        let stat: Internal
    }
    
    struct SpeciesEntry: Codable {
        let name: String
        let url: URL
    }

    struct AbilityEntry: Codable, Identifiable {
        struct Internal: Codable {
            let name: String
            let url: URL
        }

        var id: URL { ability.url }
        
        let slot: Int
        let ability: Internal
    }

    let id: Int
    let types: [Type]
    let abilities: [AbilityEntry]
    let stats: [Stat]
    let species: SpeciesEntry
    let height: Int
    let weight: Int
}

extension Pokemon: Identifiable { }

extension Pokemon: CustomDebugStringConvertible {
    var debugDescription: String {
        "Pokemon - \(id) - \(self.species.name)"
    }
}

struct PokemonSpecies: Codable {

    struct Color: Codable {
        enum Name: String, Codable {
            case black, blue, brown, gray, green, pink, purple, red, white, yellow

            var color: SwiftUI.Color {
                return SwiftUI.Color("pokemon-\(rawValue)")
            }
        }

        let name: Name
    }

    struct Name: Codable, LanguageTextEntry {
        let language: Language
        let name: String

        var text: String { name }
    }

    struct FlavorTextEntry: Codable, LanguageTextEntry {
        let language: Language
        let flavorText: String

        var text: String { flavorText }
    }

    struct Genus: Codable, LanguageTextEntry {
        let language: Language
        let genus: String

        var text: String { genus }
    }

    let color: Color
    let names: [Name]
    let genera: [Genus]
    let flavorTextEntries: [FlavorTextEntry]
}


