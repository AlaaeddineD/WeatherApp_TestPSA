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
