//
//  DeckListViewModel.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 14/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit
import CoreData

class DeckListViewModel: NSObject {
  
  var deckNameText = ""
  private var cards: [DeckCard] = []
  
  var selectedDeckIndex: IndexPath?
  
  // NSFetchedResultsController to updated uitableview if there is any changes in the Coredata storage
  private let fetchedResultsController: NSFetchedResultsController<DeckList>
  
  private let coreDataManager = CoreDataStackManager.sharedInstance

  override init() {
//    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DeckList")
    let request: NSFetchRequest<DeckList> = DeckList.fetchRequest()
    let departmentSort = NSSortDescriptor(key: "name", ascending: true)
    request.sortDescriptors = [departmentSort]
    let moc = coreDataManager.managedObjectContext
    fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
    
    super.init()
  }
  
  //Perform Fetch
  func performDeckCardFetchRequest() {
    do {
      try fetchedResultsController.performFetch()
    } catch {
      fatalError("Failed to initialize FetchedResultsController: \(error)")
    }
  }
  
  /// Number of cards available in the storage
  ///
  /// - Returns: Total Number of cards
  func numberOfDecks() -> Int {
    guard let sections = fetchedResultsController.sections else {
      fatalError("No sections in fetchedResultsController")
    }
    return sections.first?.numberOfObjects ?? 0
  }
  
  /// Fetch Deck from Managed Object Deck List and create Deck Model Object
  ///
  /// - Parameter indexPath: indexpath of the deck
  /// - Returns: Deck Model Object
  func fetchDeck(at indexPath: IndexPath) -> Deck? {
    let deckList = fetchedResultsController.object(at: indexPath)
    guard let name = deckList.name else {
      return nil
    }
    let deckCards = deckList.cardList
    let deck = Deck(name: name, id: deckList.id, cardList: convertCoreDataDeckCardToCard(deckCards: deckCards))
    return deck
}
  
  
  /// Convert Core Data Stored Card Managed Object to Model Card Object
  ///
  /// - Parameter deckCard: Managed Object Card
  /// - Returns: Card Model Object
  private func convertCoreDataDeckCardToCard(deckCards: [DeckCard]) -> [Card] {
    let cardsInDeck:[Card] = deckCards.flatMap({ card in
      guard let name = card.name else {
        return nil
      }
      return Card(name: name, id: card.id, attack: card.attack, battlepoint: card.battlepoint, health: card.health, canAttack: card.canAttack)
    })
    return cardsInDeck
  }
  
  func numberOfCards() -> Int {
    return cards.count
  }
  
  func selectDeck(at indexPath: IndexPath) {
    let deck = fetchedResultsController.object(at: indexPath)
    selectedDeckIndex = indexPath
    
    if let name = deck.name {
      deckNameText = name
    }
    
    cards = deck.cardList
  }
  
  func fetchCardFromSelectedDeck(at indexPath: IndexPath) -> DeckCard {
    return cards[indexPath.row]
  }
  
  func selectedDeck() -> [DeckCard] {
    return cards
  }
}

extension DeckList {
  var cardList: [DeckCard] {
    return (deckCard?.allObjects as? [DeckCard]) ?? []
  }
}
