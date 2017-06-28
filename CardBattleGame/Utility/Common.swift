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
