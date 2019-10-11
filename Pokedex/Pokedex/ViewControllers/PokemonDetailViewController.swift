//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Chance Payne on 10/11/19.
//  Copyright © 2019 Chance Payne. All rights reserved.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var flavorLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var spriteImage: UIImageView!
    
    var pokemonName: String?
    var apiController: PokeApiController?
    
    var pokemon: Pokemon?
    var pokemonFlavor: PokemonFlavor?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadViews()
    }
    
    func loadViews() {
        guard let pokemonName = pokemonName else { return }
        
        self.title = pokemonName
        // get pokemon details
        apiController?.fetchSpecificPokemon(by: pokemonName.lowercased(), completion: { (result) in
            do {
                let data = try result.get()
                
                // get sprite
                self.apiController?.fetchImage(at: data.sprites.frontDefault, completion: { (image) in
                    DispatchQueue.main.async {
                        self.spriteImage.image = image
                    }
                })
                
                // get flavor text
                self.apiController?.fetchSpecificPokemonSpecies(from: data.species.url, completion: { (result) in
                    do {
                        let data = try result.get()
                        let flavorTextEnglish = data.flavorTextEntries.filter { (entry) -> Bool in
                            return entry.language.name == "en"
                        }
                        var flavorText = ""
                        flavorTextEnglish.forEach { (entry) in
                            flavorText += entry.version.name.capitalizeFirstCharacter() + "\n" + entry.flavorText.replacingOccurrences(of: "\n", with: " ") + "\n\n"
                        }
                        
                        DispatchQueue.main.async {
                            self.flavorLabel?.text = flavorText
                            self.scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: self.flavorLabel.bottomAnchor).isActive = true
                        }
                    } catch {
                        NSLog("Fetch Pokemon flavor error: \(error)")
                    }
                })
                
                DispatchQueue.main.async {
                    self.titleLabel?.text =  "\(data.id) - \(data.name.capitalizeFirstCharacter())"
                }
            } catch {
                NSLog("Fetch Pokemon detail error: \(error)")
            }
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
