//
//  PokemonView.swift
//  PokeDex
//
//  Created by Tanishq Kancharla on 7/4/20.
//  Copyright © 2020 Tanishq Kancharla. All rights reserved.
//

import SwiftUI
import PokemonAPI
import Combine
import Foundation

struct PokemonView: View {
    @ObservedObject var pkmInfo: PokemonInfo
    
    @State var expanded: Bool = false
    
    var body: some View {
        VStack{
            HStack(alignment: .top){
                VStack(spacing: 0){
                    PokemonSpriteView(pkmInfo: pkmInfo, size: 100)
                    EvolutionChainView(pkmInfo: pkmInfo)
                        
                }
                .padding(.trailing, 5)
//                .padding(.right)
                PokemonBasicView(pkmInfo: pkmInfo)
//                .border(Color.purple)
            }
//            if expanded {
                FlavorTextView(pkmInfo: pkmInfo)
//            }
            
            
        }
        .padding(.all)
        .frame(width: 350)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.expanded.toggle()
            }
        }
    }
}

struct PokemonBasicView : View {
    @ObservedObject var pkmInfo: PokemonInfo
    
    var body: some View{
        VStack(alignment: .leading) {
            Text(pkmInfo.pokemon.name!.capitalized)
                .font(Font.title.bold())
                .lineLimit(1)
                .allowsTightening(true)
            HStack {
                ForEach(pkmInfo.pokemon.types!, id: \.slot!){ PKMtype in
                    TypeView(type: PKMtype.type!)
                }
            }
            .padding(.bottom)
            Spacer()
            
            Text("Height:")
                .bold()
                + Text(" \((Double(pkmInfo.pokemon.height!)/10.0).rounded(toPlaces: 1)) m")
                
            Text("Weight:")
                .bold()
                + Text(" \((Double(pkmInfo.pokemon.weight!)/10.0).rounded(toPlaces: 1)) kg")
        }
        .padding(.top, 20)
        .frame(height: 140)
    }
}

struct PokemonView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonView(pkmInfo: PokemonInfo(pokemon:bulbasaurData))
            .environment(\.colorScheme, .dark)
    }
}
