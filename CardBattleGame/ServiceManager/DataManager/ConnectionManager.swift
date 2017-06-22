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
  
  typealias DataCompletion = (Data?, URLResponse?, Error?) -> ()
  
  static let sharedInstance: ConnectionManager = {
      let sharedInstance = ConnectionManager()
      return sharedInstance
  }()
  
  /// Perform Get Connection using Session Data Task over ephmereal configuration and return using completation handler
  ///
  /// - Parameters:
  ///   - url: Data Connection Url
  ///   - completion: returns Response Data, URLResponse and Connection Error
  func fetchDataForGetConnection(_ url : URL, completion: @escaping DataCompletion) {
      
    let sessionConfiguration = URLSessionConfiguration.ephemeral
    let session = URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: OperationQueue.main)
      
    // Create Data Task
    session.dataTask(with: url) { (data, response, error) in
      DispatchQueue.main.async {
        completion(data, response, error)
      }
    }.resume()
  }
    
}
