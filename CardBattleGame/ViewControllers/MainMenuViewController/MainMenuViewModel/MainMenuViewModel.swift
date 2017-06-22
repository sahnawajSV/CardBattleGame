//
//  MainMenuViewModel.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 14/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit
import CoreLocation


protocol MainMenuViewModelDelegate: class{
  
  func updateWeatherData () -> Void
}

/// Main Menu View Model(Follow MVVM pattern): Looks for user current location based on that it provides Weather Report
class MainMenuViewModel {
  
  var timeText: String = ""
  var timeZoneText : String = ""
  var windSpeedText: String = ""
  var temperatureText: String = ""
  var summaryText: String = ""
  var iconImage: UIImage?
  
  
  private var latitude = LocationManager.defaultLatitude
  private var longitude = LocationManager.defaultLongitude
  
  weak var delegate : MainMenuViewModelDelegate?
  
  private var myObserver: NSObjectProtocol?
  
  init() {
    // Start Location Update
    LocationManager.sharedInstance.startLocationUpdate()
    
    //Add Location Update Observer
    myObserver = NotificationCenter.default.addObserver(forName: Notification.Name.kLocationUpdated, object: nil, queue: nil){ [weak self] (notification) in
      self?.notificationForLocationUpdate(notification)
    }
    
    // Request For Weather Data
    fetchWeatherReport()
  }
  
  //  MARK : Deinitializer
  //
  deinit {
    
    //Remove Location Update Notification Observer
    if let observer = myObserver {
      NotificationCenter.default.removeObserver(observer, name: Notification.Name.kLocationUpdated, object: nil)
    }
    
    // Start Location Update
    LocationManager.sharedInstance.stopLocationUpdate()
  }
  
  
  // MARK : Location Update Notification Handler
  //
  private func notificationForLocationUpdate(_ notification:Notification) -> Void {
    guard let locations:[CLLocation] = notification.userInfo?["locations"] as? [CLLocation] else {
      return
    }
    for location in locations{
      
      self.latitude = location.coordinate.latitude
      self.longitude = location.coordinate.longitude
      
      fetchWeatherReport()
    }
  }
  
  // MARK : Featch Weather Report And Parse Data
  //
  private func fetchWeatherReport() -> Void {
    
    let appendUrl = "/\(latitude),\(longitude)"
    
    let baseURL : URL = API.authenticatedBaseURL
    let url = baseURL.appendingPathComponent(appendUrl)
    
    ConnectionManager.sharedInstance.fetchDataForGetConnection(url) {  (data, response, error) in
      
      if error != nil {
        
        CBGErrorHandler.handle(error : .failedRequest)
        
      } else if let data = data, let response = response as? HTTPURLResponse {
        
        if response.statusCode == 200 {
          
          var jsonDictionary: [String: Any]?
          
          do {
            jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            self.decodeJSON(jsonDictionary!)
            
          } catch ErrorTpe.failedRequest{
            CBGErrorHandler.handle(error : .invalidResponse)
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
  
  private func decodeJSON(_ jsonDictionary: [String: Any]) {
    if let timeZone = jsonDictionary["timezone"] as? String{
      timeZoneText = timeZone
    }
    if let currently: [String: Any] = jsonDictionary["currently"] as? [String : Any]{
      
      if let time = currently["time"] as? Double{
        let dtTime = Date(timeIntervalSince1970: time / 1000.0)
        timeText = dtTime.toString(dateFormat: "dd MMM yy hh:mm")
      }
      
      if let windSpeed = currently["windSpeed"] as? Double{
        windSpeedText = String(format: "%.f KPH", windSpeed)
      }
      
      if let temperature = currently["temperature"] as? Double, let apparentTemperature = currently["apparentTemperature"] as? Double{
        let minTemperature = temperature.toCelcius()
        let maxTemperature = apparentTemperature.toCelcius()
        temperatureText = String(format: "%.0f° - %.0f°", minTemperature, maxTemperature)
      }
      
      if let summary = currently["summary"] as? String{
        summaryText = summary
      }
      
      if let icon = currently["icon"] as? String{
        iconImage = imageForWeatherIcon(withName: icon)
      }
      
    }
    
    self.delegate?.updateWeatherData()
  }
  
  private func imageForWeatherIcon(withName name: String) -> UIImage? {
    switch name {
    case "clear-day":
      return UIImage(named: "clear-day")
    case "clear-night":
      return UIImage(named: "clear-night")
    case "rain":
      return UIImage(named: "rain")
    case "snow":
      return UIImage(named: "snow")
    case "sleet":
      return UIImage(named: "sleet")
    case "wind", "cloudy", "partly-cloudy-day", "partly-cloudy-night":
      return UIImage(named: "cloudy")
    default:
      return UIImage(named: "clear-day")
    }
  }
  
}
