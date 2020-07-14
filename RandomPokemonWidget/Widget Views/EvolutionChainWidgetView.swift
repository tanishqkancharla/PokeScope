//
//  EvolutionChainWidgetView.swift
//  PokeDex
//
//  Created by Tanishq Kancharla on 7/14/20.
//  Copyright © 2020 Tanishq Kancharla. All rights reserved.
//

import SwiftUI

struct EvolutionChainWidgetView: View {
    var viewModel: RandomPokemonWidgetModel
    
    var body: some View {
        HStack{
            ForEach(0..<viewModel.evolution!.count){ imageId in
                viewModel.evolution![imageId]
                    .resizable()
                    .frame(width:40, height:40)
                Image(systemName: "arrow.right")
                    .frame(width: 10, height: 10)
                    // No arrow for the last pokemon
                    .appearOn (
                        imageId != viewModel.evolution!.count-1
                    )
            }
        }
    }
}

