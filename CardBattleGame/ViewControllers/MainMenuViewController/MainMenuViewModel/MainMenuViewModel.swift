//
//  MainMenuViewModel.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 14/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

// MARK :  Update Weather Data
//
protocol MainMenuViewModelDelegate: class{
    
    func updateWeatherData () -> Void
}



class MainMenuViewModel: NSObject {
    
    weak var delegate : MainMenuViewModelDelegate?
    
    // Initialize Weather Data Model
    //
    var weatherData: WeatherData = WeatherData()
    
    
    // MARK : Featch Weather Report
    //
    func fetchWeatherReport() -> Void {
        
        let appendUrl = "\(API.APIKey)/\(Defaults.Latitude),\(Defaults.Longitude)"
        
        let baseURL : URL = API.BaseURL
        let url = baseURL.appendingPathComponent(appendUrl)
        
        ServiceManager.sharedInstance.fetchDataForGetConnection(url) { (data, response, error) in
            
            if let error = error {
                
                print(error.localizedDescription)
                
            } else if let data = data, let response = response as? HTTPURLResponse {
                
                if response.statusCode == 200 {
                    
                    var jsonDictionary: [String: Any]?
                    
                    do {
                        
                        jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        
                    } catch {
                        
                        print("InvalidResponse")
                        
                    }
            
                    do {
                        
                        try self.decodeJSON(jsonDictionary!)
                        
                    } catch {
                        
                        print("Unable to parse data")
                        
                    }
                    
                    
                } else {
                    
                    print("failedRequest")
                    
                }
                
            } else {
                
                print("unknown")
                
            }
        }
    }
    
    
    private func decodeJSON(_ jsonDictionary: [String: Any]) throws {
        
        let timeZone = jsonDictionary["timezone"] as? String
        let currently: [String: Any] = (jsonDictionary["currently"] as? [String : Any])!
        let time = currently["time"] as? Double
        let summary = currently["summary"] as? String
        let temperature = currently["temperature"] as? Double
        let windSpeed = currently["windSpeed"] as? Double
        let icon = currently["icon"] as? String
        let apparentTemperature = currently["apparentTemperature"] as? Double
        
        let dtTime = Date(timeIntervalSince1970: time! / 1000.0)
        let minTemprature = temperature?.toCelcius()
        let maxTemprature = apparentTemperature?.toCelcius()
       
        weatherData.updateWeatherData(time: dtTime, timeZone: timeZone! , windSpeed: windSpeed!, minTemprature: minTemprature!, summary: summary!, icon: icon!, maxTemprature: maxTemprature!)
        
        self.delegate?.updateWeatherData()
    }
    
}
