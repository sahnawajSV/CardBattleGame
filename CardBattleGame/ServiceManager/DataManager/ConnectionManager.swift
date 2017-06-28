//
//  ConnectionManager.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 15/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import Foundation

struct API {
  
  static let apiKey = "9035e8294254f66c2a5e636c76907571"
  static let baseURL = URL(string: "https://api.darksky.net/forecast/")!
  
  static var authenticatedBaseURL: URL {
    return baseURL.appendingPathComponent(apiKey)
  }
  
}

/// Connection Manager is Responsible for creating connection between server anad client, return the response data with NSURLResponse and Error
class ConnectionManager {
  
  typealias WeatherDataCompletion = (WeatherData?, ErrorType?) -> ()
  
  static let sharedInstance = ConnectionManager()
  
  /// Perform Get Connection using Session Data Task over ephmereal configuration and return WeatherData Object or Error Type
  ///
  /// - Parameters:
  ///   - url: Weather Data Url
  ///   - completion: returns WeatherData Object or Error Type
  func fetchWeatherReport(_ url : URL, completion: @escaping WeatherDataCompletion) {
    
    let sessionConfiguration = URLSessionConfiguration.ephemeral
    let session = URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: OperationQueue.main)
    
    // Create Data Task
    session.dataTask(with: url) { (data, response, error) in
      if error != nil {
        completion(nil, ErrorType.failedRequest)
      } else if let data = data, let response = response as? HTTPURLResponse {
        if response.statusCode == 200 {
          do {
            // Decode JSON
            let weatherData: WeatherData = try WeatherDataParser.decode(data: data)
            completion(weatherData, nil)
            
          } catch ErrorType.failedToIntializeWeatherData {
            completion(nil, ErrorType.failedToIntializeWeatherData)
          } catch {
            completion(nil, ErrorType.invalidResponse)
          }
          
        } else {
          completion(nil, ErrorType.failedRequest)
        }
        
      } else {
        completion(nil, ErrorType.unknown)
      }
    }.resume()
  }
  
}
