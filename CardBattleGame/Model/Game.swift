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

class Game {
  var inDeck: [Card]
  var inHand: [Card]
  var inPlay: [Card]
  var battlePoints: String
  var health: String
  
  init(inDeck: [Card], inHand: [Card], inPlay: [Card], battlePoints: String, health: String) {
    self.inDeck = inDeck
    self.inHand = inHand
    self.inPlay = inPlay
    self.battlePoints = battlePoints
    self.health = health
  }
  
  //Draw card based on numToDraw. Add to hand only if less than maxNumber allowed. Else Draw and Destory the card
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

//  func drawCards(numToDraw : Int) {
//    var cardsDrawnIndexes = [Int]()
//    
//    for _ in 0..<numToDraw {
//      let cardIndex = getRandomNumber(maxNumber: inDeck.count)
//      cardsDrawnIndexes.append(cardIndex)
//    }
//    
//    var newInDeck: [Card] = inDeck
//    
//    for index in 0...cardsDrawnIndexes.count-1 {
//      let cardIndex = cardsDrawnIndexes[index]
//      let card = inDeck[cardIndex]
//      if let itemToRemoveIndex = newInDeck.index(where: { (card) -> Bool in
//        return true
//      }) {
//        newInDeck.remove(at: itemToRemoveIndex)
//      }
//      
//      //Append only if there are 4 or less cards in Hand
//      if inHand.count <= 4 {
//        inHand.append(card)
//      }
//    }
//    
//    inDeck = newInDeck
//  }
  
  func playCard(cardIndex: Int) {
    if let battlePointsValue = Int(battlePoints) {
      let card: Card = inHand[cardIndex]
      let updatedBattlePoints = battlePointsValue - Int(card.battlepoint)
      battlePoints = String(describing: updatedBattlePoints)
      inPlay.append(card)
      inHand.remove(at: cardIndex)
    }
  }
  
  
  //Mark: -- Logic Handlers
  func getRandomNumber(maxNumber: Int) -> Int {
    let randomNumber = arc4random_uniform(UInt32(maxNumber))
    return Int(randomNumber)
  }
  
  func incrementBattlePoints() {
    if let battlePoints = Int(self.battlePoints) {
      var updatedBattlePoints = battlePoints
      if battlePoints < Game.maximumBattlePoint {
        updatedBattlePoints = battlePoints + Game.battlePointIncrement
      }
      self.battlePoints = String(updatedBattlePoints)
    }
  }
}
