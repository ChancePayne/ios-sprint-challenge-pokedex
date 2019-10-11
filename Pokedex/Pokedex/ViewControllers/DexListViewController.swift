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
    
    var pokeNames: [String] = []
    
    var nextUrl: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension DexListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pokeNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.pokeNames.count - 1 {
            self.loadData()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokeNameCell", for: indexPath)
        cell.textLabel?.text = pokeNames[indexPath.row]
        
        return cell
    }
    
    private func loadData() {
        
    }
}

extension DexListViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
}
