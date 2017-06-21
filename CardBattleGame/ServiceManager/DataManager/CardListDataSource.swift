//
//  CardListDataSource.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 16/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class CardListDataSource: NSObject {
  
  static let sharedInstance: CardListDataSource = {
    let instance = CardListDataSource()
    return instance
  }()
  
  // MARK: - Properties
  //
  private var cardList:[Card] = []
  
  
  // MARK: - Initialization
  //
  override init() {
    super.init()
    populateData()
  }
  
  
  // MARK:- Populate Data from plist
  //
  func populateData() {
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
  
  
  // MARK:-Return Cards
  //
  func  fetchCardList() -> [Card] {
    return cardList
  }
  
  
  // MARK : - Get Number Of Cards
  //
  func numbeOfCards() -> Int {
    return cardList.count
  }
}
