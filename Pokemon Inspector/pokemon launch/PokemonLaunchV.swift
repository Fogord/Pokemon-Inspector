//
//  PokemonLaunchV.swift
//  Pokemon Inspector
//
//  Created by Artem Yerko on 09.01.2019.
//  Copyright © 2019 Artem Yerko. All rights reserved.
//

import UIKit

class PokemonLaunchV: UIView {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityText: UILabel!
    @IBOutlet weak var activityCounter: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {        
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.startAnimating();
    }
}
