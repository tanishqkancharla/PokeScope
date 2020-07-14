//
//  FlavorTextWidgetView.swift
//  PokeDex
//
//  Created by Tanishq Kancharla on 7/14/20.
//  Copyright © 2020 Tanishq Kancharla. All rights reserved.
//

import SwiftUI

struct FlavorTextWidgetView: View {
    let viewModel: RandomPokemonWidgetModel
    
    var body: some View {
        Text(viewModel.flavorText!)
    }
}

struct FlavorTextWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        FlavorTextWidgetView(viewModel: bulbasaur())
    }
}
