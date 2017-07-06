//
//  Deck.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 19/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

/// Holds information on all the Decks and its cards that were created by the Player. 
class Deck {
  
  var name: String
  var id: Int16
  var cardList: [Card]
  
  init(name: String, id: Int16, cardList: [Card]) {
    self.name = name
    self.id = id
    self.cardList = cardList
  }
}
