//
//  PokemonLaunchVC.swift
//  Pokemon Inspector
//
//  Created by Artem Yerko on 09.01.2019.
//  Copyright © 2019 Artem Yerko. All rights reserved.
//

import UIKit
import NotificationCenter

class PokemonLaunchVC: UIViewController {

    private var pokemonLaunchV: PokemonLaunchV {
        return self.view as! PokemonLaunchV
    }
    
    init() {
        super.init(nibName: "PokemonLaunchV", bundle: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(stopActivityIndicator),
            name: NotificatiomNames.dataIsSync,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(changeCounterActivityIndicator),
            name: NotificatiomNames.dataWasGot,
            object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    private func setup() {
        
        DispatchQueue.main.async {
            let server = Server()
            server.getAll()
        }
        
    }
    
    @objc func stopActivityIndicator() {
        let isListView: Bool  = false
        let rootVC = isListView ? PokemonListVC() : PokemonCollectionVC()
        let navigationController = UINavigationController (rootViewController: rootVC)
        navigationController.navigationBar.isTranslucent = false
        pokemonLaunchV.window?.rootViewController = navigationController
        
        pokemonLaunchV.activityIndicator.hidesWhenStopped = true;
        pokemonLaunchV.activityIndicator.stopAnimating()
        pokemonLaunchV.activityText.text = ""
    }
    
    @objc func changeCounterActivityIndicator(notification: NSNotification) {
        pokemonLaunchV.activityCounter.text = notification.userInfo?["counter"] as! String
    }
}
