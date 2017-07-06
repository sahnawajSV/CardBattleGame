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
  fileprivate var deckCards: [Card] = []
  
  var selectedDeckName: String = ""
  
  private let coreDataManager = CoreDataStackManager.sharedInstance
  private let cardListDataSource = CardListDataSource.sharedInstance
  
  
  override init() {
    super.init()
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
  
  
  /// Add User Selected Card to Deck
  ///
  /// - Parameters:
  ///   - name: deck name
  ///   - card: Selected Card
  func addCardToDeck(name: String, card: Card) {
    coreDataManager.addCardToDeck(name: name, card)
  }
  
  
  /// Create Deck with name
  ///
  /// - Parameters:
  ///   - name: name description
  ///   - id: id of the deck
  /// - Throws: throw error if deck creation failed
  func createDeck(with name: String, id: Int) throws {
    try coreDataManager.createDeck(with: name, id: id)
  }
  
  /// Create Deck with name and store the cards in the deck
  ///
  /// - Parameter name: deck name
  func saveCardstoDeck(with name: String) {
    do {
      try createDeck(with: name, id: numberOfCardAddedToDeck()+1)
      deckCards.forEach{ card in
          addCardToDeck(name: name, card: card)
      }
    } catch {
      CBGErrorHandler.handle(error: ErrorType.failedToCreateDeck)
    }
  }
  
  func numberOfCardAddedToDeck() -> Int {
    return deckCards.count
  }
  
  func addCardToDeckList(_ card: Card) {
    deckCards.append(card)
  }
  
  func removeCardFromDeckList(at indexPath: IndexPath) {
    guard indexPath.row < deckCards.count else {
      return
    }
    deckCards.remove(at: indexPath.row)
  }
  
  func getCard(from index: Int) -> Card? {
    guard index < deckCards.count else {
      return nil
    }
    return deckCards[index]
  }
  
  func isCardSelected(_ card: Card) -> Bool {
    return deckCards.contains(card)
  }
}
