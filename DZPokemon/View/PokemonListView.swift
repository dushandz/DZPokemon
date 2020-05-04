//
//  PokemonListView.swift
//  DZPokemon
//
//  Created by dushandz on 2020/5/3.
//  Copyright © 2020 dushandz. All rights reserved.
//

import SwiftUI


struct PokemonRootView: View {
    @EnvironmentObject var store: Store
    var body: some View {
        NavigationView {
            if store.appState.pokemonList.pokemons == nil {
                Text("Loading...").onAppear {
                    self.store.dispatch(.loadPokemons)
                }
            } else {
                PokemonListView().navigationBarTitle("PokemonList")
            }
        }
    }
}

struct PokemonListView: View {
    @EnvironmentObject var store: Store
    
    var expanedIndex: Int? {
        store.appState.pokemonList.selectionState.expandingIndex
    }
    
    var searchText: Binding<String> {
        $store.appState.pokemonList.searchText
    }
    
    var body: some View {
        ScrollView {
            ForEach(store.appState.pokemonList.allPokemonsByID) { pokemon in
                PokemonInfoRow(model: pokemon, expanded: self.expanedIndex == pokemon.id)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.55, dampingFraction: 0.425, blendDuration: 0)) {
                            self.store.dispatch(.toggleListSelection(idx: pokemon.id))
                        }
                        self.store.dispatch(.loadPokemonAbility(pokemon: pokemon.pokemon))

                }
            }
            Spacer()
                .frame(height: 8)
        }
    }

}

struct PokemonRootView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonRootView().environmentObject(Store())
    }
}
