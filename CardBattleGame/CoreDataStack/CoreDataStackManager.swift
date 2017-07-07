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
  func fetchDeckResult(for name: String) throws -> [DeckList]? {
    let fetchRequest = NSFetchRequest<DeckList>()
    fetchRequest.predicate = NSPredicate(format: "name == %@", name)
    
    // Create Entity Description
    let entityDescription = NSEntityDescription.entity(forEntityName: "DeckList", in: managedObjectContext)
    
    // Configure Fetch Request
    fetchRequest.entity = entityDescription
    do {
      let result = try managedObjectContext.fetch(fetchRequest)
      return result
    } catch {
       throw ErrorType.failedManagedObjectFetchRequest
    }
  }
  
  
  /// Fetch Card Objects from deck with name
  ///
  /// - Parameter name: deck name
  /// - Returns: card objects
  func fetchFromDeck(with name: String) throws -> [DeckCard]? {
    guard let deckItem = try fetchDeck(with: name) else {
      return nil
    }
    let deckCard = deckItem.mutableSetValue(forKey: "deckCard")
    return Array(deckCard) as? [DeckCard]
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
    guard let deckItem = try fetchDeck(with: name) else {
      throw ErrorType.failedManagedObjectFetchRequest
    }
    deckItem.addToDeckCard(newItem)
    saveContext()
  }
  
  
  
  /// Fetch Deck Object with name
  ///
  /// - Parameter name: name of the deck
  /// - Returns: deck managed object
  private func fetchDeck(with name: String) throws -> DeckList? {
    guard let result = try fetchDeckResult(for: name), let deck = result.first else {
      throw ErrorType.failedManagedObjectFetchRequest
    }
    return deck
  }
  
  
  /// Create Deck with name and Id
  ///
  /// - Parameters:
  ///   - name: deck name
  ///   - id: deck id
  /// - Throws: error if deck creation failed
  func createDeck(with name: String, id: Int) throws {
    guard let result = try fetchDeckResult(for: name) else {
      throw ErrorType.failedManagedObjectFetchRequest
    }
    if result.isEmpty, let newItem: DeckList = NSEntityDescription.insertNewObject(forEntityName: "DeckList", into: managedObjectContext) as? DeckList {
      newItem.name = name
      saveContext()
    } else {
      throw ErrorType.deckAlreadyExists
    }
  }
  
  
  /// Fetch Deck list from the storage
  ///
  /// - Returns: deck lest array
  func fetchDeckList() throws -> [DeckList]? {
    let fetchRequest = NSFetchRequest<DeckList>()
    // Create Entity Description
    let entityDescription = NSEntityDescription.entity(forEntityName: "DeckList", in: managedObjectContext)
    
    // Configure Fetch Request
    fetchRequest.entity = entityDescription
    do {
      let result = try managedObjectContext.fetch(fetchRequest)
      return result
    } catch {
      throw ErrorType.failedManagedObjectFetchRequest
    }
  }
}
