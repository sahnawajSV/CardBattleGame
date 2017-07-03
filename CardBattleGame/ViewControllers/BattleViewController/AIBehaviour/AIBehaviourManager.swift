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
  func AIBehaviourManagerDidAttackCard(_ aiBehaviourManager: AIBehaviourManager, atkUpdatedHealth: Int, defUpdatedHealth: Int, atkIndex: Int, defIndex: Int)
  func AIBehaviourManagerDidAttackAvatar(_ aiBehaviourManager: AIBehaviourManager, attacker: Card, atkIndex: Int)
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
        var cardToPlay: Card!
        var cardIndex: Int = Game.invalidCardIndex
        for (index,card) in self.playerTwoStats.gameStats.inHand.enumerated() {
          //Check if card is playable
          if Int(card.battlepoint) <= availableBattlePoints {
            cardToPlay = card
            cardIndex = index
            break
          }
        }
        //Play Card
        if cardIndex != Game.invalidCardIndex {
            delay(1, closure: {
              self.playerTwoStats.gameStats.playCard(card: cardToPlay)
              var cardInfo = [String : AnyObject]()
              cardInfo["cardIndex"] = cardIndex as AnyObject
              cardInfo["card"] = cardToPlay as AnyObject
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
    
    delegate?.AIBehaviourManagerDidAttackCard(self, atkUpdatedHealth: Int(updateAtkHealth), defUpdatedHealth: Int(updateDefHealth), atkIndex: atkIndex, defIndex: defIndex)
  }
  
  func attackCardToAvatar(attacker: inout Card, atkIndex: Int) {
    playerOneStats.gameStats.getHurt(attackValue: Int(attacker.attack))
    attacker.canAttack = false
    playerTwoStats.gameStats.inPlay[atkIndex] = attacker
    delegate?.AIBehaviourManagerDidAttackAvatar(self, attacker: attacker, atkIndex: atkIndex)
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
      var attackingCard: Card = element
      if attackingCard.canAttack {
        attackCardToAvatar(attacker: &attackingCard, atkIndex: atkIndex)
      }
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
