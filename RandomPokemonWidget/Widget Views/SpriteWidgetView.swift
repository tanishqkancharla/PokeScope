//
//  SpriteWidgetView.swift
//  PokeDex
//
//  Created by Tanishq Kancharla on 7/14/20.
//  Copyright © 2020 Tanishq Kancharla. All rights reserved.
//

import SwiftUI

struct SpriteWidgetView: View {
    var viewModel: RandomPokemonWidgetModel
    let size: Float
    
    var body: some View {
        VStack{
            if (viewModel.sprite == nil) {
                Image(systemName: "exclamationmark")
                    .frame(width: CGFloat(size), height: CGFloat(size))
            } else {
                viewModel.sprite!
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: CGFloat(size), height: CGFloat(size))
            }
        }
    }
}

struct SpriteWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SpriteWidgetView(viewModel: bulbasaur(), size: 40)
            SpriteWidgetView(viewModel: bulbasaur(), size: 100)
            SpriteWidgetView(viewModel: bulbasaur(), size: 140)
        }
        
    }
}
