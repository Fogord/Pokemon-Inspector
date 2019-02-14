//
//  PokemonCollectionVC.swift
//  Pokemon Inspector
//
//  Created by Artem Yerko on 10.01.2019.
//  Copyright © 2019 Artem Yerko. All rights reserved.
//

import UIKit

class PokemonCollectionVC: UIViewController {

    var pokemonCollectionV: PokemonCollectionV {
        return self.view as! PokemonCollectionV
    }
    
    private enum Constants {
        static let itemCollectionCellIdentifier = "CollectionCellView"
    }
    
    private var pokemonListModel : PokemonListM?
    private var filteredModel    : [PokemonListM.PokemonM] = []
    private var selectedScopeItem: String = ""
    private var isCollectionCellInOneLine: Bool = false
    
    init() {
        super.init(nibName: "PokemonCollectionV", bundle: nil)
        pokemonListModel = PokemonListM()
        pokemonListModel?.getAllItems()
        filteredModel = pokemonListModel?.list ?? []
        
        let collectionCellNib = UINib(nibName: Constants.itemCollectionCellIdentifier, bundle: nil)
        pokemonCollectionV.pokemonCollectionView.register(collectionCellNib, forCellWithReuseIdentifier: Constants.itemCollectionCellIdentifier)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshTableViwe),
            name: NotificatiomNames.dataIsReceived,
            object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        navigationItem.title = "Pokemon List"
        navigationItem.leftBarButtonItem?.title = "Back"
        setNAvigationBarButton(imageName: "listView")
        
        pokemonCollectionV.pokemonSearchBar.scopeButtonTitles = ["all"] + types
        pokemonCollectionV.pokemonSearchBar.showsScopeBar = true
        
        pokemonCollectionV.pokemonCollectionView.delegate = self
        pokemonCollectionV.pokemonCollectionView.dataSource = self
        pokemonCollectionV.pokemonSearchBar.delegate = self
    }
    
    @objc func changeWidthOfCell() {
        isCollectionCellInOneLine = !isCollectionCellInOneLine
        
        let layout = UICollectionViewFlowLayout()
        var cellSize = CGSize()
        if isCollectionCellInOneLine {
            cellSize = CGSize(width:pokemonCollectionV.pokemonCollectionView.frame.width, height:100)
            setNAvigationBarButton(imageName: "gridView")

        } else {
            cellSize = CGSize(width:100 , height:100)
            setNAvigationBarButton(imageName: "listView")
        }
 
        layout.itemSize = cellSize
        pokemonCollectionV.pokemonCollectionView.setCollectionViewLayout(layout, animated: true)
        
        pokemonCollectionV.pokemonCollectionView.reloadData()
    }
    
    @objc func refreshTableViwe() {
        print("Notification was sent: refreshTableViwe")
        filteredModel = pokemonListModel?.list ?? []
        pokemonCollectionV.pokemonCollectionView.reloadData()

    }
    
    func setNAvigationBarButton(imageName: String) {
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: imageName, in: nil, compatibleWith:  UITraitCollection(horizontalSizeClass: .compact)), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(changeWidthOfCell))
    }
    
}


extension PokemonCollectionVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = pokemonCollectionV.pokemonCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.itemCollectionCellIdentifier, for: indexPath) as? CollectionCellView
            else { return UICollectionViewCell() }
        
        cell.render(item: filteredModel[indexPath.row])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let deteilsVC = PokemonDeteilsVC(filteredModel[indexPath.row])
        navigationController?.pushViewController(deteilsVC, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pokemonCollectionV.pokemonSearchBar.endEditing(true)
    }
}


extension PokemonCollectionVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredModel = []
        
        if let modelItems = pokemonListModel?.list {
            for item in modelItems {
                if !searchText.isEmpty &&
                    item.name.lowercased().contains(searchText.lowercased()) &&
                    ( item.type == searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex] || searchBar.selectedScopeButtonIndex == 0)
                {
                    filteredModel.append(item)
                } else if searchText.isEmpty && item.type == searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex]
                {
                    filteredModel = modelItems;
                } else if searchText.isEmpty && searchBar.selectedScopeButtonIndex == 0
                {
                    filteredModel = modelItems;
                }
            }
        }

        pokemonCollectionV.pokemonCollectionView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filteredModel = []

        if let modelItems = pokemonListModel?.list {
            for item in modelItems {
                if let searchText = searchBar.text {
                    if searchBar.text != "" &&
                        item.name.lowercased().contains(searchText.lowercased()) &&
                        item.type == searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex]
                    {
                        filteredModel.append(item)
                    } else if searchBar.text == "" &&
                        item.type == searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex]
                    {
                        filteredModel.append(item);
                    } else if searchBar.text != "" &&
                        searchBar.selectedScopeButtonIndex == 0
                    {
                        filteredModel.append(item);
                    } else if searchBar.selectedScopeButtonIndex == 0
                    {
                        filteredModel = modelItems;
                    }
                }
            }
        }

        pokemonCollectionV.pokemonCollectionView.reloadData()
    }
}


extension PokemonCollectionVC: UICollectionViewDelegateFlowLayout {
    
}
