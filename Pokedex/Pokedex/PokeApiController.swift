//
//  PokeApiController.swift
//  Pokedex
//
//  Created by Chance Payne on 10/10/19.
//  Copyright © 2019 Chance Payne. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

enum NetworkingError: Error {
    case noData
    case noBearer
    case serverError(Error)
    case unexpectedStatusCode(Int)
    case badDecode
}

enum HeaderNames: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
}

class PokeApiController {
    let baseUrl = URL(string: "https://pokeapi.co/api/v2")
    
    func fetchListOfPokemon(offset: Int = 20, completion: @escaping (Result<[String], NetworkingError>) -> Void) {
        let requestUrl = baseUrl?.appendingPathComponent("pokemon")
        
        
    }
}
