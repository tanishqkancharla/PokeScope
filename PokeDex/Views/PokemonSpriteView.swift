//
//  PokemonSpriteView.swift
//  PokeDex
//
//  Created by Tanishq Kancharla on 7/7/20.
//  Copyright © 2020 Tanishq Kancharla. All rights reserved.
//

import SwiftUI
import PokemonAPI

struct PokemonSpriteView: View {
    @ObservedObject var pkmInfo: PokemonInfo
    let size: Float
    
    var body: some View {
        VStack{
            if !pkmInfo.spriteLoaded {
                Image(systemName: "exclamationmark")
//                    .renderingMode(.original)
                    .frame(width: CGFloat(size), height: CGFloat(size))
            } else {
                pkmInfo.sprite
                    .resizable()
                    .renderingMode(.original)
//                    .scaleEffect(1.5)
                    .frame(width: CGFloat(size), height: CGFloat(size))
            }
//            Slider(value: $size, in:0.0...300.0, step: 1.0)
        }
        .onAppear {
            pkmInfo.loadSprite()
        }
    }

}

struct SpriteView : View {
    
    var body: some View {
        EmptyView()
    }
}

struct PokemonSpriteView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonView(pkmInfo: PokemonInfo(pokemon:bulbasaurData))
            .environment(\.colorScheme, .dark)
    }
}
