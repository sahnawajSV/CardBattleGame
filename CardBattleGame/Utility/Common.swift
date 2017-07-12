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

func randomCards(cardArray: [Card], num: Int) -> [Card]  {
  var returnArray: [Card] = []
  for _ in 0..<num {
    returnArray.append(cardArray[getRandomNumber(maxNumber: cardArray.count)])
  }
  return returnArray
}
