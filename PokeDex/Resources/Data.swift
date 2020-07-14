//
//  Data.swift
//  PokeDex
//
//  Created by Tanishq Kancharla on 7/4/20.
//  Copyright © 2020 Tanishq Kancharla. All rights reserved.
//

import Foundation
import SwiftUI
import PokemonAPI
import Combine


let bulbasaurData: PKMPokemon = load("bulbasaur.json")

let enteiData: PKMPokemon = load("entei.json")

let defaultData: PKMPokemon = load("default.json")

let pokemonRange = 1...807

class PokemonInfo: ObservableObject {
    @Published var spriteLoaded: Bool
    @Published var evolutionLoaded: Bool
    @Published var flavorTextLoaded: Bool
    @Published var pokemon: PKMPokemon
    
    public var id : Int
    
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(pokemon: PKMPokemon){
        self.pokemon = pokemon
        self.spriteLoaded = false
        self.evolutionLoaded = false
        self.flavorTextLoaded = false
        self.id = pokemon.id!
    }
    
    // Sprite loading related
    
    public var sprite: Image = Image(systemName: "exclamationmark")
    
    func loadSprite() {
        print("Loading sprite")
        if let url = URL(string: (self.pokemon.sprites!.frontDefault)!) {
            URLSession.shared
                .dataTaskPublisher(for: URLRequest(url: url))
                .map(\.data)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }, receiveValue: { data in
                    if let image = UIImage(data: data) {
                        self.sprite = Image(uiImage: image)
                        self.spriteLoaded = true
                    }
                })
                .store(in: &self.cancellables)
        }
    }
    
    // Evolution loading related
    
    public var evolution: [PokemonInfo] = []
    private var evolutionLoading: Int = -1
    
    public func loadEvolution() {
        print("Loading evolution")
        self.evolutionLoaded = false
        self.evolution = []
        self.evolutionLoading = -1
        api.resourceService.fetch(pokemon.species!)
            .flatMap {
                api.resourceService.fetch($0.evolutionChain!)
            }
            .sinkToResult({ result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let chain):
                    self.parseChain(chain: chain)
                }
            })
            .store(in: &self.cancellables)
        
    }
    
    private func parseChain(chain: PKMEvolutionChain) {
        self.evolutionLoading = 0
        
        var chainLink = chain.chain
        while chainLink != nil {
            self.evolutionLoading += 1
            if let links = (chainLink?.evolvesTo) {
                if !links.isEmpty{
                    chainLink = links[0]
                } else {
                    chainLink = nil
                }
            } else {
                chainLink = nil
            }
        }
        
        self.evolution = [PokemonInfo](repeating: PokemonInfo(pokemon: bulbasaurData), count: self.evolutionLoading)
        chainLink = chain.chain
        var id = 0
        while chainLink != nil {
            self.addLink(id: id, chainLink: chainLink)
            id += 1
            if let links = (chainLink?.evolvesTo) {
                if !links.isEmpty{
                    chainLink = links[0]
                } else {
                    chainLink = nil
                }
            } else {
                chainLink = nil
            }
        }
        
    }
    
    private func addLink(id: Int, chainLink: PKMClainLink?){
        api.resourceService.fetch(chainLink!.species!)
            .flatMap({
                api.resourceService.fetch($0.varieties![0].pokemon!)
            })
            .receive(on: RunLoop.main)
            .sinkToResult({ result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let pokemon):
                    // Store it in the evolution chain
                    self.evolution[id] = PokemonInfo(pokemon: pokemon)
                    // If evolution chain is full, publish that
                    self.evolutionLoading -= 1
                    if self.evolutionLoading == 0 {
                        self.evolutionLoaded = true
                    }
                }
                
            })
            .store(in: &self.cancellables)
    }
    
    // Flavor text loading
    
    public var flavorText: String = ""
    
    public func loadFlavorText(){
        api.resourceService.fetch(pokemon.species!)
        .receive(on: RunLoop.main)
        .sinkToResult({ result in
            switch result{
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let species):
                // Find first english flavor text
                let flavorText = species.flavorTextEntries!.first(where: {
                    $0.language!.name == "en"
                })!.flavorText ?? ""
                
                self.flavorText =
                    String(flavorText
                            .map {
                                if $0 == "\n" {
                                    return " "
                                } else if $0 == "\u{0C}"{
                                    return " "
                                } else {
                                    return $0
                                }
                            })
                self.flavorTextLoaded = true
            }
        })
        .store(in: &self.cancellables)
    }
}
