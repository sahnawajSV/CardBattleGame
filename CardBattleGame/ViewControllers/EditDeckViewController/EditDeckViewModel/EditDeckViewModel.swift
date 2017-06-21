//
//  EditDeckViewModel.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 14/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit
import CoreData

class EditDeckViewModel: NSObject {
  
  
  /// Add Card to Persistance Storage
  ///
  /// - Parameter card: Card
  func add(card: Card) {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
    fetchRequest.predicate = NSPredicate(format: "id == %d", card.id)
    
    // Create Entity Description
    let entityDescription = NSEntityDescription.entity(forEntityName: "Cards", in: CoreDataStackManager.sharedInstance.managedObjContext())
    
    // Configure Fetch Request
    fetchRequest.entity = entityDescription
    
    do {
      let managedObjectContext = CoreDataStackManager.sharedInstance.managedObjContext()
      
      let result = try managedObjectContext.fetch(fetchRequest)
      if result.count == 0{
        let newItem: Cards = NSEntityDescription.insertNewObject(forEntityName: "Cards", into: managedObjectContext) as! Cards
        newItem.attack = card.attack
        newItem.battlepoint = card.battlepoint
        newItem.health = card.health
        newItem.id = card.id
        newItem.name = card.name
      }
      
      CoreDataStackManager.sharedInstance.saveContext()
      
    } catch {
      let fetchError = error as NSError
      print(fetchError)
    }
  }
  
  
  /// Delete Card to Persistance Storage
  ///
  /// - Parameter card: Card
  func delete(card: Card) {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
    fetchRequest.predicate = NSPredicate(format: "id == %d", card.id)
    
    // Create Entity Description
    let entityDescription = NSEntityDescription.entity(forEntityName: "Cards", in: CoreDataStackManager.sharedInstance.managedObjContext())
    
    // Configure Fetch Request
    fetchRequest.entity = entityDescription
    
    do {
      let managedObjectContext = CoreDataStackManager.sharedInstance.managedObjContext()
      
      let result = try managedObjectContext.fetch(fetchRequest)
      let resultData = result as! [Cards]
      for object in resultData {
        managedObjectContext.delete(object)
      }
      
      CoreDataStackManager.sharedInstance.saveContext()
      
    } catch {
      let fetchError = error as NSError
      print(fetchError)
    }
  }
  
  
  /// Check if the card is available in the Persistance Storage
  ///
  /// - Parameter card: Card
  /// - Returns: True is exist
  func checkCardState(card: Card) -> Bool {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
    fetchRequest.predicate = NSPredicate(format: "id == %d", card.id)
    
    // Create Entity Description
    let entityDescription = NSEntityDescription.entity(forEntityName: "Cards", in: CoreDataStackManager.sharedInstance.managedObjContext())
    
    // Configure Fetch Request
    fetchRequest.entity = entityDescription
    
    do {
      let managedObjectContext = CoreDataStackManager.sharedInstance.managedObjContext()
      
      let result = try managedObjectContext.fetch(fetchRequest)
      
      return result.count > 0
      
    } catch {
      let fetchError = error as NSError
      print(fetchError)
      
      return false
    }
  }
  
}
