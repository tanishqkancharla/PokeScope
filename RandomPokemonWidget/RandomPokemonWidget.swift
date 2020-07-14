//
//  RandomPokemonWidget.swift
//  RandomPokemonWidget
//
//  Created by Tanishq Kancharla on 7/13/20.
//  Copyright © 2020 Tanishq Kancharla. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents
import PokemonAPI
import Combine

extension PokemonInfo: Equatable {
    static func == (lhs: PokemonInfo, rhs: PokemonInfo) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func loadWidgetData() -> Publishers.Zip<Published<Bool>.Publisher, Published<Bool>.Publisher> {
        self.loadSprite()
        self.loadEvolution()
        return $spriteLoaded
            .zip($evolutionLoaded)
    }
}

var cancellables = Set<AnyCancellable>()

struct Provider: IntentTimelineProvider {
    
    public func snapshot(for configuration: ConfigurationIntent, with context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let viewModel = RandomPokemonWidgetModel(PokemonInfo(pokemon: bulbasaurData))
        let entry = SimpleEntry(date: Date(), configuration: configuration, viewModel: viewModel)
        completion(entry)
    }

    public func timeline(for configuration: ConfigurationIntent, with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let timeInterval: Double = 15
        let viewModel = RandomPokemonWidgetModel(PokemonInfo(pokemon: bulbasaurData))
        let entries: [SimpleEntry] = [SimpleEntry(date: Date(), configuration: configuration, viewModel: viewModel)]
        let timeline = Timeline(entries: entries, policy: .after(
                                    Date(timeIntervalSinceNow:timeInterval)))
        viewModel.loadSprite {
            completion(timeline)
        }
        
//        api.pokemonService.fetchPokemon(Int.random(in: pokemonRange)) { result in
//            switch result {
//            case .failure(let error):
//                print(error)
//                let defaultPkm = PokemonInfo(pokemon: bulbasaurData)
//                let entries: [SimpleEntry] = [SimpleEntry(date: Date(), configuration: configuration, pkmInfo: defaultPkm)]
//                let timeline = Timeline(entries: entries, policy: .after(
//                                            Date(timeIntervalSinceNow:timeInterval)))
//                completion(timeline)
//            case .success(let pokemon):
//                let pkmInfo = PokemonInfo(pokemon: pokemon)
//                let entries = [SimpleEntry(date: Date(), configuration: configuration, pkmInfo: pkmInfo)]
//                let timeline = Timeline(entries: entries, policy: .after(
//                                            Date(timeIntervalSinceNow:timeInterval)))
//                completion(timeline)
//
//            }
//
//        }
       
    }
}

class SimpleEntry: TimelineEntry {
    public let date: Date
    public let configuration: ConfigurationIntent
    public var viewModel: RandomPokemonWidgetModel
    
    init(date: Date, configuration: ConfigurationIntent, viewModel: RandomPokemonWidgetModel) {
        self.date = date
        self.configuration = configuration
        self.viewModel = viewModel
    }
}

struct PlaceholderView : View {
    var body: some View {
        Text("Placeholder view")
    }
}

struct PokemonSpriteWidgetView: View {
    @ObservedObject var viewModel: RandomPokemonWidgetModel
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

struct RandomPokemonWidgetEntryView : View {
    var entry: Provider.Entry
    
    @ObservedObject var viewModel: RandomPokemonWidgetModel

    var body: some View {
        HStack{
            PokemonSpriteWidgetView(viewModel: viewModel, size: 100)
            PokemonBasicView(pkmInfo: viewModel.pkmInfo)
        }
        
    }
}

@main
struct RandomPokemonWidget: Widget {
    private let kind: String = "RandomPokemonWidget"

    public var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider(), placeholder: PlaceholderView()) { entry in
            RandomPokemonWidgetEntryView(entry: entry, viewModel: entry.viewModel)
                .onAppear {
                    print("Widget has appeared")
                }
        }
        .configurationDisplayName("Random Pokemon Widget")
        .description("This is a widget that shows you a new random pokemon every day")
        .supportedFamilies([.systemMedium])
    }
}



struct RandomPokemonWidget_Previews: PreviewProvider {
    static var previews: some View {
//        RandomPokemonWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
        Group {
            PokemonView(pkmInfo: PokemonInfo(pokemon: bulbasaurData))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .environment(\.colorScheme, .dark)
            PokemonView(pkmInfo: PokemonInfo(pokemon: bulbasaurData))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .environment(\.colorScheme, .light)
        }
    }
}
