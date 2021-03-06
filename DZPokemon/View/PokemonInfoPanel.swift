//
//  PokemonInfoPannel.swift
//  DZPokemon
//
//  Created by dushandz on 2020/4/18.
//  Copyright © 2020 dushandz. All rights reserved.
//

import SwiftUI
import UIKit

struct BlurView : UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)

        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<BlurView>) {
    }
}

extension View {
    func blurBackground(style: UIBlurEffect.Style) -> some View {
        ZStack {
            BlurView(style: style)
            self
        }
    }
}



struct PokemonInfoPanel: View {
    
    @EnvironmentObject var store: Store
    
    @Environment(\.colorScheme) var colorScheme
    
    let model: PokemonViewModel
    var abilities: [AbilityViewModel]? {
         store.appState.pokemonList.abilityViewModels(for: model.pokemon)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            topIndicator
            Header(model: model)
            pokemonDescription
            AbilityList(model: model, abilityModels: abilities)
        }
        .padding(EdgeInsets(top: 12, leading: 30, bottom: 30, trailing: 30))
        .blurBackground(style:.systemMaterial).cornerRadius(20).fixedSize(horizontal: false, vertical: true)
    }
    
    
    var topIndicator: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width: 40, height: 6)
            .opacity(0.2)
    }
    
    var pokemonDescription: some View {
        VStack {
            Text(model.descriptionText)
                .font(.callout)
                .foregroundColor(
                    colorScheme == .light ? Color(hex: 0x666666) : Color(hex: 0xAAAAAA)
                )
                .fixedSize(horizontal: false, vertical: true)
            Color(hex: 0xAAAAAA).frame(height: 1)
        }

    }
    
}

extension PokemonInfoPanel {
    ///头部信息(图标、名字、身高体重、属性)
    struct Header: View {
        let model: PokemonViewModel
        
        var body: some View {
            HStack(spacing: 18) {
                pokemonIcon
                nameSpecies
                verticalLine
                VStack(spacing: 12) {
                    bodyStatus
                    typeInfo
                }

            }
        }
        
        var pokemonIcon: some View {
            Image("Pokemon-\(model.id)")
                .resizable()
                .frame(width: 68, height: 68)
        }
        
        var nameSpecies: some View {
            VStack {
                Text(model.name)
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                    .foregroundColor(model.color)
                Text(model.nameEN)
                    .font(.system(size: 13))
                    .fontWeight(.bold)
                    .foregroundColor(model.color)
                Text(model.genus)
                    .font(.system(size: 13))
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .padding(.top,10)

            }
        }
        
        var verticalLine: some View {
            Color(hex: 0x000000, alpha: 0.1).frame(width: 1, height: 44)
        }
        
        var bodyStatus: some View {
            VStack {
                HStack {
                    Text("身高")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                    Text(model.height)
                        .font(.system(size: 11))
                        .foregroundColor(model.color)
                }
                HStack {
                    Text("体重")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                    Text(model.weight)
                        .font(.system(size: 11))
                        .foregroundColor(model.color)
                }
            }
        }
        
        var typeInfo: some View {
            HStack {
                ForEach(model.types) { type in
                    Text(type.name).font(.system(size: 10))
                        .frame(width: 36, height: 14, alignment: .center)
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 7)
                                .foregroundColor(type.color)
                    )
                }
            }
        }
    }
}



extension PokemonInfoPanel {
    struct AbilityList: View {
        let model: PokemonViewModel
        let abilityModels: [AbilityViewModel]?
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text("技能")
                    .font(.headline)
                    .fontWeight(.bold)
                
                if abilityModels != nil {
                    ForEach(abilityModels!) { ability in
                        Text(ability.name)
                            .font(.headline)
                            .foregroundColor(self.model.color)
                        Text(ability.descriptionText)
                            .font(.footnote)
                            .foregroundColor(Color(hex: 0xAAAAAA))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}



struct PokemonInfoPanel_Previews: PreviewProvider {
    static var previews: some View {
        PokemonInfoPanel(model: PokemonViewModel.sample(id: 1)).environmentObject(Store())
    }
}
