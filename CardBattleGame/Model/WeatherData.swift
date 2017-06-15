//
//  WeatherData.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 15/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import Foundation

class WeatherData: NSObject {
    
    var time: Date?
    var timeZone : String?
    var windSpeed: Double?
    var minTemprature: Double?
    var maxTemprature : Double?
    var summary: String?
    var icon: String?
    
    func updateWeatherData(time :  Date, timeZone : String, windSpeed: Double, minTemprature: Double, summary: String, icon: String, maxTemprature : Double){
        self.summary = summary
        self.time = time
        self.minTemprature = minTemprature
        self.timeZone = timeZone
        self.windSpeed = windSpeed
        self.icon = icon
        self.maxTemprature = maxTemprature
    }
    
}
