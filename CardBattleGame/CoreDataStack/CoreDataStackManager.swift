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
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      guard let error = error as NSError? else {return}
      fatalError("Unresolved error \(error), \(error.userInfo)")
    })
    
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    container.viewContext.undoManager = nil // We don't need undo so set it to nil.
    container.viewContext.shouldDeleteInaccessibleFaults = true
    
    // Merge the changes from other contexts automatically.
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
        // abort() causes the application to generate a crash log and terminate.
        NSLog("Unresolved error \(String(describing: error)), \(error!.userInfo)")
        abort()
      }
    }
  }
  
  /// Core Data Managed Object Context
  ///
  /// - Returns: managed object context
  func managedObjContext() -> NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  
  /// Add Card to coredata DeckCard Entity
  ///
  /// - Parameter card: Card object
  func add(card: Card) throws {
    let fetchRequest = NSFetchRequest<DeckCard>()
    fetchRequest.predicate = NSPredicate(format: "id == %d", card.id)
    
    // Create Entity Description
    let entityDescription = NSEntityDescription.entity(forEntityName: "DeckCard", in: managedObjContext())
    
    // Configure Fetch Request
    fetchRequest.entity = entityDescription
    
    do {
      let managedObjectContext = managedObjContext()
      
      let result = try managedObjectContext.fetch(fetchRequest)
      
      if result.count == 0, let newItem: DeckCard = NSEntityDescription.insertNewObject(forEntityName: "DeckCard", into: managedObjectContext) as? DeckCard{
        newItem.attack = card.attack
        newItem.battlepoint = card.battlepoint
        newItem.health = card.health
        newItem.id = card.id
        newItem.name = card.name
      }
      saveContext()
    } catch {
      throw ErrorType.failedManagedObjectFetchRequest
    }
  }
 
  /// Delete Card from the core data DeckCard Entity
  ///
  /// - Parameter card: Card object
  func delete(card: Card) throws {
    let fetchRequest = NSFetchRequest<DeckCard>()
    fetchRequest.predicate = NSPredicate(format: "id == %d", card.id)
    
    // Create Entity Description
    let entityDescription = NSEntityDescription.entity(forEntityName: "DeckCard", in: managedObjContext())
    
    // Configure Fetch Request
    fetchRequest.entity = entityDescription
    
    do {
      let managedObjectContext = managedObjContext()
      
      let result = try managedObjectContext.fetch(fetchRequest)
      
      let resultData = result
      for object in resultData {
        managedObjectContext.delete(object)
      }
      saveContext()
      
    } catch {
      throw ErrorType.failedManagedObjectFetchRequest
    }
  }
  

  /// Check if the card is available in the Persistance Storage
  ///
  /// - Parameter card: Card
  /// - Returns: True if card is available
  func isCardAvailableInDeckCardStorage(_ card: Card) throws -> Bool {
    let fetchRequest = NSFetchRequest<DeckCard>()
    fetchRequest.predicate = NSPredicate(format: "id == %d", card.id)
    
    // Create Entity Description
    let entityDescription = NSEntityDescription.entity(forEntityName: "DeckCard", in: managedObjContext())
    
    // Configure Fetch Request
    fetchRequest.entity = entityDescription
    
    do {
      let managedObjectContext = managedObjContext()
      
      let result = try managedObjectContext.fetch(fetchRequest)
      
      return result.count > 0
      
    } catch {
      throw ErrorType.failedManagedObjectFetchRequest
    }
  }
}
