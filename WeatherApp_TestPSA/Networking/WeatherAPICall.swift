//
//  WeatherAPICall.swift
//  WeatherApp_TestPSA
//
//  Created by WG CONSULTING on 29/06/2023.
//

import Foundation

final class WeatherApiCall{
    
    func makeWeatherApiCall(city: City, completionHandler: @escaping ((Result<WeatherApiResponse,ApiCallError>) -> ())) {
        
        guard let url = URL(string: WeatherApi.weatherDetailsUrl(latitude: city.latitude, longitude: city.longitude)) else {
            completionHandler(.failure(.url_not_found))
            return
        }
        
        let request = URLRequest(url: url)
        
        let session = URLSession.shared.dataTask(with: request){
            data, _, error in
            
            if error != nil {
                completionHandler(.failure(.unexpected_error("API call return an error: \(error!.localizedDescription)")))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.unexpected_error("Api call returned a null data")))
                return
            }
            
            do{
                let response: WeatherApiResponse = try JSONDecoder().decode(WeatherApiResponse.self, from: data)
                
                completionHandler(.success(response))
                
            }catch{
                completionHandler(.failure(.unexpected_error("Fetch weather data attempt for \(city.name!) failed with error: \(error.localizedDescription)")))
            }
        }
        
        session.resume()
    }
}
