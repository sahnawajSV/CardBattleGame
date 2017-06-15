//
//  ServiceManager.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 15/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class ServiceManager: NSObject {
    
    typealias DataCompletion = (Data?, URLResponse?, Error?) -> ()
    
    let conMan = ConnectionManager()
    
    static let sharedInstance = ServiceManager()

    
    func fetchDataForGetConnection(_ url : URL, completion: @escaping DataCompletion) {
        conMan.fetchDataForGetConnection(url) { (data, response, error) in
            completion(data,response,error)
        }
    }
    
}
