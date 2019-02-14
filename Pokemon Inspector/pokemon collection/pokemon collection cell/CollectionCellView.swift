//
//  CollectionViewCollectionViewCell.swift
//  Pokemon Inspector
//
//  Created by Artem Yerko on 10.01.2019.
//  Copyright © 2019 Artem Yerko. All rights reserved.
//

import UIKit

class CollectionCellView: UICollectionViewCell {

    @IBOutlet weak var collectionImage: UIImageView!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var collectionGroup: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        print(self.frame.width, self.frame.height)
        // Initialization code
    }

    func render(item: PokemonListM.PokemonM) {
        collectionName?.text = item.name.uppercased()
        
        if let url = URL(string: item.imageUrl) {
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { print(error?.localizedDescription); return }
                DispatchQueue.main.async() {
                    self.collectionImage.image = UIImage(data: data)
                }
            }
        }
        
        collectionGroup.text  = item.type
    }
    // dont like it, because loading image in view(((
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

