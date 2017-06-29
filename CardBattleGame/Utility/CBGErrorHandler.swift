//
//  CBGErrorHandler.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 15/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

enum ErrorType: Error {
  case failedRequest
  case faildParseWeatherData
  case invalidResponse
  case failedToIntializeTheGame
  case failedToIntializeWeatherData
  case failedManagedObjectFetchRequest
  case unknown
}

class CBGErrorHandler: Error {
  
  static func handle( error : ErrorType)  {
    switch error {
    case .failedRequest:
      errorAlert(errorTitle: "Error", errorMsg: "Failed Request")
    case .faildParseWeatherData:
      errorAlert(errorTitle: "Error", errorMsg: "Faild To Parse Weather Data")
    case .invalidResponse:
      errorAlert(errorTitle: "Error", errorMsg: "Invalid Response")
    case .failedToIntializeWeatherData:
      errorAlert(errorTitle: "Error", errorMsg: "Failed to Initialize Weather Data")
    case .failedToIntializeTheGame:
      errorAlert(errorTitle: "Error", errorMsg: "Failed to Initialize the Game")
    case .failedManagedObjectFetchRequest:
      errorAlert(errorTitle: "Error", errorMsg: "Failed To Perform Managed Object Fetch Request")
    default:
      errorAlert(errorTitle: "Error", errorMsg: "Unknown")
    }
  }
  
  
  static private func errorAlert(errorTitle: String, errorMsg: String){
    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
    
    let alertController =  UIAlertController(title: errorTitle, message: errorMsg, preferredStyle: UIAlertControllerStyle.alert)
    let okAction  = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) in
      alertWindow.isHidden = true
    }
    alertController.addAction(okAction)
    alertWindow.rootViewController = UIViewController()
    alertWindow.windowLevel = UIWindowLevelAlert;
    alertWindow.makeKeyAndVisible()
    alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
  }
}
