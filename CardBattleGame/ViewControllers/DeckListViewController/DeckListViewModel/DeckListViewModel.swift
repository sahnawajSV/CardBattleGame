//
//  DeckListViewModel.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 14/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit
import CoreData

protocol DeckListViewModelDelegate: class {
  func reloadSelectedDeckTableView(with cards: [DeckCard])
}

class DeckListViewModel: NSObject {
  
  var deckNameText = ""
  private var cards: [DeckCard] = []
  
  weak var delegate: DeckListViewModelDelegate?
  
  var selectedDeckIndex: IndexPath?
  
  // NSFetchedResultsController to updated uitableview if there is any changes in the Coredata storage
  private let fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
  
  private let coreDataManager = CoreDataStackManager.sharedInstance

  override init() {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DeckList")
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
  
  
  /// Fetch the deck list from core data storage
  ///
  /// - Returns: Deck List
  func fetchDeckList() -> [DeckList]?{
    guard let decks = coreDataManager.fetchDeckList() else {
      return nil
    }
    return decks
  }
  
  
  /// Fetch Deck from Managed Object Deck List and create Deck Model Object
  ///
  /// - Parameter indexPath: indexpath of the deck
  /// - Returns: Deck Model Object
  func fetchDeck(at indexPath: IndexPath) -> Deck?{
    guard let deckList: DeckList = fetchedResultsController.object(at: IndexPath(row: indexPath.row, section: 0)) as? DeckList else {
      return nil
    }
    guard let name = deckList.name, let deckCards: [DeckCard] = deckList.deckCard?.allObjects as? [DeckCard] else {
      return nil
    }
    let deck = Deck(name: name, id: deckList.id, cardList: convertCoreDataDeckCardToCard(deckCard: deckCards))
    return deck
}
  
  
  /// Convert Core Data Stored Card Managed Object to Model Card Object
  ///
  /// - Parameter deckCard: Managed Object Card
  /// - Returns: Card Model Object
  private func convertCoreDataDeckCardToCard(deckCard: [DeckCard]) -> [Card] {
    var cardsInDeck:[Card] = []
    deckCard.forEach { card in
      var cardDict  = [String: Any]()
      cardDict["name"] = card.name
      cardDict["id"] = card.id
      cardDict["attack"] = card.attack
      cardDict["battlepoint"] = card.battlepoint
      cardDict["health"] = card.health
      cardDict["canAttack"] = card.canAttack
      if let card = Card(dictionary: cardDict) {
        cardsInDeck.append(card)
      }
    }
    return cardsInDeck
  }
  
  func numberOfCards() -> Int {
    return cards.count
  }
  
  func selectedDeck(at indexPath: IndexPath) {
    guard let deck: DeckList = fetchedResultsController.object(at: IndexPath(row: indexPath.row, section: 0)) as? DeckList else {
      return
    }
    selectedDeckIndex = indexPath
    
    if let name = deck.name {
      deckNameText = name
    }
    
    if let cardList = deck.deckCard?.allObjects as? [DeckCard] {
      cards = cardList
    }
  }
  
  func fetchCardFromSelectedDeck(at indexPath: IndexPath) -> DeckCard {
    return cards[indexPath.row]
  }
  
  func getSelectedDeck() -> [DeckCard] {
    return cards
  }
}
