//
//  CardListDataSource.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 16/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit


/// Card List Data Source :  Read the Card List from the Plist
class CardListDataSource {
  
  /// Shared Instance
  static let sharedInstance: CardListDataSource = {
    let instance = CardListDataSource()
    return instance
  }()
  
  /// Properties
  private var cardList:[Card] = []
  
  /// Initialization
  init() {
    populateData()
  }
  
  private func populateData() {
    guard let path = Bundle.main.path(forResource: "CardList", ofType: "plist"), let dictArray = NSArray(contentsOfFile: path) else {
      return
    }
    
    for item in dictArray {
      guard let dict = item as? Dictionary<String, Any>, let data = Card(dictionary: dict) else {
        continue
      }
      cardList.append(data)
    }
    
  }
  
  /// Returns Card List Array
  ///
  /// - Returns: return value Card array
  func  fetchCardList() -> [Card] {
    return cardList
  }
  
  /// Read Number of Cards
  ///
  /// - Returns: return value number of card
  func numbeOfCards() -> Int {
    return cardList.count
  }
}
