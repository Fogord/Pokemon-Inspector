//
//  PokemonDeteilsVC.swift
//  Pokemon Inspector
//
//  Created by Artem Yerko on 15.12.2018.
//  Copyright © 2018 Artem Yerko. All rights reserved.
//

import UIKit

class PokemonDeteilsVC: UIViewController {
    
    private var pokemonDeteilsV: PokemonDeteilsV {
        return self.view as! PokemonDeteilsV
    }
    
    init(_ item: PokemonListM.PokemonM) {
        super.init(nibName: "PokemonDeteilsV", bundle: nil)
        
        pokemonDeteilsV.nameDeteils.text   = item.name.uppercased()
        pokemonDeteilsV.typeDeteils.text   = "Type: " + (String(item.type) ?? "")
        pokemonDeteilsV.heightDeteils.text = "Height: " + (String(item.height) ?? "")
        pokemonDeteilsV.weightDeteils.text = "Weight: " + (String(item.weight) ?? "")
        
        if let url = URL(string: item.imageUrl) {
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { print(error?.localizedDescription); return }
                DispatchQueue.main.async() {
                    self.pokemonDeteilsV.imageDeteils.image = UIImage(data: data)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    func setup() {
        navigationItem.title = "Pokemon Deteils"
    }

    // dont like it, because loading image in view(((
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
