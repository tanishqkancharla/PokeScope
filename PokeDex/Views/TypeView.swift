//
//  TypeView.swift
//  PokeDex
//
//  Created by Tanishq Kancharla on 7/12/20.
//  Copyright © 2020 Tanishq Kancharla. All rights reserved.
//

import SwiftUI
import PokemonAPI

let PKMTypes: [String:Color] = [
    "bug": Color("Bug"),
    "flying": Color("Flying-1"),
    "dragon": Color("Dragon-1"),
    "fairy": Color("Fairy"),
    "fire": Color("Bug"),
    "ghost": Color("Ghost"),
    "ground": Color("Ground-1"),
    "normal": Color("Normal"),
    "psychic": Color("Psychic"),
    "steel": Color("Steel"),
    "dark": Color("Dark"),
    "electric": Color("Electric"),
    "fighting": Color("Fighting"),
    "grass": Color("Grass"),
    "poison": Color("Poison"),
    "rock": Color("Rock"),
    "water": Color("Water"),
    "ice": Color("Ice")
]

struct TypeView: View {
    let type: PKMNamedAPIResource<PKMType>
    
    var body: some View {
        Text(type.name!)
            .font(.footnote)
            .foregroundColor(Color.primary.opacity(0.9))
            .padding(.leading, 5)
            .padding(.trailing, 5)
            .background(PKMTypes[type.name!])
            .cornerRadius(3)
    }
}

struct TypeView_Previews: PreviewProvider {
    static var previews: some View {
        HStack{
            ForEach(bulbasaurData.types!, id: \.slot!){ PKMtype in
                TypeView(type: PKMtype.type!)
            }
            .padding()
        }
        .background(Color(UIColor.secondarySystemBackground))
        .environment(\.colorScheme, .dark)
    }
}
