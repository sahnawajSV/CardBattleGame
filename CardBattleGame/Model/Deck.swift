//
//  Deck.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 19/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class Deck: NSObject {

    var name:String = ""
    var id:String = ""
    var cardList:Array<Card> = Array<Card>()
    
    init(name: String, id: String, cardList: Array<Card>) {
        self.name = name
        self.id = id
        self.cardList = cardList
    }
}
