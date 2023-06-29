//
//  AddCityViewModel.swift
//  WeatherApp_TestPSA
//
//  Created by WG CONSULTING on 29/06/2023.
//

import Foundation
import MapKit

final class AddCityViewModel{
    
    var delegate: AddCityVCProtocol?
    
    private var selectedCityName: String?
    private var selectedCityCoordinates: CLLocationCoordinate2D?
    private var selectedCityCountry: String?
    
    //Valider les données renvoyées par la requête de recherche
    func validateSearchRequestData(searchResult: MKLocalSearchCompletion){
        
        let searchRequest = MKLocalSearch.Request(completion: searchResult)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { [weak self] (response, error) in
            
            //S'assurer que la requête n'a renvoyé aucune erreur
            guard error == nil else {
                self?.delegate?.showErrorAlertWithMessage(message: "L'application a rencontré une erreur inconnue. Veuillez réessayer")
                print("LocalSearch a rencontré une erreur: \(error!.localizedDescription)")
                return
            }
            
            //S'assurer que les informations requises sont valides
            guard let coordinate = response?.mapItems[0].placemark.coordinate,
            let name = response?.mapItems[0].name else {
                self?.delegate?.showErrorAlertWithMessage(message: "L'application a rencontré une erreur inconnue. Veuillez réessayer")
                print("LocalSearch n'a pas réussi à renvoyer les informations requises")
                return
            }
            let country = response?.mapItems[0].placemark.country
            
            self?.selectedCityName = name
            self?.selectedCityCoordinates = coordinate
            self?.selectedCityCountry = country
            
            self?.delegate?.askToConfirmSelectedCity(name: name, country: country)
        }
    }
    
    // Enregistrer l'objet de la ville dans CoreData
    func addAndSaveSelectedCity(){
        guard let name = selectedCityName,
              let coor = selectedCityCoordinates else {
            
            delegate?.showErrorAlertWithMessage(message: "L'application n'a pas réussi à ajouter la ville. Veuillez réessayer")
            return
        }
        
        CoreDataManager.shared.addCity(
            name: name,
            latitude: coor.latitude,
            longitude: coor.longitude,
            country: selectedCityCountry)
        
        delegate?.cityAddedAndSaved()
    }
    
}
