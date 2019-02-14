//
//  CellView.swift
//  Pokemon Inspector
//
//  Created by Artem Yerko on 15.12.2018.
//  Copyright © 2018 Artem Yerko. All rights reserved.
//

import UIKit

class CellView: UITableViewCell {
	
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var cellName:  UILabel!
    @IBOutlet private weak var cellGroup: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        setup()
    }
    
    func setup() {
        
    }
    
    func render(item: PokemonListM.PokemonM) {
        cellName.text   = item.name.uppercased()

        if let url = URL(string: item.imageUrl) {
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { print(error?.localizedDescription); return }
                DispatchQueue.main.async() {
                    self.cellImage.image = UIImage(data: data)
                }
            }
        }
        
        cellGroup.text  = item.type
    }
    // dont like it, because loading image in view(((
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
