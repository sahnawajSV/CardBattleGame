//
//  Configuration.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 15/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

import Foundation

struct Defaults {
    
    static let Latitude: Double = 51.400592
    static let Longitude: Double = 4.760970
    static let DISTANCE_FILTER = 5000.0
}

struct API {
    
    static let APIKey = "9035e8294254f66c2a5e636c76907571"
    static let BaseURL = URL(string: "https://api.darksky.net/forecast/")!
    
    static var AuthenticatedBaseURL: URL {
        return BaseURL.appendingPathComponent(APIKey)
    }
    
}
