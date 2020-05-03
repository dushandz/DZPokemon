//
//  PokemonListView.swift
//  DZPokemon
//
//  Created by dushandz on 2020/5/3.
//  Copyright © 2020 dushandz. All rights reserved.
//

import SwiftUI


struct PokemonRootView: View {
    var body: some View {
        NavigationView {
            PokemonListView().navigationBarTitle("PokemonList")
        }
    }
}

struct PokemonListView: View {
    @State var expanedInex: Int?
    @State var text = ""
    var body: some View {
        ScrollView {
            TextField("请输入", text: $text)
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
        }
//        .overlay(
//            VStack{
//                Spacer()
//                PokemonInfoPanel(model: .sample(id: 1))
//            }.edgesIgnoringSafeArea(.bottom)
//        )
    }

}

struct PokemonRootView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonRootView()
    }
}
