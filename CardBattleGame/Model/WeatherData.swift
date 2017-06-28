//
//  WeatherData.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 28/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class WeatherData {
  var timeZone: String
  var time: String
  var windSpeed: String
  var temperature: String
  var summary: String
  var icon: String
 
  init?(dictionary: [String: Any]) {
    guard let timeZone = dictionary["timeZone"] as? String,
      let time = dictionary["time"] as? String,
      let windSpeed = dictionary["windSpeed"]  as? String,
      let temperature = dictionary["temperature"] as? String,
      let summary = dictionary["summary"]  as? String,
      let icon = dictionary["icon"]  as? String else {
        return nil
    }
    
    self.timeZone = timeZone
    self.time = time
    self.windSpeed = windSpeed
    self.temperature = temperature
    self.summary = summary
    self.icon = icon
    
  }
}
