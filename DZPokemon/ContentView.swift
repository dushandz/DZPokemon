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
        MainTab()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Store())
    }
}
