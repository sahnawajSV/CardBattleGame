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
  
  var managedObjectContext: NSManagedObjectContext {
    get {
      return persistentContainer.viewContext
    }
  }
  
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
  
  
  
  /// Fetch Deck List for name
  ///
  /// - Parameter name: deck name
  /// - Returns:
  func fetchDeckResult(for name: String) throws -> [DeckList] {
    let fetchRequest: NSFetchRequest = DeckList.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "name == %@", name)
    
    // Create Entity Description
    let entityDescription = NSEntityDescription.entity(forEntityName: "DeckList", in: managedObjectContext)
    
    // Configure Fetch Request
    fetchRequest.entity = entityDescription
    do {
      return try managedObjectContext.fetch(fetchRequest)
    } catch {
       throw ErrorType.failedManagedObjectFetchRequest
    }
  }
  
  
  /// Add Card to Deck
  ///
  /// - Parameters:
  ///   - name: deck name
  ///   - card: card managed object
  
  func add(card: Card, toDeck name: String) throws {
    guard let newItem: DeckCard = NSEntityDescription.insertNewObject(forEntityName: "DeckCard", into: managedObjectContext) as? DeckCard else {
      throw ErrorType.faildToCreateDeck
    }
    newItem.attack = card.attack
    newItem.battlepoint = card.battlepoint
    newItem.health = card.health
    newItem.id = card.id
    newItem.name = card.name
    newItem.canAttack = card.canAttack
    do {
      let deckItem = try fetchDeck(with: name)
      deckItem.addToDeckCard(newItem)
      saveContext()
    } catch {
      throw ErrorType.failedManagedObjectFetchRequest
    }
  }
  
  
  
  /// Fetch Deck Object with name
  ///
  /// - Parameter name: name of the deck
  /// - Returns: deck managed object
  private func fetchDeck(with name: String) throws -> DeckList {
    do {
      let result = try fetchDeckResult(for: name)
      guard let deck = result.first else {
        throw ErrorType.failedManagedObjectFetchRequest
      }
      return deck
    } catch {
      throw ErrorType.failedManagedObjectFetchRequest
    }
  }
  
  
  /// Create Deck with name and Id
  ///
  /// - Parameters:
  ///   - name: deck name
  ///   - id: deck id
  /// - Throws: error if deck creation failed
  func createDeck(with name: String, id: Int) throws -> DeckList {//return created deck
    do {
      let result = try fetchDeckResult(for: name)
      if result.isEmpty, let newItem: DeckList = NSEntityDescription.insertNewObject(forEntityName: "DeckList", into: managedObjectContext) as? DeckList {
        newItem.name = name
        newItem.id = Int16(id)
        saveContext()
        return newItem
      } else {
        throw ErrorType.deckAlreadyExists
      }
    } catch {
      throw ErrorType.failedManagedObjectFetchRequest
    }
  }
  
  
  /// Fetch Deck list from the storage
  ///
  /// - Returns: deck lest array
  func fetchDeckList() throws -> [DeckList] {
    let fetchRequest: NSFetchRequest = DeckList.fetchRequest()
    // Create Entity Description
    let entityDescription = NSEntityDescription.entity(forEntityName: "DeckList", in: managedObjectContext)
    
    // Configure Fetch Request
    fetchRequest.entity = entityDescription
    do {
      return try managedObjectContext.fetch(fetchRequest)
    } catch {
      throw ErrorType.failedManagedObjectFetchRequest
    }
  }
}
