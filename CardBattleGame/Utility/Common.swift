//
//  Common.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 19/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

func getRandomNumber(maxNumber: Int) -> Int {
  let randomNumber = arc4random_uniform(UInt32(maxNumber))
  return Int(randomNumber)
}

func generateRandomNumber(min: Int, max: Int) -> Int {
  let randomNum = Int(arc4random_uniform(UInt32(max) - UInt32(min)) + UInt32(min))
  return randomNum
}

func randomCards(cardArray: [Card]) -> [Card]  {
  var returnArray: [Card] = []
  for _ in 0...Game.maximumCardPerDeck {
//    let card: Card = cardArray[getRandomNumber(maxNumber: cardArray.count)]
//    var cardInfo: [String: Any] = [:]
//    cardInfo["id"] = card.id
//    cardInfo["attack"] = card.attack
//    cardInfo["battlepoint"] = card.battlepoint
//    cardInfo["health"] = card.health
//    cardInfo["canAttack"] = card.canAttack
//    let newCard: Card = Card(dictionary: cardInfo)!
    returnArray.append(cardArray[getRandomNumber(maxNumber: cardArray.count)])
  }
  return returnArray
}
