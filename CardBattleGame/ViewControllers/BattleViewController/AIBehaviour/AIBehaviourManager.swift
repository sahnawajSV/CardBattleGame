//
//  AIBehaviourManager.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 28/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

protocol AIBehaviourManagerDelegate: class {
  func AIBehaviourManagerDidSelectCardToPlay(_ aiBehaviourManager: AIBehaviourManager, cardInfo: [String : AnyObject])
  func AIBehaviourManagerDidEndTurn(_ aiBehaviourManager: AIBehaviourManager)
  func AIBehaviourManagerDidAttackCard(atkUpdatedHealth: Int, defUpdatedHealth: Int, atkIndex: Int, defIndex: Int)
  func AIBehaviourManagerDidAttackAvatar(attacker: Card, atkIndex: Int)
}

class AIBehaviourManager {
  
  weak var delegate: AIBehaviourManagerDelegate?
  
  var playerOneStats: Stats
  var playerTwoStats: Stats
  
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
        for (index,element) in self.playerTwoStats.gameStats.inHand.enumerated() {
          let card: Card = element
          //Check if card is playable
          if Int(card.battlepoint) <= availableBattlePoints {
            cardToPlay = card
            cardIndex = index
            break
          }
        }
        //Play Card
        if cardToPlay != nil {
            delay(1, closure: {
              self.playerTwoStats.gameStats.playCard(card: cardToPlay!)
              var cardInfo = [String : AnyObject]()
              cardInfo["cardIndex"] = cardIndex as AnyObject
              cardInfo["card"] = cardToPlay
              self.delegate?.AIBehaviourManagerDidSelectCardToPlay(self, cardInfo: cardInfo)
              self.playCard()
            })
        } else {
          delegate?.AIBehaviourManagerDidEndTurn(self)
        }
      } else {
        delegate?.AIBehaviourManagerDidEndTurn(self)
      }
    } else {
      delegate?.AIBehaviourManagerDidEndTurn(self)
    }
  }
  
  func attackWithCards()
  {
    var canAttackCards: [Card] = []
    for (_,element) in playerTwoStats.gameStats.inPlay.enumerated() {
      let card: Card = element
      if card.canAttack {
        canAttackCards.append(element)
      }
    }
    if canAttackCards.count == 0 {
      playCard()
    } else {
      let totalAttackPower: Int = getTotalAttackPower(allCards: canAttackCards)
      let lowHealthThresholdOfPlayer: Int = Int(15 * playerOneStats.gameStats.health / 100)
      
      if playerOneStats.gameStats.health - totalAttackPower <= lowHealthThresholdOfPlayer {
        attackAvatar()
        playCard()
      } else {
        if playerOneStats.gameStats.inPlay.count > 0 {
          if !checkForAttackLogic(logicType: 0) {
            if !checkForAttackLogic(logicType: 1) {
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
      deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
  }
  
  func attackCardToCard(attacker: Card, defender: Card, atkIndex: Int, defIndex: Int) {
    let atkCard = attacker
    let defCard = defender
    let updateAtkHealth: Int16 = atkCard.health - defCard.attack
    let updateDefHealth: Int16 = defCard.health - atkCard.attack
    
    atkCard.canAttack = false
    
    if updateAtkHealth <= 0 {
      //DESTROY ATTACKER
      playerTwoStats.gameStats.inPlay.remove(at: atkIndex)
    } else {
      playerTwoStats.gameStats.inPlay[atkIndex] = atkCard
    }
    
    if updateDefHealth <= 0 {
      //DESTROY DEFENDER
      playerOneStats.gameStats.inPlay.remove(at: defIndex)
    } else {
      playerOneStats.gameStats.inPlay[defIndex] = defCard
    }
    
    delegate?.AIBehaviourManagerDidAttackCard(atkUpdatedHealth: Int(updateAtkHealth), defUpdatedHealth: Int(updateDefHealth), atkIndex: atkIndex, defIndex: defIndex)
  }
  
  func attackCardToAvatar(attacker: Card, atkIndex: Int) {
    playerOneStats.gameStats.getHurt(attackValue: Int(attacker.attack))
    let atkCard = attacker
    atkCard.canAttack = false
    playerTwoStats.gameStats.inPlay[atkIndex] = atkCard
    delegate?.AIBehaviourManagerDidAttackAvatar(attacker: attacker, atkIndex: atkIndex)
  }
  
  //MARK: - HELPERS
  func allowAllPlayCardsToAttack() {
    for (_,element) in playerTwoStats.gameStats.inPlay.enumerated() {
      let card: Card = element
      card.canAttack = true
    }
  }
  
  func getTotalAttackPower(allCards: [Card]) -> Int {
    var totalAttackPower: Int = 0
    for i in 0..<allCards.count {
      let card = allCards[i]
      totalAttackPower = totalAttackPower + Int(card.attack)
    }
    
    return totalAttackPower
  }
  
  func attackAvatar() {
    for (atkIndex,element) in playerTwoStats.gameStats.inPlay.enumerated() {
      let attackingCard: Card = element
      if attackingCard.canAttack {
        attackCardToAvatar(attacker: attackingCard, atkIndex: atkIndex)
      }
    }
  }
  
  func checkForAttackLogic(logicType: Int) -> Bool {
    var attacker: Card?
    var attackerIndex: Int?
    var defender: Card?
    var defenderIndex: Int?
    for (atkIndex,element) in playerTwoStats.gameStats.inPlay.enumerated() {
      let attackingCard: Card = element
      if attackingCard.canAttack {
        for (defIndex,element) in playerOneStats.gameStats.inPlay.enumerated() {
          let defendingCard: Card = element
          if logicType == 0 {
            if attackingCard.attack >= defendingCard.health && attackingCard.health > defendingCard.attack {
              attacker = attackingCard
              attackerIndex = atkIndex
              defender = defendingCard
              defenderIndex = defIndex
              break
            }
          } else {
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
    if attacker != nil {
      //ATTACK THE DEFENDING CARD - CARD TO CARD
      attackCardToCard(attacker: attacker!, defender: defender!, atkIndex: attackerIndex!, defIndex: defenderIndex!)
      attackWithCards()
      return true
    } else {
      return false
    }
  }
}
