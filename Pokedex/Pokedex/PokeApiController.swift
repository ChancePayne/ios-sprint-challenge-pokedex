//
//  PokeApiController.swift
//  Pokedex
//
//  Created by Chance Payne on 10/10/19.
//  Copyright © 2019 Chance Payne. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

enum NetworkingError: Error {
    case badUrl
    case noData
    case noBearer
    case serverError(Error)
    case unexpectedStatusCode(Int)
    case badDecode(Error)
}

enum HeaderNames: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
}

class PokeApiController {
    let baseUrl = URL(string: "https://pokeapi.co/api/v2")
    
    func fetchListOfPokemon(offset: Int = 0, limit: Int = 20, completion: @escaping (Result<PokeOverviewList, NetworkingError>) -> Void) {
        guard let requestUrl = baseUrl?.appendingPathComponent("pokemon"),
              var request = URLComponents(url: requestUrl, resolvingAgainstBaseURL: true) else {
            completion(.failure(.badUrl))
            return
        }
        
        let queryItems = [
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
        
        request.queryItems = queryItems
        
        URLSession.shared.dataTask(with: request.url!) { (data, response, error) in
            self.processResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
    }
    
    func fetchSpecificPokemon(by num: Int, completion: @escaping (Result<Pokemon, NetworkingError>) -> Void) {
        guard let requestUrl = baseUrl?.appendingPathComponent("pokemon").appendingPathComponent(String(num)) else {
            completion(.failure(.badUrl))
            return
        }
        
        URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in
            self.processResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
    }
    
    func fetchSpecificPokemon(by name: String, completion: @escaping (Result<Pokemon, NetworkingError>) -> Void) {
        guard let requestUrl = baseUrl?.appendingPathComponent("pokemon").appendingPathComponent(name) else {
            completion(.failure(.badUrl))
            return
        }
        
        URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in
            self.processResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
    }
    
    func fetchSpecificPokemonSpecies(from url: String, completion: @escaping (Result<PokemonFlavor, NetworkingError>) -> Void) {
        guard let requestUrl = URL(string: url) else {
            completion(.failure(.badUrl))
            return
        }
        
        URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in
            self.processResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
    }
    
    func fetchImage(at urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                NSLog("Error fetching image: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            completion(UIImage(data: data))
            
        }.resume()
    }

    private func processResponse<T: Codable>(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<T, NetworkingError>) -> Void) {
        if let error = error {
            completion(.failure(.serverError(error)))
        }
        
        if let response = response as? HTTPURLResponse,
            response.statusCode != 200 {
            completion(.failure(.unexpectedStatusCode(response.statusCode)))
        }
        
        guard let data = data else {
            completion(.failure(.noData))
            return
        }
        
        do {
            let names = try JSONDecoder().decode(T.self, from: data)
            completion(.success(names))
        } catch {
            completion(.failure(.badDecode(error)))
        }
    }
}
