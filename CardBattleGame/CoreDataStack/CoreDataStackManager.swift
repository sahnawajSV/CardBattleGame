//
//  CoreDataStackManager.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 16/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStackManager: NSObject {
  
  static let sharedInstance: CoreDataStackManager = {
    let cdstore = CoreDataStackManager()
    return cdstore
  }()
  
  lazy var persistentContainer: NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: "CardBattleGame")
    
    // fatalError() causes the application to generate a crash log and terminate.
    //
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      guard let error = error as NSError? else {return}
      fatalError("Unresolved error \(error), \(error.userInfo)")
    })
    
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    container.viewContext.undoManager = nil // We don't need undo so set it to nil.
    container.viewContext.shouldDeleteInaccessibleFaults = true
    
    // Merge the changes from other contexts automatically.
    //
    container.viewContext.automaticallyMergesChangesFromParent = true
    
    return container
  }()
  
  
  /// Save Data
  func saveContext() {
    var error: NSError? = nil
    if persistentContainer.viewContext.hasChanges {
      do {
        try persistentContainer.viewContext.save()
      } catch let error1 as NSError {
        error = error1
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog("Unresolved error \(String(describing: error)), \(error!.userInfo)")
        abort()
      }
    }
  }
  
  // MARK - Core Data Managed Object Context
  //
  func managedObjContext() -> NSManagedObjectContext {
    return persistentContainer.viewContext
  }
}
