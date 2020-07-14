//
//  EvolutionChainView.swift
//  PokeDex
//
//  Created by Tanishq Kancharla on 7/11/20.
//  Copyright © 2020 Tanishq Kancharla. All rights reserved.
//

import SwiftUI
import PokemonAPI
import Combine

struct EvolutionChainView: View {
    @ObservedObject var pkmInfo: PokemonInfo
    
    var body: some View {
        HStack{
            if pkmInfo.evolutionLoaded {
                ForEach(pkmInfo.evolution, id: \.id){ pkmInfo in
                    PokemonSpriteView(pkmInfo: pkmInfo , size: 40)
                    Image(systemName: "arrow.right")
                        .frame(width: 10, height: 10)
                        // No arrow for the last pokemon
                        .appearOn (
                            pkmInfo.id != self.pkmInfo.evolution.last?.id
                        )
                }
            } else {
                Image(systemName: "exclamationmark")
                    .frame(width: 40, height: 40)
            }
        }
        .onAppear {
            self.pkmInfo.loadEvolution()
        }
    }
}

struct EvolutionChainView_Previews: PreviewProvider {
    static var previews: some View {
        EvolutionChainView(pkmInfo: PokemonInfo(pokemon:bulbasaurData))
    }
}
