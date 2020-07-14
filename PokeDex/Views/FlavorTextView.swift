//
//  FlavorTextView.swift
//  PokeDex
//
//  Created by Tanishq Kancharla on 7/12/20.
//  Copyright © 2020 Tanishq Kancharla. All rights reserved.
//

import SwiftUI
import PokemonAPI
import Combine

struct FlavorTextView: View {
    @ObservedObject var pkmInfo: PokemonInfo
    
    var body: some View {
        HStack{
            if pkmInfo.flavorTextLoaded {
                Text(pkmInfo.flavorText)
            }
        }
        .onAppear {
            pkmInfo.loadFlavorText()
        }
    }
    
}

struct FlavorTextView_Previews: PreviewProvider {
    static var previews: some View {
        FlavorTextView(pkmInfo: PokemonInfo(pokemon:bulbasaurData))
    }
}
