//
//  CBGErrorHandler.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 15/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

enum ErrorTpe: Error {
    case failedRequest
    case faildParseWeatherData
    case invalidResponse
    case unknown
}

class CBGErrorHandler: Error {
    
   static func handle( error : ErrorTpe)  {
        switch error {
        case .failedRequest:
            errorAlert(errorTitle: "Error", errorMsg: "Failed Request")
        case .faildParseWeatherData:
            errorAlert(errorTitle: "Error", errorMsg: "Faild To Parse Weather Data")
        case .invalidResponse:
            errorAlert(errorTitle: "Error", errorMsg: "Invalid Response")
        default:
            errorAlert(errorTitle: "Error", errorMsg: "Unknown")
        }
    }
    
    
    static private func errorAlert(errorTitle: String, errorMsg: String){
        
        let alertController =  UIAlertController(title: errorTitle, message: errorMsg, preferredStyle: UIAlertControllerStyle.alert)
        let okAction  = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) in
            
        }
        
        alertController.addAction(okAction)
        
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert;
        alertWindow.makeKeyAndVisible()
        
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)

    }
}
