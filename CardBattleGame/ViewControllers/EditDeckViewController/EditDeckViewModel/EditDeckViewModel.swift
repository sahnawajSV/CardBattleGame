//
//  EditDeckViewModel.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 14/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit
import CoreData

enum CardAddRemoveType {
  case add
  case delete
}

/// Edit Deck View Model(Follow MVVM pattern): Handle all the business logics for EditDeckViewController
class EditDeckViewModel: NSObject {
  
  
  /// Add or Remove Card from the storage
  ///
  /// - Parameters:
  ///   - card: Card object
  ///   - type: Add or Remove Activity Type
  func addRemove(card: Card, type: CardAddRemoveType) {
    let fetchRequest = NSFetchRequest<Cards>()
    fetchRequest.predicate = NSPredicate(format: "id == %d", card.id)
    
    // Create Entity Description
    let entityDescription = NSEntityDescription.entity(forEntityName: "Cards", in: CoreDataStackManager.sharedInstance.managedObjContext())
    
    // Configure Fetch Request
    fetchRequest.entity = entityDescription
    
    do {
      let managedObjectContext = CoreDataStackManager.sharedInstance.managedObjContext()
      
      let result = try managedObjectContext.fetch(fetchRequest)
      
      switch  type{
      case .add: // Add Card If not available
        if result.count == 0{
          let newItem: Cards = NSEntityDescription.insertNewObject(forEntityName: "Cards", into: managedObjectContext) as! Cards
          newItem.attack = card.attack
          newItem.battlepoint = card.battlepoint
          newItem.health = card.health
          newItem.id = card.id
          newItem.name = card.name
        }
      case .delete: // Remove Card
        let resultData = result
        for object in resultData {
          managedObjectContext.delete(object)
        }
      }
      CoreDataStackManager.sharedInstance.saveContext()
      
    } catch {
      CBGErrorHandler.handle(error: .failedManagedObjectFetchRequest)
    }
  }
    
  /// Check if the card is available in the Persistance Storage
  ///
  /// - Parameter card: Card
  /// - Returns: True if card is available
  func checkCardState(card: Card) -> Bool {
    let fetchRequest = NSFetchRequest<Cards>()
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
      CBGErrorHandler.handle(error: .failedManagedObjectFetchRequest)
      return false
    }
  }
  
  func fetchCardFromPlist() -> [Card] {
    return CardListDataSource.sharedInstance.fetchCardList()
  }
  
  func numberOfCardInPlist() -> Int {
    return CardListDataSource.sharedInstance.numbeOfCards()
  }
}
