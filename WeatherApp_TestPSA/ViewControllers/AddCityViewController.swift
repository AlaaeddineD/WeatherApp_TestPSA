//
//  AddCityViewController.swift
//  WeatherApp_TestPSA
//
//  Created by WG CONSULTING on 29/06/2023.
//

import UIKit

class AddCityViewController: UIViewController {
    
    static let storyboardIdentifier = "AddCityView"
    
    //MARK: Properties
    private var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add City"
        
        setupSearchBar()
    }
}

//MARK: Search bar
extension AddCityViewController: UISearchResultsUpdating{
    
    //Configurer le SearchBar
    private func setupSearchBar(){
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    //Recevoir des mises à jour lorsque le texte de la barre de recherche est modifié
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
    }
}
