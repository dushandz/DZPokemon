//
//  ContentView.swift
//  DZPokemon
//
//  Created by dushandz on 2020/4/16.
//  Copyright © 2020 dushandz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        PokemonListView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct PokemonListView: View {
    @State var expanedInex: Int?
    var body: some View {
        ScrollView {
            ForEach(PokemonViewModel.all) { pokemon in
                PokemonInfoRow(model: pokemon, expanded: self.expanedInex == pokemon.id)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.55, dampingFraction: 0.425, blendDuration: 0)) {
                            if self.expanedInex == pokemon.id {
                                self.expanedInex = nil
                            } else {
                                self.expanedInex = pokemon.id
                            }
                        }
                }
            }
        }.overlay(
            VStack{
                Spacer()
                PokemonInfoPanel(model: .sample(id: 1))
            }.edgesIgnoringSafeArea(.bottom)
        )
    }

}

