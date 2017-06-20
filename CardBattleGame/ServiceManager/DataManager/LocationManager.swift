//
//  LocationManager.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 16/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
  
  static let LATITUDE: Double = 51.400592
  static let LONGITUDE: Double = 4.760970
  static let DISTANCE_FILTER = 5000.0
  
  static let sharedInstance: LocationManager = {
    let instance = LocationManager()
    
    return instance
  }()
  
  var locations = [CLLocation]()
  
  lazy var locationManager:CLLocationManager = {
    var _locationManager = CLLocationManager()
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    _locationManager.activityType = .otherNavigation
    _locationManager.distanceFilter = DISTANCE_FILTER
    _locationManager.delegate = self
    _locationManager.requestAlwaysAuthorization()
    _locationManager.requestWhenInUseAuthorization()
    return _locationManager
  }()
  
  func startLocationUpdate(){
    // Here, the location manager will be lazily instantiated
    locationManager.startUpdatingLocation()
  }
  
  func stopLocationUpdate(){
    locationManager.stopUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedAlways:
      print("")
    case .authorizedWhenInUse:
      print("")
    case .denied:
      print("")
    case .notDetermined:
      print("")
    default:
      print("")
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // post a notification
    NotificationCenter.default.post(name:LocationNotification.kLocationUpdated, object: nil, userInfo: ["locations":locations])
    
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    stopLocationUpdate()
  }
}

struct LocationNotification {
  static let kLocationUpdated = Notification.Name("LocationUpdated")
  static let kAuthorizationStatusChanged = Notification.Name(rawValue: "AuthorizationStatusChanged")
  static let kLocationManagerDidFailWithError = Notification.Name(rawValue: "LocationManagerDidFailWithError")
}
