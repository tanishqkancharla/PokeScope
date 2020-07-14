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
        let viewModel = bulbasaur()
        let entry = SimpleEntry(date: Date(), configuration: configuration, viewModel: viewModel)
        viewModel.load {
            completion(entry)
        }
    }

    public func timeline(for configuration: ConfigurationIntent, with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Request a new timeline every `timeInterval`
        let timeInterval: Double = 15
        // Initialize a random pokemon
        let viewModel = RandomPokemonWidgetModel()
        let entries: [SimpleEntry] = [SimpleEntry(date: Date(), configuration: configuration, viewModel: viewModel)]
        let timeline = Timeline(entries: entries, policy: .after(
                                    Date(timeIntervalSinceNow:timeInterval)))
        viewModel.load {
            completion(timeline)
        }
        
    
       
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
        Text("Loading...")
    }
}

struct RandomPokemonWidgetContainerView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family

    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            RandomPokemonWidgetSmallView(viewModel: entry.viewModel)
        case .systemMedium:
            RandomPokemonWidgetMediumView(viewModel: entry.viewModel)
        case .systemLarge:
            RandomPokemonWidgetLargeView(viewModel: entry.viewModel)
        @unknown default:
            RandomPokemonWidgetSmallView(viewModel: entry.viewModel)
        }
        
        
    }
}

struct RandomPokemonWidgetSmallView : View {
    var viewModel: RandomPokemonWidgetModel

    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
            VStack(spacing: 0) {
                SpriteWidgetView(viewModel: viewModel, size: 120)
                    .padding(.top)
                PokemonBasicWidgetView(viewModel: viewModel, showStats: false)
                    .offset(y: -15)
            }
            .padding()
        }
        
    }
}

struct RandomPokemonWidgetMediumView : View {
    var viewModel: RandomPokemonWidgetModel

    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
            HStack(spacing: 0) {
                VStack {
                    SpriteWidgetView(viewModel: viewModel, size: 100)
                    EvolutionChainWidgetView(viewModel: viewModel)
                        .offset(y: -15)
                }
                .padding(.vertical)
                PokemonBasicWidgetView(viewModel: viewModel, showStats: true)
                    .padding([.top, .leading, .bottom])
            }
        }
        
    }
}

struct RandomPokemonWidgetLargeView : View {
    var viewModel: RandomPokemonWidgetModel

    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
            VStack {
                HStack(spacing: 0) {
                    VStack {
                        SpriteWidgetView(viewModel: viewModel, size: 100)
                        EvolutionChainWidgetView(viewModel: viewModel)
                            .offset(y: -15)
                    }
                    PokemonBasicWidgetView(viewModel: viewModel, showStats: true)
                        .padding(.leading)
                }
                FlavorTextWidgetView(viewModel: viewModel)
                    .padding()
            }
        }
        
    }
}


@main
struct RandomPokemonWidget: Widget {
    private let kind: String = "RandomPokemonWidget"

    public var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider(), placeholder: PlaceholderView()) { entry in
            RandomPokemonWidgetContainerView(entry: entry)
        }
        .configurationDisplayName("Random Pokemon Widget")
        .description("This is a widget that shows you a new random pokemon every day")
    }
}



struct RandomPokemonWidget_Previews: PreviewProvider {
    static var previews: some View {
//        RandomPokemonWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
        Group {
            Group {
                RandomPokemonWidgetSmallView(viewModel: bulbasaur())
                    .previewContext(WidgetPreviewContext(family: .systemSmall))
                    .environment(\.colorScheme, .dark)
                RandomPokemonWidgetSmallView(viewModel: bulbasaur())
                    .previewContext(WidgetPreviewContext(family: .systemSmall))
                    .environment(\.colorScheme, .light)
            }
            Group {
                RandomPokemonWidgetMediumView(viewModel: bulbasaur())
                    .previewContext(WidgetPreviewContext(family: .systemMedium))
                    .environment(\.colorScheme, .dark)
                RandomPokemonWidgetMediumView(viewModel: bulbasaur())
                    .previewContext(WidgetPreviewContext(family: .systemMedium))
                    .environment(\.colorScheme, .light)
            }
            Group{
                RandomPokemonWidgetLargeView(viewModel: bulbasaur())
                    .previewContext(WidgetPreviewContext(family: .systemLarge))
                    .environment(\.colorScheme, .dark)
                RandomPokemonWidgetLargeView(viewModel: bulbasaur())
                    .previewContext(WidgetPreviewContext(family: .systemLarge))
                    .environment(\.colorScheme, .light)
            }
            
        }
    }
}
