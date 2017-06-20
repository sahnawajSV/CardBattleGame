//
//  CardListDataSource.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 16/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class CardListDataSource: NSObject {
    
    
    override init() {
        super.init()
        populateData()
    }
    
    //Make Read Only - Let only variable
    var cardList:[Card] = []
    
    
    // MARK:- Populate Data from plist
    func populateData() {
        if let path = Bundle.main.path(forResource: "CardList", ofType: "plist") {
            if let dictArray = NSArray(contentsOfFile: path) {
                for item in dictArray {
                    if let dict = item as? NSDictionary {
                        let name = dict["name"] as! String
                        let id = dict["id"] as! String
                        let attack = dict["attack"] as! String
                        let battlepoint = dict["battlepoint"] as! String
                        let health = dict["health"] as! String
                        
                        let cardData = Card(name: name, id: id, attack: attack, battlepoint: battlepoint, health: health, canAttack: false)
                        cardList.append(cardData)
                    }
                }
            }
        }
    }
    
    //Remove Methods
    // MARK:-Return Cards
    func  fetchCardList() -> [Card]
    {
        return cardList
    }
    
    
    // MARK : - Get Number Of Cards
    func numbeOfCards() -> Int {
        
        return cardList.count
    }
}
