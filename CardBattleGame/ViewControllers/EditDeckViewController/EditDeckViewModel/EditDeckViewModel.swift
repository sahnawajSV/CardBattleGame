//
//  EditDeckViewModel.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 14/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit
import CoreData

extension EditDeckViewModel {
  static let minimumCardLimit = 5
  static let maximumCardLimit = 20
  static let initialPlayerOwnedCard = 30
}

/// Edit Deck View Model(Follow MVVM pattern): Handle all the business logics for EditDeckViewController
class EditDeckViewModel: NSObject {
  var playerOwnedCards: [Card] = []
  fileprivate var deckCards: [Card] = []
  
  private let coreDataManager = CoreDataStackManager.sharedInstance
  private let cardListDataSource = CardListDataSource.sharedInstance
  
  
  override init() {
    super.init()
    addPlayerInitailFreeCardsToStorage()
    playerOwnedCards = fetchPlayerOwnedCards()
  }
  
  /// Fetch Cards from plist
  ///
  /// - Returns: array of card
  func fetchCards() -> [Card] {
    return cardListDataSource.fetchCardList()
  }
  
  
  /// number of cards fetched from plist
  ///
  /// - Returns: card count
  func numberOfCards() -> Int {
    return playerOwnedCards.count
  }
  
  
  /// Add User Selected Card to Deck
  ///
  /// - Parameters:
  ///   - name: deck name
  ///   - card: Selected Card
  func add(card: Card, toDeck name: String) throws {
    try coreDataManager.add(card: card, toDeck: name)
  }
  
  
  /// Create Deck with name
  ///
  /// - Parameters:
  ///   - name: name description
  ///   - id: id of the deck
  /// - Throws: throw error if deck creation failed
  @discardableResult func createDeck(with name: String, id: Int) throws -> DeckList {
    return try coreDataManager.createDeck(with: name, id: id)
  }
  
  /// Create Deck with name and store the cards in the deck
  ///
  /// - Parameter name: deck name
  func saveCardsToDeck(with name: String) {
    do {
      try createDeck(with: name, id: numberOfDeck()+1)
      let filterDeckCards = deckCards.unique{ $0.id }
      try filterDeckCards.forEach { card in
        try add(card: card, toDeck: name)
      }
    } catch ErrorType.deckAlreadyExists {
      CBGErrorHandler.handle(error: ErrorType.deckAlreadyExists)
    } catch ErrorType.faildToCreateDeck {
      CBGErrorHandler.handle(error: ErrorType.faildToCreateDeck)
    } catch {
      CBGErrorHandler.handle(error: ErrorType.failedManagedObjectFetchRequest)
    }
  }
  
  func numberOfAddedCards() -> Int {
    return deckCards.count
  }
  
  func addCardToDeck(from indexPath: IndexPath) {
    var playerCard = playerOwnedCards[indexPath.row]
    deckCards.append(playerCard)
    updateQuantity(deck: playerCard)
    // Decrease the Selected Player Card Quantity by 1 and update the playerOwnedCards object at indexpath
    playerCard.quantity = playerCard.quantity - 1
    playerOwnedCards[indexPath.row] = playerCard
  }
  
  func updateQuantity(deck card: Card) {
    let count = deckCards.filter({$0.id == card.id}).count
    for (index,var deckCard) in deckCards.enumerated() {
      if card.id == deckCard.id {
        deckCard.quantity = Int16(count)
        deckCards[index] = deckCard
      }
    }
  }
  
  func removeCardFromDeckList(at index: Int) {
    let deckCard = deckCards[index]
    for (index,var card) in playerOwnedCards.enumerated() {
      if card.id == deckCard.id {
        card.quantity = card.quantity + 1
        playerOwnedCards[index] = card
      }
    }
    deckCards.remove(at: index)
    updateQuantity(deck: deckCard)
  }
  
  func card(at index: Int) -> Card? {
    guard index < deckCards.count else {
      return nil
    }
    return deckCards[index]
  }
  
  func isCardSelected(_ card: Card) -> Bool {
    return deckCards.contains(card)
  }
  
  func numberOfDeck() -> Int {
    do {
      let count = try coreDataManager.fetchDeckList().count
      return count
    } catch {
      return 0
    }
  }
  
  /// Add initial free cards to storage
  func addPlayerInitailFreeCardsToStorage() {
    do {
      let playerCards = try coreDataManager.fetchPlayerOwnedCard()
      if playerCards.isEmpty {
        let freeCards = randomCards(cardArray: fetchCards(), maximumCard: EditDeckViewModel.initialPlayerOwnedCard)
        freeCards.forEach { card in
          coreDataManager.add(playerOwned: card)
        }
      }
    } catch {
      CBGErrorHandler.handle(error: ErrorType.failedManagedObjectFetchRequest)
    }
  }
  
  /// Fetch Player Owned Cards
  func fetchPlayerOwnedCards() -> [Card]{
    do {
      let playerCards = try coreDataManager.fetchPlayerOwnedCard()
      let playerOwnedCards: [Card] = playerCards.flatMap({ card in
        guard let name = card.name else {
          return nil
        }
        return Card(name: name, id: card.id, attack: card.attack, battlepoint: card.battlepoint, health: card.health, canAttack: card.canAttack, quantity: card.quantity)
      })
      return playerOwnedCards
    } catch {
      CBGErrorHandler.handle(error: ErrorType.failedManagedObjectFetchRequest)
    }
    return []
  }
}
