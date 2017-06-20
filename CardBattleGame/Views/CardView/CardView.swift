//
//  CardView.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 19/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class CardView: UIView {

    //MARK: - Accessor Objects
    var bpText: UILabel?
    var attackText: UILabel?
    var healthText: UILabel?
    var nameText: UILabel?
    var button: UIButton?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        addUIBehavior()
    }
    
    convenience init()
    {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addUIBehavior()
    {
        let common = Common()
        let cardView = UIView(frame: CGRect(x: 0, y: 0, width: 194, height: 254))
        cardView.backgroundColor = UIColor.black
        
        //BATTLE POINT
        let bpView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        bpView.backgroundColor = UIColor.blue
        
        bpText = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        bpText = common.setTextProperties(textLbl: bpText!)
        bpView.addSubview(bpText!)
        
        cardView.addSubview(bpView)
        
        //ATTACK
        let attackView = UIView(frame: CGRect(x: 0, y: 0 + (cardView.frame.size.height) - 50, width: 50, height: 50))
        attackView.backgroundColor = UIColor.red
        
        attackText = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        attackText = common.setTextProperties(textLbl: attackText!)
        attackView.addSubview(attackText!)
        cardView.addSubview(attackView)
        
        //HEALTH
        let healthView = UIView(frame: CGRect(x: 0 + (cardView.frame.size.width) - 50, y: 0 + (cardView.frame.size.height) - 50, width: 50, height: 50))
        healthView.backgroundColor = UIColor.green
    
        healthText = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        healthText = common.setTextProperties(textLbl: healthText!)
        healthView.addSubview(healthText!)
        
        cardView.addSubview(healthView)
        
        //CARD NAME
        let nameView = UIView(frame: CGRect(x: 0 , y: 0, width: (cardView.frame.size.width), height: (cardView.frame.size.height)))
        nameView.backgroundColor = UIColor.clear
        
        nameText = UILabel(frame: CGRect(x: 0 , y: 0, width: (nameView.frame.size.width), height: (nameView.frame.size.height)))
        nameText = common.setTextProperties(textLbl: nameText!)
        nameView.addSubview(nameText!)
        cardView.addSubview(nameView)
        
        //BUTTON
//        button = UIButton(type: .custom)
//        button?.frame = CGRect(x: 0 , y: 0, width: (cardView.frame.size.width), height: (cardView.frame.size.height))
//        button?.setTitle("", for: UIControlState.normal)
//        cardView.addSubview(button!)
        
        self.addSubview(cardView)
    }
    
    
}
