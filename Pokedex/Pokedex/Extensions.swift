//
//  Extensions.swift
//  Pokedex
//
//  Created by Chance Payne on 10/11/19.
//  Copyright © 2019 Chance Payne. All rights reserved.
//

import Foundation

extension String {
    func capitalizeFirstCharacter() -> String {
        return self.replacingCharacters(in: self.startIndex...self.startIndex, with: String(self[self.startIndex]).uppercased())
    }
}
