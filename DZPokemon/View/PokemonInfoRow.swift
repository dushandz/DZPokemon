//
//  PokemonRowInfo.swift
//  DZPokemon
//
//  Created by dushandz on 2020/4/18.
//  Copyright © 2020 dushandz. All rights reserved.
//

import SwiftUI

struct PokemonInfoRow: View {
    var model: PokemonViewModel
    var expanded:Bool
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
                    .stroke(model.color, style: StrokeStyle(lineWidth:4))
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(gradient: Gradient(colors: [.white,model.color]),
                                         startPoint: .leading,
                                         endPoint: .trailing))
            }
        ).padding(.horizontal)
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


struct PokemonInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        PokemonInfoRow(model: PokemonViewModel.sample(id: 1), expanded: false)
    }
}

