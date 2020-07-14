//
//  ContentView.swift
//  PokeDex
//
//  Created by Tanishq Kancharla on 7/4/20.
//  Copyright © 2020 Tanishq Kancharla. All rights reserved.
//

import SwiftUI
import PokemonAPI
import Combine

struct RandomPokemonListView: View {
    
    @ObservedObject var listModel = RandomPokemonListViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center){
                ForEach(listModel.totalPokemon, id:\.id){ pokemon in
                    PokemonView(pkmInfo: pokemon)
                        .onAppear {
                            if pokemon.id == listModel.totalPokemon.last?.id {
                                listModel.loadRandomPKM(10)
                                print("At bottom \(pokemon.id)")
                            }
                        }
                }
            }
        }
    }
}

class RandomPokemonListViewModel: ObservableObject {
    @Published var totalPokemon: [PokemonInfo] = []
    private var buffer: [PokemonInfo] = []
    
    private var cancellable: AnyCancellable?
    
    init(){
        loadRandomPKM()
    }
    
    private func getRandomInts(_ num: Int = 10) -> [Int] {
        return Array(repeating: 0, count: num)
            .map {_ in
                Int.random(in: pokemonRange)
            }
    }
    
    public func loadRandomPKM(_ num: Int = 10) {
        if #available(iOS 14.0, *) {
            cancellable = getRandomInts(num)
                .publisher
                .flatMap {
                    api.pokemonService.fetchPokemon($0)
                }
                .receive(on: RunLoop.main)
                .sinkToResult { result in
                    switch result{
                    case .failure(let error):
                        print(error)
                    case .success(let pokemon):
                        self.buffer.append(PokemonInfo(pokemon: pokemon))
                        if self.buffer.count == num {
                            self.totalPokemon += self.buffer
                            self.buffer = []
                        }
                    }
                    
                }
        }
    }
    
}

struct RandomPokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        RandomPokemonListView()
    }
}
