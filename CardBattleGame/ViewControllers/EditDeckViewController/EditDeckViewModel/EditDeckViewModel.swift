//
//  EditDeckViewModel.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 14/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit
import CoreData


/// Edit Deck View Model(Follow MVVM pattern): Handle all the business logics for EditDeckViewController
class EditDeckViewModel: NSObject {
  fileprivate var deckCard: [Card] = []
  
  private let coreDataManager = CoreDataStackManager.sharedInstance
  private let cardListDataSource = CardListDataSource.sharedInstance
  
  
  override init() {
    super.init()
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
    return cardListDataSource.numbeOfCards()
  }
  
  
  /// Add User Selected Card to Deck
  ///
  /// - Parameters:
  ///   - name: deck name
  ///   - card: Selected Card
  func add(card: Card, toDeck name: String) {
    do {
      try coreDataManager.add(card: card, toDeck: name)
    } catch ErrorType.deckAlreadyExists {
      CBGErrorHandler.handle(error: ErrorType.deckAlreadyExists)
    } catch ErrorType.faildToCreateDeck {
      CBGErrorHandler.handle(error: ErrorType.faildToCreateDeck)
    } catch {
      CBGErrorHandler.handle(error: ErrorType.failedManagedObjectFetchRequest)
    }
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
        deckCard.forEach { card in
            add(card: card, toDeck: name)
        }
    } catch {
      CBGErrorHandler.handle(error: ErrorType.deckAlreadyExists)
    }
  }
  
  func numberOfAddedCards() -> Int {
    return deckCard.count
  }

  func addCardToDeck(from indexPath: IndexPath) {
    let cardList: [Card] = fetchCards()
    let card = cardList[indexPath.row]
    deckCard.append(card)
  }
  
  func removeCardFromDeckList(at index: Int) {
    guard index < deckCard.count else {
      return
    }
    deckCard.remove(at: index)
  }
  
  func card(at index: Int) -> Card? {
    guard index < deckCard.count else {
      return nil
    }
    return deckCard[index]
  }
  
  func isCardSelected(_ card: Card) -> Bool {
    return deckCard.contains(card)
  }
  
  func numberOfDeck() throws -> Int {
    do {
      let count = try coreDataManager.fetchDeckList().count
      return count
    } catch {
      return 0
    }
  }
}
