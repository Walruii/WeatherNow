//
//  WeatherManager.swift
//  WeatherNow
//
//  Created by Inderpreet Bhatti on 17/10/24.
//


import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(_ error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    
    func fetchWeather(cityName: String) {
        if let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String {
            let urlString = "\(weatherURL)&appid=\(apiKey)&q=\(cityName)"
            performRequest(with: urlString);
        } else {
            print("API Key not found")
        }
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        if let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String {
            let urlString = "\(weatherURL)&appid=\(apiKey)&lat=\(latitude)&lon=\(longitude)"
            performRequest(with: urlString);
        } else {
            print("API Key not found")
        }
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    self.delegate?.didFailWithError(error)
                    return
                }
                
                if let safeData = data  {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}
