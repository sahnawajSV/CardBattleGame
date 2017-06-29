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

protocol EditDeckViewModelDelegate: class {
  func deckCardEntityWillChangeContent()
  func deckCardEntity(didChangeObjectAt indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
  func deckCardEntityDidChangeContent()
}

/// Edit Deck View Model(Follow MVVM pattern): Handle all the business logics for EditDeckViewController
class EditDeckViewModel: NSObject {
  
  private let coreDataManager = CoreDataStackManager.sharedInstance
  private let cardListDataSource = CardListDataSource.sharedInstance
  
  weak var delegate : EditDeckViewModelDelegate?
  
  // NSFetchedResultsController to updated uitableview if there is any changes in the Coredata storage
  var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
  
  override init() {
    super.init()
    initializeFetchedResultsController()
  }
  
  //Creating a Fetched Results Controller
  private func initializeFetchedResultsController() {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DeckCard")
    let departmentSort = NSSortDescriptor(key: "id", ascending: true)
    request.sortDescriptors = [departmentSort]
    let moc = coreDataManager.managedObjContext()
    fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self
    
    do {
      
      try fetchedResultsController.performFetch()
      
    } catch {
      
      fatalError("Failed to initialize FetchedResultsController: \(error)")
    }
  }
  
  /// Fetch Object at indexpath from Core Data Storage
  ///
  /// - Parameter indexPath: Index path of the object
  /// - Returns: object from core data
  func fetchObject(at indexPath: IndexPath) -> Any{
    return fetchedResultsController.object(at: IndexPath(row: indexPath.row, section: 0))
  }
  
  /// Number of cards available in the storage
  ///
  /// - Returns: Total Number of cards
  func numberOfCardAdded() -> Int {
    guard let sections = fetchedResultsController.sections else {
      fatalError("No sections in fetchedResultsController")
    }
    let sectionInfo = sections[0]
    return sectionInfo.numberOfObjects
  }
  
  /// Add or Remove Card from the storage
  ///
  /// - Parameters:
  ///   - card: Card object
  ///   - type: Add or Remove Activity Type
  func addRemove(card: Card, type: CardAddRemoveType) {
    let fetchRequest = NSFetchRequest<DeckCard>()
    fetchRequest.predicate = NSPredicate(format: "id == %d", card.id)
    
    // Create Entity Description
    let entityDescription = NSEntityDescription.entity(forEntityName: "DeckCard", in: coreDataManager.managedObjContext())
    
    // Configure Fetch Request
    fetchRequest.entity = entityDescription
    
    do {
      let managedObjectContext = coreDataManager.managedObjContext()
      
      let result = try managedObjectContext.fetch(fetchRequest)
      
      switch  type{
      case .add: // Add Card If not available
        if result.count == 0{
          if let newItem: DeckCard = NSEntityDescription.insertNewObject(forEntityName: "DeckCard", into: managedObjectContext) as? DeckCard{
            newItem.attack = card.attack
            newItem.battlepoint = card.battlepoint
            newItem.health = card.health
            newItem.id = card.id
            newItem.name = card.name
          }
        }
      case .delete: // Remove Card
        let resultData = result
        for object in resultData {
          managedObjectContext.delete(object)
        }
      }
      coreDataManager.saveContext()
      
    } catch {
      CBGErrorHandler.handle(error: .failedManagedObjectFetchRequest)
    }
  }
  
  /// Check if the card is available in the Persistance Storage
  ///
  /// - Parameter card: Card
  /// - Returns: True if card is available
  func checkCardState(card: Card) -> Bool {
    let fetchRequest = NSFetchRequest<DeckCard>()
    fetchRequest.predicate = NSPredicate(format: "id == %d", card.id)
    
    // Create Entity Description
    let entityDescription = NSEntityDescription.entity(forEntityName: "DeckCard", in: coreDataManager.managedObjContext())
    
    // Configure Fetch Request
    fetchRequest.entity = entityDescription
    
    do {
      let managedObjectContext = coreDataManager.managedObjContext()
      
      let result = try managedObjectContext.fetch(fetchRequest)
      
      return result.count > 0
      
    } catch {
      CBGErrorHandler.handle(error: .failedManagedObjectFetchRequest)
      return false
    }
  }
  
  func fetchCardFromPlist() -> [Card] {
    return cardListDataSource.fetchCardList()
  }
  
  func numberOfCardInPlist() -> Int {
    return cardListDataSource.numbeOfCards()
  }
  
}


// MARK: - NSFetchedResultsControllerDelegate
extension EditDeckViewModel: NSFetchedResultsControllerDelegate {
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    self.delegate?.deckCardEntityWillChangeContent()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    self.delegate?.deckCardEntity(didChangeObjectAt: indexPath, for: type, newIndexPath: newIndexPath)
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    self.delegate?.deckCardEntityDidChangeContent()
  }
  
}
