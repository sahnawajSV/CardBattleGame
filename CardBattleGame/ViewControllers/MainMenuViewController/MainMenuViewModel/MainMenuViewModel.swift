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
  
  var timeText: String = ""
  var timeZoneText : String = ""
  var windSpeedText: String = ""
  var tempratureText: String = ""
  var summaryText: String = ""
  var iconImage: UIImage?
  
  
  var latitude = LocationManager.LATITUDE
  var longitude = LocationManager.LONGITUDE
  
  weak var delegate : MainMenuViewModelDelegate?
  
  override init() {
    super .init()
    
    // Start Location Update
    LocationManager.sharedInstance.startLocationUpdate()
    
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
    LocationManager.sharedInstance.stopLocationUpdate()
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
  
  
  // MARK : Parsing WEATHER JSON DATA
  //
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
        let minTemprature = temperature.toCelcius()
        let maxTemprature = apparentTemperature.toCelcius()
        let min = String(format: "%.0f°", minTemprature)
        let max = String(format: "%.0f°", maxTemprature)
        tempratureText = "\(min) - \(max)"
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
  
  
  //  Mark :  Helper Method
  //
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
