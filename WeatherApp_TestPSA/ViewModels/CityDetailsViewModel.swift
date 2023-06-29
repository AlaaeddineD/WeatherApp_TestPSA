//
//  CityDetailsViewModel.swift
//  WeatherApp_TestPSA
//
//  Created by WG CONSULTING on 29/06/2023.
//

import Foundation

final class CityDetailsViewModel{
    
    var delegate: CityDetailsVCProtocol?
    private var city: City
    private let weatherApiCall = WeatherApiCall()
    
    init(city: City) {
        self.city = city
    }
    
    //Décidez quelles données afficher
    func decideWhatDataToShow(isRefreshing: Bool){
        if city.weatherData != nil && !isRefreshing{
            validateCityDataBeforePresenting(showAlert: true)
        }else {
            //Vérifiez la disponibilité d'Internet
            if(NetworkMonitor.shared.isInternetAvailable()){
                loadCityData()
            }else {
                delegate?.showErrorAlertWithMessage(message: "Impossible de se connecter à nos serveurs ! S'il vous plaît, vérifiez votre connexion à internet et réessayez.")
            }
        }
    }
    
    func loadCityData(){
        delegate?.showHideLoadingSpinner(show: true)
        
        weatherApiCall.makeWeatherApiCall(city: city){
            [weak self] result in
            
            DispatchQueue.main.async {
                self?.delegate?.showHideLoadingSpinner(show: false)
                switch result{
                case .success(let data):
                    if let weatherData = self?.city.weatherData{
                        CoreDataManager.shared.updateWeatherDataToCity(data: weatherData, response: data)
                    }else{
                        CoreDataManager.shared.addWeatherDataToCity(city: self!.city, response: data)
                    }
                    self?.validateCityDataBeforePresenting(showAlert: false)
                case .failure(let errorMessage):
                    print(errorMessage)
                    self?.delegate?.showErrorAlertWithMessage(message: "Nous avons rencontré une erreur inattendue ! Veuillez réessayer")
                }
            }
        }
    }
    
    
    func validateCityDataBeforePresenting(showAlert: Bool){
        guard let weatherData = city.weatherData else {
            return
        }
        
        let alertMessage = showAlert ? "This is an old data. Refresh for new Data." : ""
        
        //convertir de m/s a km/h
        let windSpeed = weatherData.windSpeed * 3.6
        
        //Formatter les dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let callTime = dateFormatter.string(from: weatherData.timeOfCall!)
        let sunrise = dateFormatter.string(from: weatherData.sunriseTime!)
        let sunset = dateFormatter.string(from: weatherData.sunsetTime!)
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let callDate = dateFormatter.string(from: weatherData.timeOfCall!)
        
        
        delegate?.presentData(
            alertLabelMessage: alertMessage,
            cityName: city.name ?? "--",
            country: city.country ?? "--",
            temp: "\((Int)(weatherData.temperature))°",
            icon: weatherData.icon!,
            feelsLike: "feels like \((Int)(weatherData.feelsLike))°",
            callTime: callTime,
            callDate: callDate,
            sunriseTime: sunrise,
            sunsetTime: sunset,
            humidity: "\(weatherData.humidity)%",
            windSpeed: "\((Int)(windSpeed))Km/h",
            cloudiness: "\(weatherData.cloudiness)%",
            rain: "\((Int)(weatherData.rain))",
            snow: "\((Int)(weatherData.snow))")
        
    }
}
