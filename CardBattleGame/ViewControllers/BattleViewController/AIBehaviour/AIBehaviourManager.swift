//
//  AIBehaviourManager.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 28/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

enum AttackLogic: String {
  case cardCanSurvive
  case cardWillNotSurvive
}

///Passes the message to BattleSystemViewController in order to manage UI Updates
protocol AIBehaviourManagerDelegate: class {
  func didEndTurn(_ aIBehaviourManager: AIBehaviourManager)
  func shouldAttackAvatar(_ aIBehaviourManager: AIBehaviourManager)
  func shouldAttackAnotherCard(_ aiBehaviourManager: AIBehaviourManager, attacker: Card, defender: Card, atkIndex: Int, defIndex: Int)
}

///Handles all gameplay logic related to Player Two.
class AIBehaviourManager {
  
  weak var delegate: AIBehaviourManagerDelegate?
  
  var playerOneStats: Stats
  var playerTwoStats: Stats
  
  init(playerOneStats: Stats, playerTwoStats: Stats) {
    self.playerOneStats = playerOneStats
    self.playerTwoStats = playerTwoStats
  }
  
  private func playACard() {
    delegate?.didEndTurn(self)
  }
  
  func attackWithACard() {
    if playerTwoStats.gameStats.inPlay.count > 0 {
      let canAttackCards = playerTwoStats.gameStats.inPlay.filter { $0.canAttack }
      if canAttackCards.count == 0 {
        playACard()
      } else {
        let totalAttackPower = getTotalAttackPower(allCards: canAttackCards)
        let lowHealthThresholdOfPlayer: Int = Int(15 * playerOneStats.gameStats.health / 100)
        
        if playerOneStats.gameStats.health - totalAttackPower <= lowHealthThresholdOfPlayer {
          delegate?.shouldAttackAvatar(self)
        } else {
          if playerOneStats.gameStats.inPlay.count > 0 {
            if !checkForAttackLogic(logicType: AttackLogic.cardCanSurvive) {
              if !checkForAttackLogic(logicType: AttackLogic.cardWillNotSurvive) {
                delegate?.shouldAttackAvatar(self)
              }
            }
          } else {
            delegate?.shouldAttackAvatar(self)
          }
        }
      }
    } else {
      playACard()
    }
  }
  
  //MARK: - Logic Helpers
  func allowAllPlayCardsToAttack() {
    for (index, _) in playerTwoStats.gameStats.inPlay.enumerated() {
      playerTwoStats.gameStats.inPlay[index].canAttack = true
    }
  }
  
  func getTotalAttackPower(allCards: [Card]) -> Int {
    let attackPower: [Int16] = allCards.map { return $0.attack }
    let totalAttackPower = attackPower.reduce(0) { (totalAttackPower, attackPower) in totalAttackPower + Int(attackPower) }
    
    return totalAttackPower
  }

  func checkForAttackLogic(logicType: AttackLogic) -> Bool {
    var attacker: Card?
    var attackerIndex: Int?
    var defender: Card?
    var defenderIndex: Int?
    for (atkIndex,element) in playerTwoStats.gameStats.inPlay.enumerated() {
      let attackingCard: Card = element
      if attackingCard.canAttack {
        for (defIndex,element) in playerOneStats.gameStats.inPlay.enumerated() {
          let defendingCard: Card = element
          if logicType == AttackLogic.cardCanSurvive {
            if attackingCard.attack >= defendingCard.health && attackingCard.health > defendingCard.attack {
              attacker = attackingCard
              attackerIndex = atkIndex
              defender = defendingCard
              defenderIndex = defIndex
              break
            }
          } else if logicType == AttackLogic.cardWillNotSurvive {
            if attackingCard.attack >= defendingCard.health {
              attacker = attackingCard
              attackerIndex = atkIndex
              defender = defendingCard
              defenderIndex = defIndex
              break
            }
          }
        }
      }
      if attacker != nil {
        break
      }
    }
    
    if let atkcard = attacker, let defCard = defender, let atkIndex = attackerIndex, let defIndex = defenderIndex {
      delegate?.shouldAttackAnotherCard(self, attacker: atkcard, defender: defCard, atkIndex: atkIndex, defIndex: defIndex)
      
      return true
    } else {
      return false
    }
  }
}
