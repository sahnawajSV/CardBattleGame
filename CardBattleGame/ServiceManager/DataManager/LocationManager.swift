//
//  LocationManager.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 16/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit
import CoreLocation

/// Location Manager : Determines User Current Location
class LocationManager: NSObject {
  
  static let defaultLatitude: Double = 51.400592
  static let defaultLongitude: Double = 4.760970
  static let defaultDistanceFilter = 5000.0
  
  private var locations = [CLLocation]()
  
  	static let sharedInstance: LocationManager = {
    let instance = LocationManager()
    return instance
  }()
  
  private lazy var locationManager:CLLocationManager = {
    var _locationManager = CLLocationManager()
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    _locationManager.activityType = .otherNavigation
    _locationManager.distanceFilter = defaultDistanceFilter
    _locationManager.delegate = self
    _locationManager.requestAlwaysAuthorization()
    _locationManager.requestWhenInUseAuthorization()
    return _locationManager
  }()
  
  /// Start Location Update
  func startLocationUpdate(){
    // Here, the location manager will be lazily instantiated
    locationManager.startUpdatingLocation()
  }
  
  /// Stop Location Update
  func stopLocationUpdate(){
    locationManager.stopUpdatingLocation()
  }
  
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
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
    // post a location update notification to the observer class
    NotificationCenter.default.post(name:Notification.Name.kLocationUpdated, object: nil, userInfo: ["locations":locations])
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    stopLocationUpdate()
  }
}


extension Notification.Name {
  static let kLocationUpdated = Notification.Name(rawValue: "LocationUpdated")
  static let kAuthorizationStatusChanged = Notification.Name(rawValue: "AuthorizationStatusChanged")
  static let kLocationManagerDidFailWithError = Notification.Name(rawValue: "LocationManagerDidFailWithError")
}
