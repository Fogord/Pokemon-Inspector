//
//  PokemonListVC.swift
//  Pokemon Inspector
//
//  Created by Artem Yerko on 11.12.2018.
//  Copyright © 2018 Artem Yerko. All rights reserved.
//

import UIKit
import NotificationCenter

class PokemonListVC: UIViewController {

    private var pokemonListV: PokemonListV {
        return self.view as! PokemonListV
    }
    
    private enum Constants {
        static let itemCellIdentifier = "CellView"
    }
    
    private var pokemonListModel : PokemonListM?
    private var filteredModel    : [PokemonListM.PokemonM] = []
    private var selectedScopeItem: String = ""
    
    init() {	
        super.init(nibName: "PokemonListV", bundle: nil)
        pokemonListModel = PokemonListM()
        pokemonListModel?.getAllItems()
        filteredModel = pokemonListModel?.list ?? []
        
        let cellNib = UINib(nibName: Constants.itemCellIdentifier, bundle: nil)
        pokemonListV.pokemonTableView.register(cellNib, forCellReuseIdentifier: Constants.itemCellIdentifier)
        
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
        
        pokemonListV.pokemonSearchBar.scopeButtonTitles = ["all"] + types
        pokemonListV.pokemonSearchBar.showsScopeBar = true
        
        pokemonListV.pokemonTableView.delegate = self
        pokemonListV.pokemonTableView.dataSource = self
        pokemonListV.pokemonSearchBar.delegate = self
    }
    
    @objc func getDataFromDB() {
        print("Notification was sent: getDataFromDB")
        filteredModel = pokemonListModel?.list ?? []
        print(filteredModel.count)
    }
    
    @objc func refreshTableViwe() {
        print("Notification was sent: refreshTableViwe")
        filteredModel = pokemonListModel?.list ?? []
        pokemonListV.pokemonTableView.reloadData()
    }
}

extension PokemonListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = pokemonListV.pokemonTableView.dequeueReusableCell(withIdentifier: Constants.itemCellIdentifier, for: indexPath) as? CellView
            else { return UITableViewCell() }
        
        cell.render(item: filteredModel[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredModel.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let deteilsVC = PokemonDeteilsVC(filteredModel[indexPath.row])
        navigationController?.pushViewController(deteilsVC, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pokemonListV.pokemonSearchBar.endEditing(true)
    }
}

extension PokemonListVC: UISearchBarDelegate {
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
        
        pokemonListV.pokemonTableView.reloadData()
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
        
        pokemonListV.pokemonTableView.reloadData()
    }
}
