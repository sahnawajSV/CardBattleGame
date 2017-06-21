  //
  //  ConnectionManager.swift
  //  CardBattleGame
  //
  //  Created by SAHNAWAJ BISWAS on 15/06/17.
  //  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
  //
  
  import Foundation
  
  enum ConnectionType{
    case WEATHER_REPORT
  }
  
  struct API {
    
    static let APIKey = "9035e8294254f66c2a5e636c76907571"
    static let BaseURL = URL(string: "https://api.darksky.net/forecast/")!
    
    static var AuthenticatedBaseURL: URL {
      return BaseURL.appendingPathComponent(APIKey)
    }
    
  }
  
  
  class ConnectionManager {
    
    typealias DataCompletion = (Data?, URLResponse?, Error?) -> ()
    
    
    static let sharedInstance: ConnectionManager = {
      let sharedInstance = ConnectionManager()
      return sharedInstance
    }()
    
    
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
