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
  case canWillNotSurvive
}

enum ActionList: String {
  case attackCard
  case attackAvatar
  case playACard
  case endTurn
}

///Passes the message to BattleSystemViewController in order to manage UI Updates
protocol AIBehaviourManagerDelegate: class {
  func aiBehaviourManagerDidSelectCardToPlay(_ aiBehaviourManager: AIBehaviourManager, cardIndex: Int)
  func aiBehaviourManagerDidEndTurn(_ aiBehaviourManager: AIBehaviourManager)
  func aiBehaviourManagerDidAttackCard(_ aiBehaviourManager: AIBehaviourManager, atkUpdatedHealth: Int, defUpdatedHealth: Int, atkIndex: Int, defIndex: Int)
  func aiBehaviourManagerDidAttackAvatar(_ aiBehaviourManager: AIBehaviourManager, attacker: Card, atkIndex: Int)
  func aiBehaviourManagerReloadPlayView(_ aiBehaviourManager: AIBehaviourManager)
}

///Handles all gameplay logic related to Player Two.
class AIBehaviourManager {
  
  weak var delegate: AIBehaviourManagerDelegate?
  
  var playerOneStats: Stats
  var playerTwoStats: Stats
  
  var allAITasks: [ActionList] = []
  
  init(playerOneStats: Stats, playerTwoStats: Stats) {
    self.playerOneStats = playerOneStats
    self.playerTwoStats = playerTwoStats
  }
  
  func performInitialChecks()
  {
    if playerTwoStats.gameStats.inPlay.count == 0 {
      //Use Play Card Logic
      playCard()
    } else {
      //Reload Play Area Cards Position
      delegate?.aiBehaviourManagerReloadPlayView(self)
      
      //ALL InPlay cards should be able to attack
      allowAllPlayCardsToAttack()
      //Use Attack Logic
      attackWithCards()
    }
  }
  
  func playCard()
  {
    //Check if the playBaord is not full
    if playerTwoStats.gameStats.inPlay.count < 5 {
      //Check if player has cards in Hand and can play a card based on available BattlePoints
      if playerTwoStats.gameStats.inHand.count > 0 {
        let availableBattlePoints: Int = playerTwoStats.gameStats.battlePoints
        var cardToPlay: Card?
        var cardIndex: Int?
        for (index,card) in self.playerTwoStats.gameStats.inHand.enumerated() {
          //Check if card is playable
          if Int(card.battlepoint) <= availableBattlePoints {
            cardToPlay = card
            cardIndex = index
            break
          }
        }
        //Play Card
        if let index = cardIndex, let card = cardToPlay {
          delay(1, closure: {
            self.playerTwoStats.gameStats.playCard(card: card)
            self.delegate?.aiBehaviourManagerDidSelectCardToPlay(self, cardIndex: index)
          })
        } else {
          delegate?.aiBehaviourManagerDidEndTurn(self)
        }
      } else {
        delegate?.aiBehaviourManagerDidEndTurn(self)
      }
    } else {
      delegate?.aiBehaviourManagerDidEndTurn(self)
    }
  }
  
  func attackWithCards()
  {
    let canAttackCards = playerTwoStats.gameStats.inPlay.filter { $0.canAttack }
    if canAttackCards.count == 0 {
      playCard()
    } else {
      let totalAttackPower = getTotalAttackPower(allCards: canAttackCards)
      let lowHealthThresholdOfPlayer: Int = Int(15 * playerOneStats.gameStats.health / 100)
      
      if playerOneStats.gameStats.health - totalAttackPower <= lowHealthThresholdOfPlayer {
        attackAvatar()
        playCard()
      } else {
        if playerOneStats.gameStats.inPlay.count > 0 {
          if !checkForAttackLogic(logicType: AttackLogic.cardCanSurvive) {
            if !checkForAttackLogic(logicType: AttackLogic.canWillNotSurvive) {
              attackAvatar()
              playCard()
            }
          }
        } else {
          attackAvatar()
          playCard()
        }
      }
    }
  }
  
  func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
      deadline: .now() + delay, execute: closure)
  }
  
  func attackCardToCard(attacker: Card, defender: Card, atkIndex: Int, defIndex: Int) {
    var atkCard = attacker
    let defCard = defender
    let updateAtkHealth: Int16 = atkCard.health - defCard.attack
    let updateDefHealth: Int16 = defCard.health - atkCard.attack
    
    atkCard.canAttack = false
    performCardHealthCheck(forPlayer: playerTwoStats, cardIndex: atkIndex, card: atkCard, updatedHealth: updateAtkHealth)
    performCardHealthCheck(forPlayer: playerOneStats, cardIndex: defIndex, card: defCard, updatedHealth: updateDefHealth)
    
    delegate?.aiBehaviourManagerDidAttackCard(self, atkUpdatedHealth: Int(updateAtkHealth), defUpdatedHealth: Int(updateDefHealth), atkIndex: atkIndex, defIndex: defIndex)
  }
  
  func attackCardToAvatar(attacker: inout Card, atkIndex: Int) {
    playerOneStats.gameStats.getHurt(attackValue: Int(attacker.attack))
    attacker.canAttack = false
    playerTwoStats.gameStats.inPlay[atkIndex] = attacker
    delegate?.aiBehaviourManagerDidAttackAvatar(self, attacker: attacker, atkIndex: atkIndex)
  }
  
  //MARK: - HELPERS
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
  
  func attackAvatar() {
    for (atkIndex,element) in playerTwoStats.gameStats.inPlay.enumerated() {
      delay(Double(atkIndex), closure: {
        var attackingCard: Card = element
        if attackingCard.canAttack {
          self.attackCardToAvatar(attacker: &attackingCard, atkIndex: atkIndex)
        }
      })
    }
  }
  
  func performCardHealthCheck(forPlayer: Stats, cardIndex: Int, card: Card, updatedHealth: Int16) {
    if updatedHealth <= 0 {
      //DESTROY DEFENDER
      forPlayer.gameStats.inPlay.remove(at: cardIndex)
    } else {
      forPlayer.gameStats.inPlay[cardIndex] = card
    }
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
          } else if logicType == AttackLogic.canWillNotSurvive {
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
      attackCardToCard(attacker: atkcard, defender: defCard, atkIndex: atkIndex, defIndex: defIndex)
      delay(1.5, closure: {
        self.attackWithCards()
      })
      
      return true
    } else {
      return false
    }
  }
}
