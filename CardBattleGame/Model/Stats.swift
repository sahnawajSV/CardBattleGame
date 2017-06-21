//
//  Stats.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 19/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class Stats {
  var name: String
  var id: String
  var deckList: [Deck]
  var gameStats: Game
  
  init(name: String, id: String, deckList: [Deck], gameStats: Game) {
    self.name = name
    self.id = id
    self.deckList = deckList
    self.gameStats = gameStats
  }
}
