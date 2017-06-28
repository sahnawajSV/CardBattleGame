//
//  WeatherData.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 28/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class WeatherData {
  let timeZone: String
  let time: Date
  let windSpeed: Double
  let temperature: Double
  let apparentTemperature: Double
  let summary: String
  let icon: String
 
  init?(dictionary: [String: Any]) throws {
    guard let timeZone = dictionary["timeZone"] as? String,
      let time = dictionary["time"] as? Date,
      let windSpeed = dictionary["windSpeed"]  as? Double,
      let temperature = dictionary["temperature"] as? Double,
      let apparentTemperature = dictionary["apparentTemperature"] as? Double,
      let summary = dictionary["summary"]  as? String,
      let icon = dictionary["icon"]  as? String else {
        throw ErrorType.failedToIntializeWeatherData
    }
    
    self.timeZone = timeZone
    self.time = time
    self.windSpeed = windSpeed
    self.temperature = temperature
    self.apparentTemperature = apparentTemperature
    self.summary = summary
    self.icon = icon
    
  }
}
