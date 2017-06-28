//
//  WeatherDataParser.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 28/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

/// WeatherDataParser : Responsible for decode the weather response and return WeatherData object
class WeatherDataParser {
  
  
  /// Decode Weather Response and return Weather Data Object
  ///
  /// - Parameter data: Weather Response
  /// - Returns: WeatherData Object
  /// - Throws: faildParseWeatherData if JSON data is not valid
  static func decode(data: Data) throws -> WeatherData {
    let decoder = WeatherDataParser()
    
    guard let JSONData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
      throw ErrorType.invalidResponse
    }
    let jsonDictionary: [String: Any] = decoder.decodeJSON(JSONData)
    return try WeatherData(dictionary: jsonDictionary)
  }
  
  
  /// Parse Weather Data
  ///
  /// - Parameter jsonDictionary: Serialized JSON Dictionary
  /// - Returns: parsed dictionary
  private func decodeJSON(_ jsonDictionary: [String: Any]) -> [String: Any] {
    var parsedData = [String: Any]()
    
    if let timeZone = jsonDictionary["timezone"] as? String {
      parsedData["timeZone"] = timeZone
    }
    if let currently: [String: Any] = jsonDictionary["currently"] as? [String : Any] {
      
      if let time = currently["time"] as? Double{
        let dtTime = Date(timeIntervalSince1970: time / 1000.0)
        parsedData["time"] = dtTime
      }
      
      if let windSpeed = currently["windSpeed"] as? Double {
        parsedData["windSpeed"] = windSpeed
      }
      
      if let temperature = currently["temperature"] as? Double {
        parsedData["temperature"] = temperature
      }
      
      if let apparentTemperature = currently["apparentTemperature"] as? Double {
        parsedData["apparentTemperature"] = apparentTemperature
      }
      
      if let summary = currently["summary"] as? String {
        parsedData["summary"] = summary
      }
      
      if let icon = currently["icon"] as? String {
        parsedData["icon"] = icon
      }
      
    }
    
    return parsedData
  }
  
}
