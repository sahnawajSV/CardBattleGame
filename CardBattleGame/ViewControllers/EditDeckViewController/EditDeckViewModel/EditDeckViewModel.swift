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
  
  func add(card: Card) {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
    fetchRequest.predicate = NSPredicate(format: "id == %d", card.id)
    
    // Create Entity Description
    let entityDescription = NSEntityDescription.entity(forEntityName: "Cards", in: CoreDataStackManager.sharedInstance.managedObjContext())
    
    // Configure Fetch Request
    fetchRequest.entity = entityDescription
    
    do {
      let result = try CoreDataStackManager.sharedInstance.managedObjContext().fetch(fetchRequest)
      if result.count == 0{
        let newItem: Cards = NSEntityDescription.insertNewObject(forEntityName: "Cards", into: CoreDataStackManager.sharedInstance.managedObjContext()) as! Cards
        newItem.attack = card.attack
        newItem.battlepoint = card.battlepoint
        newItem.health = card.health
        newItem.id = card.id
        newItem.name = card.name
      }
      saveContext(CoreDataStackManager.sharedInstance.managedObjContext())
    } catch {
      let fetchError = error as NSError
      print(fetchError)
    }
  } 
  
  
  
  func saveContext(_ context: NSManagedObjectContext) {
    var error: NSError? = nil
    //        if context.hasChanges {
    do {
      try context.save()
    } catch let error1 as NSError {
      error = error1
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog("Unresolved error \(String(describing: error)), \(error!.userInfo)")
      abort()
    }
    //        }
  }
  
}
