//
//  ContentView.swift
//  PokeDex
//
//  Created by Tanishq Kancharla on 7/4/20.
//  Copyright © 2020 Tanishq Kancharla. All rights reserved.
//

import SwiftUI
import PokemonAPI

struct ContentView: View {
//    @ObservedObject var observer = PokemonObserver()
    
    var body: some View {
        TabView {
            VStack{
//                if observer.loading {
//                    Text("Loading...")
//                } else {
//                    PokemonView(pokemon: observer.pokemon!)
//                }
                PokemonView(pokemon: bulbasaurData)
            }
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("First")
                }
            Text("Another Tab")
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Second")
                }
            Text("The Last Tab")
                .tabItem {
                    Image(systemName: "3.square.fill")
                    Text("Third")
                }
        }
        .font(.headline)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
