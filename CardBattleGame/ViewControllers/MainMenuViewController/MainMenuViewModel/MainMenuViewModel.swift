//
//  MainMenuViewModel.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 14/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit
import CoreLocation
// MARK :  Update Weather Data
//
protocol MainMenuViewModelDelegate: class{
    
    func updateWeatherData () -> Void
}



class MainMenuViewModel: NSObject {
    
    
    var latitude = Defaults.Latitude
    var longitude = Defaults.Longitude
    
    weak var delegate : MainMenuViewModelDelegate?
    
    // Initialize Weather Data Model
    //
    var weatherData: WeatherData = WeatherData()
    
    
    
    override init() {
        super .init()
        
        // Start Location Update
        ServiceManager.sharedInstance.startLocationUpdate()
        
        // Location Update Observer
        //
        NotificationCenter.default.addObserver(forName: LocationNotification.kLocationUpdated, object: nil, queue: nil){ [weak self] (notification) in
            self?.notificationForLocationUpdate(notification)
        }
    
    }
    
    
    //  MARK : Deinitializer
    //
    deinit {
        
        //Remove Location Update Notification Observer
        NotificationCenter.default.removeObserver(self, name: LocationNotification.kLocationUpdated, object: nil)
        
        // Start Location Update
        ServiceManager.sharedInstance.stopLocationUpdate()
    }
    
    
    // MARK : Location Update Notification Handler
    //
    func notificationForLocationUpdate(_ notification:Notification) -> Void {
        guard let locations:[CLLocation] = notification.userInfo?["locations"] as? [CLLocation] else {
            return
        }
        for location in locations{
            
                self.latitude = location.coordinate.latitude
                self.longitude = location.coordinate.longitude
                
                fetchWeatherReport()
        }
    }

    
    // MARK : Featch Weather Report
    //
    func fetchWeatherReport() -> Void {
        
        let appendUrl = "\(API.APIKey)/\(latitude),\(longitude)"
        
        let baseURL : URL = API.BaseURL
        let url = baseURL.appendingPathComponent(appendUrl)
        
        ServiceManager.sharedInstance.fetchDataForGetConnection(url) { (data, response, error) in
            
            if error != nil {
                
                CBGErrorHandler.handle(error : .failedRequest)
                
            } else if let data = data, let response = response as? HTTPURLResponse {
                
                if response.statusCode == 200 {
                    
                    var jsonDictionary: [String: Any]?
                    
                    do {
                        
                        jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    } catch {
                        
                        CBGErrorHandler.handle(error : .invalidResponse)
                    }
            
                    do {
                        
                        try self.decodeJSON(jsonDictionary!)
                        
                    } catch {
                        
                        CBGErrorHandler.handle(error : .faildParseWeatherData)
                    }
                    
                    
                } else {
                    
                    CBGErrorHandler.handle(error : .failedRequest)
                }
                
            } else {
                
                CBGErrorHandler.handle(error : .unknown)
            }
        }
    }
    
    
    // MARK : Parsing WEATHER JSON DATA
    //
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
