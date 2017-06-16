//
//  ServiceManager.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 15/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit
import CoreData


class ServiceManager: NSObject {
    
    typealias DataCompletion = (Data?, URLResponse?, Error?) -> ()
    
    // Connection Manager Lazy Initializer
    lazy var  connectionManager: ConnectionManager = {
        let connectionManager = ConnectionManager()
        return connectionManager
    }()
    
    // Core Data Stack Lazy Initializer
    lazy var cdstore: CoreDataStackManager = {
        let cdstore = CoreDataStackManager()
        return cdstore
    }()

    
    static let sharedInstance: ServiceManager = {
        let instance = ServiceManager()
        // setup code
        return instance
    }()
    
    override init(){
        super.init()
    }
    
    
    // MARK : Fetch Data From Connection
    //
    func fetchDataForGetConnection(_ url : URL, completion: @escaping DataCompletion) {
        connectionManager.fetchDataForGetConnection(url) { (data, response, error) in
            completion(data,response,error)
        }
    }
    
    
    // MARK :  Start and Stop Location Update
    //
    func startLocationUpdate() {
        LocationManager.sharedInstance.startLocationUpdate()
    }
    
    func stopLocationUpdate()  {
        LocationManager.sharedInstance.stopLocationUpdate()
    }
    
    
    // MARK - Core Data Managed Object Context
    //
    func managedObjContext() -> NSManagedObjectContext {
        return cdstore.persistentContainer.viewContext
    }
    
}
