//
//  Game.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 19/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

extension Game {
  static let health = 100
  static let startingBattlePoints = 0
  static let battlePointIncrement = 1
  static let maximumBattlePoint = 10
  static let maximumCardPerDeck = 20
  static let numOfCardstoDrawInitially = 3
  static let numOfCardsToDrawEachTurn = 1
  static let maximumInHandCards = 5
}


/// Game Class is used to hold on-going game information. This class is re-initialized on every game start. It holds necessary information to play the game for both Player One and Player Two.
class Game {
  var inDeck: [Card]
  var inHand: [Card]
  var inPlay: [Card]
  var battlePoints: Int
  var health: Int
  
  init(inDeck: [Card], inHand: [Card], inPlay: [Card], battlePoints: Int, health: Int) {
    self.inDeck = inDeck
    self.inHand = inHand
    self.inPlay = inPlay
    self.battlePoints = battlePoints
    self.health = health
  }
  
  /// Draw card based on numToDraw. Add to hand only if less than maxNumber allowed. Else Draw and Destory the card
  func drawCards(numToDraw : Int) {
    var counter = 0
    while counter < numToDraw, !inDeck.isEmpty {
      let idx = arc4random_uniform(UInt32(inDeck.count))
      let card = inDeck.remove(at: Int(idx))
      if inHand.count < Game.maximumInHandCards {
        inHand.append(card)
      }
      counter += 1
    }
  }
  
  /// Used to play a card from InHand to InPlay
  func playCard(cardIndex: Int) {
      let card: Card = inHand[cardIndex]
      let updatedBattlePoints = battlePoints - Int(card.battlepoint)
      battlePoints = updatedBattlePoints
      inPlay.append(card)
      inHand.remove(at: cardIndex)
  }
  
  
  //Mark: -- Logic Handlers
  func getRandomNumber(maxNumber: Int) -> Int {
    let randomNumber = arc4random_uniform(UInt32(maxNumber))
    return Int(randomNumber)
  }
  
  /// Increment Battle Points everytime a turn starts for a player
  func incrementBattlePoints() {
      var updatedBattlePoints = battlePoints
      if battlePoints < Game.maximumBattlePoint {
        updatedBattlePoints = battlePoints + Game.battlePointIncrement
      }
      battlePoints = updatedBattlePoints
    }
}
