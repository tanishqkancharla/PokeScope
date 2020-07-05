//
//  Observer.swift
//  PokeDex
//
//  Created by Tanishq Kancharla on 7/4/20.
//  Copyright © 2020 Tanishq Kancharla. All rights reserved.
//

import Foundation
import PokemonAPI
import Combine

class PokemonObserver : ObservableObject{
    @Published var loading = true
    @Published var pokemon: PKMPokemon? = nil
    var cancellable: AnyCancellable? = nil
    
    init() {
        loadPokemon()
    }
    
    func loadPokemon() {
        cancellable = PokemonAPI().pokemonService.fetchPokemon("bulbasaur")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            }, receiveValue: { pokemon in
                self.pokemon = pokemon // cheri
                self.loading = false
            })
    }
}
