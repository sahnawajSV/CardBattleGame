//
//  EditDeckViewModel.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 14/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit
import CoreData

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
  private let fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
  
  override init() {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DeckCard")
    let departmentSort = NSSortDescriptor(key: "id", ascending: true)
    request.sortDescriptors = [departmentSort]
    let moc = coreDataManager.managedObjectContext
    fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
    
    super.init()
    fetchedResultsController.delegate = self
  }
  
  //Perform Fetch
  func performDeckCardFetchRequest() {
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
  func fetchDeckCard(at indexPath: IndexPath) -> DeckCard?{
    if let deckCard: DeckCard = fetchedResultsController.object(at: IndexPath(row: indexPath.row, section: 0)) as? DeckCard {
      return deckCard
    }
    return nil
  }
  
  /// Number of cards available in the storage
  ///
  /// - Returns: Total Number of cards
  func numberOfCardAdded() -> Int {
    guard let sections = fetchedResultsController.sections else {
      fatalError("No sections in fetchedResultsController")
    }
    return sections.first?.numberOfObjects ?? 0
  }
  
  /// Add or Remove Card from the storage
  ///
  /// - Parameters:Card object
  func addCardToDeckCardEntity(_ card: Card) {
    do {
      try coreDataManager.add(card: card)
    } catch {
      CBGErrorHandler.handle(error: .failedManagedObjectFetchRequest)
    }
  }
  
  
  /// Delete Card from the storage
  ///
  /// - Parameter card: Card object
  func deleteCardFromDeckCardEntity(_ card: Card) {
    do {
      try coreDataManager.delete(card: card)
    } catch {
      CBGErrorHandler.handle(error: .failedManagedObjectFetchRequest)
    }
  }
  
  /// Check if the card is available in the Deck Card Entity
  ///
  /// - Parameter card: Card
  /// - Returns: True if card is available
  func isCardAvailableInDeckCardStorage (_ card: Card) -> Bool {
    do {
        return try coreDataManager.isCardAvailableInDeckCardStorage(card)
    } catch {
      CBGErrorHandler.handle(error: .failedManagedObjectFetchRequest)
      return false
    }
  }
  
  
  /// Fetch Cards from plist
  ///
  /// - Returns: array of card
  func fetchCardFromPlist() -> [Card] {
    return cardListDataSource.fetchCardList()
  }
  
  
  /// number of cards fetched from plist
  ///
  /// - Returns: card count
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
