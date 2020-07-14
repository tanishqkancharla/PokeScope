//
//  PokemonBasicView.swift
//  PokeDex
//
//  Created by Tanishq Kancharla on 7/14/20.
//  Copyright © 2020 Tanishq Kancharla. All rights reserved.
//

import SwiftUI
import PokemonAPI

struct PokemonBasicWidgetView : View {
    var viewModel: RandomPokemonWidgetModel
    
    var showStats: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.pkmInfo!.pokemon.name!.capitalized)
                .font(Font.title.bold())
                .lineLimit(1)
                .allowsTightening(true)
            HStack {
                ForEach(viewModel.pkmInfo!.pokemon.types!, id: \.slot!){ PKMtype in
                    TypeView(type: PKMtype.type!)
                }
            }
            .padding(.bottom)
            if showStats {
                Text("Height:")
                    .bold()
                    + Text(" \((Double(viewModel.pkmInfo!.pokemon.height!)/10.0).rounded(toPlaces: 1)) m")
                    
                Text("Weight:")
                    .bold()
                    + Text(" \((Double(viewModel.pkmInfo!.pokemon.weight!)/10.0).rounded(toPlaces: 1)) kg")
            }
            
        }
    }
}


struct PokemonBasicWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            PokemonBasicWidgetView(viewModel: bulbasaur(), showStats: true)
            PokemonBasicWidgetView(viewModel: bulbasaur(), showStats: false)
        }
    }
}
