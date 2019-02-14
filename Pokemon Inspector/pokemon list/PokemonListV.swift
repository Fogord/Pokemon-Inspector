//
//  PokemonListV.swift
//  Pokemon Inspector
//
//  Created by Artem Yerko on 11.12.2018.
//  Copyright © 2018 Artem Yerko. All rights reserved.
//

import UIKit

class PokemonListV: UIView {

    @IBOutlet weak var pokemonTableView: UITableView!
    @IBOutlet weak var pokemonSearchBar: UISearchBar!
    @IBOutlet weak var actibityIndicate: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        pokemonSearchBar.placeholder = "Enter the pokemon name..."
        
        actibityIndicate.hidesWhenStopped = true;
        actibityIndicate.stopAnimating();
    }
}
