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
        PokemonInfoRow(expanded: false)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct PokemonInfoRow: View {
    @State var expanded:Bool
    let model = PokemonViewModel.sample(id: 1)
    
    var body: some View {
        VStack {
            HStack {
                Image("Pokemon-\(model.id)")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 4)
                Spacer()
                VStack() {
                    Text(model.name)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    Text(model.nameEN)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }.padding(.top, 12)
            Spacer()
            HStack(spacing: expanded ? 20 : -30)  {
                Spacer()
                Button(action:{}){
                    Image(systemName: "star")
                        .modifier(ToolButtonModifer())

                }
                Button(action:{}) {
                    Image(systemName: "chart.bar")
                        .modifier(ToolButtonModifer())

                }
                Button(action: {}) {
                    Image(systemName: "info.circle")
                        .modifier(ToolButtonModifer())
                }
            }
            .padding(.bottom, 12)
            .opacity(expanded ? 1.0 : 0.0)
            .frame(maxHeight: expanded ? .infinity : 0)
        }
        .frame(height: expanded ? 120 : 80)
        .padding(.leading, 23)
        .padding(.trailing, 15)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(model.color, style: StrokeStyle(lineWidth:1))
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(gradient: Gradient(colors: [.white,.green]),
                                         startPoint: .leading,
                                         endPoint: .trailing))
            }
        ).padding(.horizontal).animation(.default).onTapGesture {
            self.expanded.toggle()
        }
    }
}

struct ToolButtonModifer: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 25))
            .foregroundColor(.white)
            .frame(width: 30, height: 30)
    }
}

