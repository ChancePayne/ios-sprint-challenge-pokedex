//
//  PokeOverview.swift
//  Pokedex
//
//  Created by Chance Payne on 10/10/19.
//  Copyright © 2019 Chance Payne. All rights reserved.
//

import Foundation

struct PokeOverviewList: Codable {
    let count: Int
    let results: [PokeOverview]
    let next: String?
    let previous: String?
}

struct PokeOverview: Codable {
    let name: String
    let url: String
}
