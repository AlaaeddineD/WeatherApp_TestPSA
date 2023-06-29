//
//  WeatherData+CoreDataProperties.swift
//  WeatherApp_TestPSA
//
//  Created by WG CONSULTING on 29/06/2023.
//
//

import Foundation
import CoreData


extension WeatherData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherData> {
        return NSFetchRequest<WeatherData>(entityName: "WeatherData")
    }

    @NSManaged public var temperature: Double
    @NSManaged public var feelsLike: Double
    @NSManaged public var icon: String?
    @NSManaged public var humidity: Int32
    @NSManaged public var visibility: Int32
    @NSManaged public var windSpeed: Double
    @NSManaged public var cloudiness: Int32
    @NSManaged public var rain: Double
    @NSManaged public var snow: Double
    @NSManaged public var timeOfCall: Date?
    @NSManaged public var sunriseTime: Date?
    @NSManaged public var sunsetTime: Date?
    @NSManaged public var city: City?

}

extension WeatherData : Identifiable {

}
