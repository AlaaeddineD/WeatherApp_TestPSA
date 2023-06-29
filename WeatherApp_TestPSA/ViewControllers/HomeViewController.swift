//
//  HomeViewController.swift
//  WeatherApp_TestPSA
//
//  Created by WG CONSULTING on 29/06/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var citiesTableView: UITableView!
    
    //Properties
    private var cities = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(presentAddCityView))
        
        setupCitiesTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cities = CoreDataManager.shared.fetchCities()
        citiesTableView.reloadData()
    }
    
    @objc func presentAddCityView(){
        guard let addCityVC = storyboard?.instantiateViewController(withIdentifier: AddCityViewController.storyboardIdentifier) as? AddCityViewController else {
            
            print("Impossible de trouver une vue avec cet identifiant \(AddCityViewController.storyboardIdentifier)")

            return
        }
        
        navigationController?.pushViewController(addCityVC, animated: true)
    }
    
    private func presentCityDetailsView(city: City){
        guard let cityDetailsVC = storyboard?.instantiateViewController(
            identifier: CityDetailsViewController.storyboardIdentifier,
            creator: { coder -> CityDetailsViewController? in
                CityDetailsViewController(coder: coder, city: city)
            }) as? CityDetailsViewController else {
            
            print("Impossible de trouver une vue avec cet identifiant \(CityDetailsViewController.storyboardIdentifier)")

            return
        }
        
        navigationController?.pushViewController(cityDetailsVC, animated: true)
    }
}

//MARK: TableViewDelegate
extension HomeViewController: UITableViewDelegate{
    
    //Configurer le TableView des villes
    private func setupCitiesTableView(){
        citiesTableView.delegate = self
        citiesTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        citiesTableView.deselectRow(at: indexPath, animated: true)
        presentCityDetailsView(city: cities[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.deleteCityAction(indexPath: indexPath)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func deleteCityAction(indexPath: IndexPath) {
        let city = cities[indexPath.row]
        
        let alert = UIAlertController(title: "Alert", message: "Voulez-vous vraiment supprimer \(city.name!)?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Oui", style: .destructive) {
            [weak self] _ in
            CoreDataManager.shared.deleteCity(city: city)
            self?.cities = CoreDataManager.shared.fetchCities()
            self?.citiesTableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Non", style: .default)
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: TableViewDataSource
extension HomeViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let city = cities[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = city.country != nil ? city.country! : "--"
        
        return cell
    }
}
