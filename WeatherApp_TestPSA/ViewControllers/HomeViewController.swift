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
