//
//  BattleSystemViewModel.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 19/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class BattleSystemViewModel: NSObject {

    func drawCards(cardCount : Int, numToDraw : Int) -> Array<Int>
    {
        var cardsDrawnIndexes = Array<Int>()
        
        for _ in 0...numToDraw-1
        {
            let cardIndex = randomCard(cardCount: cardCount)
            cardsDrawnIndexes.append(cardIndex)
        }
        
        return cardsDrawnIndexes
    }
    
    func playCard(stats: Stats, cardIndex: Int) -> Stats
    {
        let gameStats = stats
        gameStats.gameStats?.inPlay?.append((gameStats.gameStats?.inHand?[cardIndex])!)
        gameStats.gameStats?.inHand?.remove(at: cardIndex)
        return gameStats
    }
    
    
    //Mark: -- Logic Handlers
    func randomCard(cardCount : Int) -> Int
    {
        let randomIndex = arc4random_uniform(UInt32(cardCount))
        return Int(randomIndex)
    }
    
    func incrementBattlePoints(stats: Stats) -> Stats
    {
        let gameStats = stats
        var battlePoints : Int = Int((gameStats.gameStats?.battlePoints)!)!
        if battlePoints < Defaults.MAXIMUM_BATTLE_POINTS
        {
            battlePoints = battlePoints + Defaults.BATTLE_POINT_INCREMENT
        }
        
        gameStats.gameStats?.battlePoints = String(battlePoints)
        
        return gameStats
    }

}
