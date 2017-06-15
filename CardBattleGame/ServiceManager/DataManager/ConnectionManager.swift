//
//  ConnectionManager.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 15/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import Foundation

enum ConnectionManagerError: Error {
    
    case unknown
    case failedRequest
    case invalidResponse
    
}

enum ConnectionType{
    case WEATHER_REPORT
}

class ConnectionManager {
    
    typealias DataCompletion = (Data?, URLResponse?, Error?) -> ()
    
    // MARK: - Properties
    //
    
    
    
    // MARK: - Initialization
    //
    
    
    
    
    // MARK: - Requesting Data
    //
    func fetchDataForGetConnection(_ url : URL, completion: @escaping DataCompletion) {
        
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: sessionConfiguration)
        
         // Create Data Task
        session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, response, error)
            }
            
        }.resume()
    }
    
   
    
}
