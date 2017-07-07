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
  
  private let locationManager = LocationManager.sharedInstance
  private let connectionManager = ConnectionManager.sharedInstance
  
  weak var delegate : MainMenuViewModelDelegate?
  
  private var myObserver: NSObjectProtocol?
  
  init() {
    // Start Location Update
    locationManager.startLocationUpdate()
    
    //Add Location Update Observer
    myObserver = NotificationCenter.default.addObserver(forName: Notification.Name.LocationUpdated, object: nil, queue: nil){ [weak self] (notification) in
      self?.handleLocationUpdate(notification)
    }
    
  }
  
  //  MARK : Deinitializer
  //
  deinit {
    //Remove Location Update Notification Observer
    if let observer = myObserver {
      NotificationCenter.default.removeObserver(observer, name: Notification.Name.LocationUpdated, object: nil)
    }
    
    // Stop Location Update
    locationManager.stopLocationUpdate()
  }
  
  
  // MARK : Location Update Notification Handler
  //
  private func handleLocationUpdate(_ notification:Notification) -> Void {
    guard let location: CLLocation = notification.userInfo?["currentLocation"] as? CLLocation else {
      return
    }
    latitude = location.coordinate.latitude
    longitude = location.coordinate.longitude
    
    fetchWeatherReport()
  }
  
  // MARK : Featch Weather Report
  //
  func fetchWeatherReport() -> Void {
    
    let appendUrl = "/\(latitude),\(longitude)"
    
    let baseURL : URL = API.authenticatedBaseURL
    let url = baseURL.appendingPathComponent(appendUrl)
    
    connectionManager.fetchWeatherReport(url) {  (response, error) in
      if let error = error {
        CBGErrorHandler.handle(error: error)
      } else if let response = response {
        self.timeZoneText = response.timeZone
        self.timeText = response.time.toString(withFormat: "dd MMM yy hh:mm")
        self.windSpeedText = String(format: "%.f KPH", response.windSpeed)
        
        let minTemperature = response.temperature.toCelcius()
        let maxTemperature = response.apparentTemperature.toCelcius()
        self.temperatureText = String(format: "%.0f° - %.0f°", minTemperature, maxTemperature)
        
        self.summaryText = response.summary
        self.iconImage = self.imageForWeatherIcon(withName: response.icon)
        self.delegate?.updateWeatherData()
      }
    }
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
