//
//  CoreDataManager.swift
//  WeatherApp_TestPSA
//
//  Created by WG CONSULTING on 29/06/2023.
//

import Foundation
import CoreData

/// Gérer l'enregistrement et le chargement des données dans CoreData
final class CoreDataManager{
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherApp_TestPSA")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //Créer et enregistrer une ville dans CoreData
    func addCity(name: String, latitude: Double, longitude: Double, country: String?){
        let city = City(context: persistentContainer.viewContext)
        city.name = name
        city.latitude = latitude
        city.longitude = longitude
        city.country = country
        save()
    }
    
    func fetchCities() -> [City] {
        let request: NSFetchRequest<City> = City.fetchRequest()
        var fetchedCities: [City] = []
        do {
            fetchedCities = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching citites: \(error)")
        }
        return fetchedCities
    }
    
    func addWeatherDataToCity(city: City, response: WeatherApiResponse){
        let data = WeatherData(context: persistentContainer.viewContext)
        
        data.temperature = response.main.temp
        data.feelsLike = response.main.feelsLike
        data.icon = response.weather[0].icon
        data.humidity = Int32(response.main.humidity)
        data.visibility = Int32(response.visibility)
        data.windSpeed = response.wind.speed
        data.cloudiness = Int32(response.clouds.all)
        data.rain = response.rain != nil ? response.rain!.lastHour : 0
        data.snow = response.snow != nil ? response.snow!.lastHour : 0
        data.timeOfCall = Date(timeIntervalSince1970: response.dt)
        data.sunriseTime = Date(timeIntervalSince1970: response.sys.sunrise)
        data.sunsetTime = Date(timeIntervalSince1970: response.sys.sunset)
        
        city.weatherData = data
        save()
    }
    
    func updateWeatherDataToCity(data: WeatherData, response: WeatherApiResponse){
        data.temperature = response.main.temp
        data.feelsLike = response.main.feelsLike
        data.icon = response.weather[0].icon
        data.humidity = Int32(response.main.humidity)
        data.visibility = Int32(response.visibility)
        data.windSpeed = response.wind.speed
        data.cloudiness = Int32(response.clouds.all)
        data.rain = response.rain != nil ? response.rain!.lastHour : 0
        data.snow = response.snow != nil ? response.snow!.lastHour : 0
        data.timeOfCall = Date(timeIntervalSince1970: response.dt)
        data.sunriseTime = Date(timeIntervalSince1970: response.sys.sunrise)
        data.sunsetTime = Date(timeIntervalSince1970: response.sys.sunset)
        
        save()
    }
    
    func save () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
