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
    if let path = Bundle.main.path(forResource: "CardList", ofType: "plist") {
      if let dictArray = NSArray(contentsOfFile: path) {
        for item in dictArray {
          if let dict = item as? NSDictionary {
            if let data = Card(dictionary: dict) {
              cardList.append(data)
            }
          }
        }
      }
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
