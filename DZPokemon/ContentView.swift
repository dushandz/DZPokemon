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
        TabView {
            PokemonRootView().tabItem {
                Image(systemName: "list.bullet.below.rectangle")
                Text("列表")
            }
            
            SettingRootView().tabItem {
                Image(systemName: "gear")
                Text("设置")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
