//
//  AddCityViewController.swift
//  WeatherApp_TestPSA
//
//  Created by WG CONSULTING on 29/06/2023.
//

import UIKit
import MapKit

class AddCityViewController: UIViewController {
    
    static let storyboardIdentifier = "AddCityView"
    
    //Outlets
    @IBOutlet weak var suggestionsTableView: UITableView!
    
    //MARK: Properties
    private var searchController: UISearchController!
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add City"
        
        setupSearchBar()
        setupSearchCompleter()
        setupSuggestionsTableView()
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
        if searchText.count > 0 {
            searchCompleter.queryFragment = searchText
        }else {
            searchResults.removeAll()
            suggestionsTableView.reloadData()
        }
    }
}

//MARK: SearchCompleter
extension AddCityViewController: MKLocalSearchCompleterDelegate{
    
    //Configurer le SearchCompleter
    private func setupSearchCompleter(){
        searchCompleter.delegate = self
        searchCompleter.region = MKCoordinateRegion(.world)
        searchCompleter.pointOfInterestFilter = .excludingAll
    }
    
    //Appelé chaque fois que le searchCompleter a de nouveaux résultats
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        suggestionsTableView.reloadData()
    }
    
    //Appelé lorsqu'il y avait une erreur avec le searchCompleter
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search completer a rencontré une erreur: \(error.localizedDescription)")
    }
}

//MARK: TableViewDataSource
extension AddCityViewController: UITableViewDataSource{
    
    //Configurer le TableView des suggestions
    private func setupSuggestionsTableView(){
        suggestionsTableView.delegate = self
        suggestionsTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        
        return cell
    }
}

//MARK: TableViewDelegate
extension AddCityViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        suggestionsTableView.deselectRow(at: indexPath, animated: true)
    }
}
