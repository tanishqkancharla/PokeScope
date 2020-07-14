//
//  Utlls.swift
//  PokeDex
//
//  Created by Tanishq Kancharla on 7/6/20.
//  Copyright © 2020 Tanishq Kancharla. All rights reserved.
//

import Foundation
import PokemonAPI
import SwiftUI

// Default API to use
let api = PokemonAPI()

// Extend it to easily round to places (for stats)
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> String {
        String(format:"%.\(places)f", self)
    }
}

// Create a view modifier that accepts a bool to choose when to show the view
struct AppearModifier: ViewModifier {

    let appearOn: Bool

    func body(content: Content) -> some View {
        Group {
            if appearOn {
                content
            } else {
                EmptyView()
            }
        }
    }
}

extension View {
    /// Whether the view should appear.
    /// - Parameter bool: Set to `false` to hide the view (return EmptyView instead). Set to `true` to show the view.
    func appearOn(_ appear: Bool) -> some View {
        modifier(AppearModifier(appearOn: appear))
    }
}

extension PKMPokemon: Equatable {
    public static func == (lhs: PKMPokemon, rhs: PKMPokemon) -> Bool {
        return lhs.id == rhs.id
    }
}

func load<T: SelfDecodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = T.decoder
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

final class ImageStore {
    typealias _ImageDictionary = [String: CGImage]
    fileprivate var images: _ImageDictionary = [:]

    fileprivate static var scale = 2
    
    static var shared = ImageStore()
    
    func image(name: String) -> Image {
        let index = _guaranteeImage(name: name)
        
        return Image(images.values[index], scale: CGFloat(ImageStore.scale), label: Text(name))
    }

    static func loadImage(name: String) -> CGImage {
        guard
            let url = Bundle.main.url(forResource: name, withExtension: "png"),
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            fatalError("Couldn't load image \(name).png from main bundle.")
        }
        return image
    }
    
    fileprivate func _guaranteeImage(name: String) -> _ImageDictionary.Index {
        if let index = images.index(forKey: name) { return index }
        
        images[name] = ImageStore.loadImage(name: name)
        return images.index(forKey: name)!
    }
}
