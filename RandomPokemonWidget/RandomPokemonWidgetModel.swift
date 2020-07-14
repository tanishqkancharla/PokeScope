//
//  RandomPokemonWidgetModel.swift
//  PokeDex
//
//  Created by Tanishq Kancharla on 7/13/20.
//  Copyright © 2020 Tanishq Kancharla. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import PokemonAPI

func bulbasaur() -> RandomPokemonWidgetModel {
    let bulbasaurModel = RandomPokemonWidgetModel(PokemonInfo(pokemon: bulbasaurData))
    let bulbasaurSprite = Image(uiImage: UIImage(named: "bulbasaur.png")!)
    let ivysaurSprite = Image(uiImage: UIImage(named: "ivysaur.png")!)
    let venusaurSprite = Image(uiImage: UIImage(named: "venusaur.png")!)
    bulbasaurModel.sprite = bulbasaurSprite
    bulbasaurModel.evolution = [bulbasaurSprite, ivysaurSprite, venusaurSprite]
    bulbasaurModel.flavorText =
    """
        A strange seed was planted on its back at birth. The plant sprouts and grows with this POKéMON.
    """
    return bulbasaurModel
}


class RandomPokemonWidgetModel {
    public var id: Int
    
    public var pkmInfo: PokemonInfo? = nil
    private var species: PKMPokemonSpecies? = nil
    
    public var sprite: Image? = nil
    public var evolution: [Image]? = nil
    public var flavorText: String? = nil
    
    private var defaultImage = Image(systemName: "exclamationmark")
    
    public var evolutionLoading = -1
    
    init(_ pkmInfo: PokemonInfo){
        self.pkmInfo = pkmInfo
        self.id = pkmInfo.id
    }
    
    let pokemonRange = 1...807
    
    init() {
        self.id = Int.random(in: pokemonRange)
    }
    
    // Initialize with random pokemon
    func load(_ completion: @escaping () -> Void){
        api.pokemonService.fetchPokemon(self.id) { result in
            switch result {
            case .failure(let error):
                print("Could not fetch pokemon")
                print(error.localizedDescription)
                completion()
            case .success(let pokemon):
                self.pkmInfo = PokemonInfo(pokemon: pokemon)
                self.loadSprite {
                    self.loadEvolution {
                        self.loadFlavortext {
                            completion()
                        }
                    }
                }
            }
            
        }
    }
    
    func loadImage(url: URL, _ completion: @escaping (Image) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            guard let image = UIImage(data: data) else {
                completion(self.defaultImage)
                return
            }
            completion(Image(uiImage: image))
        }.resume()
    }
    
    func loadSprite(_ completion: @escaping () -> Void) {
        let spriteURL = pkmInfo?.pokemon.sprites?.frontDefault ?? ""
        if let url = URL(string: spriteURL) {
            loadImage(url: url) { image in
                DispatchQueue.main.async() { [weak self] in
                    self?.sprite = image
                }
                
                completion()
            }
        }
    }
    
    func loadEvolution(_ completion: @escaping () -> Void) {
        api.resourceService.fetch(pkmInfo!.pokemon.species!){ result in
            switch result {
            case .failure(_):
                self.evolution = []
                completion()
            case .success(let species):
                self.species = species
                api.resourceService.fetch(species.evolutionChain!){ result in
                    switch result {
                    case .failure(_):
                        self.evolution = []
                        completion()
                    case .success(let chain):
                        self.parseChain(chain: chain) {
                            completion()
                        }
                    }
                    
                }
                
            }
        }
    }
    private func parseChain(chain: PKMEvolutionChain, _ completion: @escaping () -> Void) {
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
        self.evolution = [Image](repeating: self.defaultImage, count: self.evolutionLoading)
        chainLink = chain.chain
        var id = 0
        while chainLink != nil {
            self.getLinkSprite(chainLink: chainLink!){ [id] image in
                self.evolution![id] = image
                self.evolutionLoading -= 1
                if self.evolutionLoading == 0 {
                    completion()
                }
                
            }
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
    private func getLinkSprite(chainLink: PKMClainLink, _ completion: @escaping (Image) -> Void){
        api.resourceService.fetch(chainLink.species!) { result in
            switch result {
            case .failure(_):
                completion(self.defaultImage)

            case .success(let species):
                api.resourceService.fetch(species.varieties![0].pokemon!) { result in
                    switch result {
                    case .failure(_):
                        completion(self.defaultImage)
                    case .success(let pokemon):
                        guard let url = URL(string: pokemon.sprites?.frontDefault ?? "") else {
                            completion(self.defaultImage)
                            return
                        }
                        self.loadImage(url: url, completion)
                    }
                }
            }
        }
    }
    
    private func loadFlavortext(_ completion: @escaping () -> Void){
        let flavorText = species!.flavorTextEntries!.first(where: {
            $0.language!.name == "en"
        })!.flavorText ?? ""
        
        self.flavorText =
            String(flavorText
                    // Map some weird characters from API
                    .map {
                        if $0 == "\n" {
                            return " "
                        } else if $0 == "\u{0C}"{
                            return " "
                        } else {
                            return $0
                        }
                    })
        completion()
    }
}
