//
//  PokemonSpecies.swift
//  Pokedex
//
//  Created by Chance Payne on 10/11/19.
//  Copyright © 2019 Chance Payne. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let pokemonSpecies = try? newJSONDecoder().decode(PokemonSpecies.self, from: jsonData)

import Foundation

struct PokemonFlavor: Codable {
    let id: Int
    let flavorTextEntries: [FlavorTextEntry]
    
    enum CodingKeys: String, CodingKey {
        case flavorTextEntries = "flavor_text_entries"
        case id
    }
}

struct FlavorTextEntry: Codable {
    let flavorText: String
    let language, version: External

    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language, version
    }
}

struct External: Codable {
    let name, url: String
}
