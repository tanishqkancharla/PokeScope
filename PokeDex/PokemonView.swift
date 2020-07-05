//
//  PokemonView.swift
//  PokeDex
//
//  Created by Tanishq Kancharla on 7/4/20.
//  Copyright © 2020 Tanishq Kancharla. All rights reserved.
//

import SwiftUI
import PokemonAPI

struct PokemonView: View {
    @State var sprite: Image = Image(systemName: "exclamationmark")
    let pokemon: PKMPokemon
    
    var body: some View {
        HStack{
            sprite
                .resizable()
                .frame(width: 100, height: 100)
                .scaledToFill()
//                .border(Color.black)
            VStack(alignment: .leading) {
                Text(pokemon.name!.capitalized)
                    .padding(.bottom)
                    .font(.headline)
                Text("Height: \(pokemon.height!)")
                Text("Weight: \(pokemon.weight!)")
            }
//            .frame(width: 200, height: 100)
//            .border(Color.blue)
//            .padding(.all)
//            Spacer()
        }
        .padding(.all)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(24)
        .onAppear(perform: {
            if let spriteUrl = URL(string: (self.pokemon.sprites!.frontDefault)!) {
                self.loadSprite(url: spriteUrl)
            }
            
        })
        
    }
    
    func loadSprite(url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            if let image = UIImage(data: data) {
                self.sprite = Image(uiImage: image)
            }
        }.resume()
    }
}

struct PokemonView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonView(sprite: bulbasaurSprite, pokemon: bulbasaurData)
    }
}
