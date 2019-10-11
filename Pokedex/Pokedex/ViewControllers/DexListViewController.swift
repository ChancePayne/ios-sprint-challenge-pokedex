//
//  DexListViewController.swift
//  Pokedex
//
//  Created by Chance Payne on 10/10/19.
//  Copyright © 2019 Chance Payne. All rights reserved.
//

import UIKit

class DexListViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var pokeNames: [PokeOverview] = []
    var filteredNames: [PokeOverview] = []
    
    var totalCount: Int = Int.max
    
    let apiController = PokeApiController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.searchBar.delegate = self

        // Do any additional setup after loading the view.
        loadData()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "PokeDetailSegue" {
            if let nextVc = segue.destination as? PokemonDetailViewController {
                nextVc.apiController = apiController
                if let indexPath = tableView.indexPathForSelectedRow {
                    nextVc.pokemonName = tableView.cellForRow(at: indexPath)?.textLabel?.text
                }
            }
        }
    }
}

extension DexListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.filteredNames.count - 1 && self.pokeNames.count < totalCount {
            self.loadData(offset: self.pokeNames.count)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokeNameCell", for: indexPath)
        let name = filteredNames[indexPath.row].name
        
        cell.textLabel?.text = name.capitalizeFirstCharacter()
        cell.detailTextLabel?.text = String(1 + (self.pokeNames.firstIndex(where: { (pokeoverview) -> Bool in
            pokeoverview.name == name
        }) ?? -1))
        
        return cell
    }
    
    private func loadData(offset: Int = 0) {
        apiController.fetchListOfPokemon(offset: offset, limit: 20) { (result) in
            do {
                let data = try result.get()
                self.totalCount = data.count
                self.pokeNames.append(contentsOf: data.results)
                
                DispatchQueue.main.async {
                    self.filterData(with: self.searchBar.text)
                }
            } catch {
                NSLog("Error in processing: \(error)")
            }
        }
    }
}

extension DexListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData(with: searchText)
    }
    
    func filterData(with target: String?) {
        guard let target = target, !target.isEmpty else {
            self.filteredNames = self.pokeNames
            self.tableView.reloadData()
            return
        }
        
        self.filteredNames = pokeNames.filter({ (pokeOverview) -> Bool in
            return pokeOverview.name.contains(target.lowercased())
        })
        self.tableView.reloadData()
    }
}
