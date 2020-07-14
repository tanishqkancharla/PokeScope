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


class RandomPokemonWidgetModel: ObservableObject {
    @Published public var pkmInfo: PokemonInfo
    
    public var sprite: Image? = nil
    public var evolution: [Image]? = nil
    
    public var evolutionLoading = -1
    
    init(_ pkmInfo: PokemonInfo){
        self.pkmInfo = pkmInfo
    }
    
    func loadSprite(_ completion: @escaping () -> Void) {
        let spriteURL = pkmInfo.pokemon.sprites?.frontDefault ?? ""
        if let url = URL(string: spriteURL) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() { [weak self] in
                    guard let image = UIImage(data: data) else {
                        print("Image was not in correct format")
                        return
                    }
                    self?.sprite = Image(uiImage: image)
                    print("Finished sprite request")
//                    self?.pkmInfo.spriteLoaded = true
                }
                
                completion()
            }.resume()
            print("Started sprite request")
        }
    }
    
    func loadEvolution(_ completion: @escaping () -> Void) {
        
    }
    
//    public func loadEvolution() {
//        print("Loading evolution")
//        self.evolution = []
//        self.evolutionLoading = -1
//        api.resourceService.fetch(self.pkmInfo.pokemon.species!)
//            .flatMap {
//                api.resourceService.fetch($0.evolutionChain!)
//            }
//            .flatMap({
//                parseChain(chain: $0)
//            })
//            .sinkToResult({ result in
//                switch result {
//                case .failure(let error):
//                    print(error.localizedDescription)
//                case .success(let chain):
//                    self.parseChain(chain: chain)
//                }
//            })
//    }
//
//    private func parseChain(chain: PKMEvolutionChain) {
//        self.evolutionLoading = 0
//
//        var chainLink = chain.chain
//        while chainLink != nil {
//            self.evolutionLoading += 1
//            if let links = (chainLink?.evolvesTo) {
//                if !links.isEmpty{
//                    chainLink = links[0]
//                } else {
//                    chainLink = nil
//                }
//            } else {
//                chainLink = nil
//            }
//        }
//
//        self.evolution = [PokemonInfo](repeating: PokemonInfo(pokemon: bulbasaurData), count: self.evolutionLoading)
//        chainLink = chain.chain
//        var id = 0
//        while chainLink != nil {
//            self.addLink(id: id, chainLink: chainLink)
//            id += 1
//            if let links = (chainLink?.evolvesTo) {
//                if !links.isEmpty{
//                    chainLink = links[0]
//                } else {
//                    chainLink = nil
//                }
//            } else {
//                chainLink = nil
//            }
//        }
//
//    }
//
//    private func addLink(id: Int, chainLink: PKMClainLink?){
//        api.resourceService.fetch(chainLink!.species!)
//            .flatMap({
//                api.resourceService.fetch($0.varieties![0].pokemon!)
//            })
//            .receive(on: RunLoop.main)
//            .sinkToResult({ result in
//                switch result {
//                case .failure(let error):
//                    print(error.localizedDescription)
//                case .success(let pokemon):
//                    // Store it in the evolution chain
//                    self.evolution[id] = PokemonInfo(pokemon: pokemon)
//                    // If evolution chain is full, publish that
//                    self.evolutionLoading -= 1
//                    if self.evolutionLoading == 0 {
//                        self.evolutionLoaded = true
//                    }
//                }
//
//            })
//            .store(in: &self.cancellables)
//    }
}
