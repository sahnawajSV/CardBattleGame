//
//  BattleViewController.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 14/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class BattleViewController: UIViewController, BattleProtocolDelegate
{
    // MARK: - Properties
    // MARK: -- Internal
    
    var viewModel : BattleViewModel?

    
    private var allPlayerHandCards : NSMutableArray? = NSMutableArray();
    private var allAIHandCards : NSMutableArray? = NSMutableArray();
    
    private var allPlayerPlayedCards : NSMutableArray? = NSMutableArray();
    private var allAIPlayedCards : NSMutableArray? = NSMutableArray();
    
    @IBOutlet private weak var playerDeckListText: UILabel!
    @IBOutlet private weak var playerBattlePointText: UILabel!
    @IBOutlet private weak var playerNameText: UILabel!
    @IBOutlet private weak var playerHealthText: UILabel!
    
    @IBOutlet private weak var AIDeckListText: UILabel!
    @IBOutlet private weak var AIBattlePointText: UILabel!
    @IBOutlet private weak var AINameText: UILabel!
    @IBOutlet private weak var AIHealthText: UILabel!
    
    @IBOutlet private weak var playerHandView: UIView!
    @IBOutlet private weak var playerView: UIView!
    @IBOutlet private weak var playerDeckView: UIView!
    @IBOutlet private weak var playerGameAreaView: UIView!
    
    @IBOutlet private weak var AIHandView: UIView!
    @IBOutlet private weak var AIView: UIView!
    @IBOutlet private weak var AIDeckView: UIView!
    @IBOutlet private weak var AIGameAreaView: UIView!
    
    //Gameplay Variables
    //Initial Initialization for Unwanted Value
    private var selectedCardForAttack : Int? = 99;
    private var isAttacking : Bool? = false;
    
    /* AIHand
     * 84, -80, 194, 254
     * 286, -80, 194, 254
     * 488, -80, 194, 254
     * 690, -80, 194, 254
     * 892, -80, 194, 254
     */
    
    /* PlayerHand
     * 84, 0, 194, 254
     * 286, 0, 194, 254
     * 488, 0, 194, 254
     * 690, 0, 194, 254
     * 892, 0, 194, 254
     */
    
    /* AIGameArea
     * 84, 29, 194, 254
     * 286, 29, 194, 254
     * 488, 29, 194, 254
     * 690, 29, 194, 254
     * 892, 29, 194, 254
     */
    
    /* PlayerGameArea
     * 84, 29, 194, 254
     * 286, 29, 194, 254
     * 488, 29, 194, 254
     * 690, 29, 194, 254
     * 892, 29, 194, 254
     */
    
    /* PlayerGameArea Without SuperView
     * 84, 552, 194, 254
     * 286, 552, 194, 254
     * 488, 552, 194, 254
     * 690, 552, 194, 254
     * 892, 552, 194, 254
     */

    
    //MARK: - LifeCycle Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()

        viewModel = BattleViewModel()
        viewModel?.delegate = self
        viewModel?.initializeTheGame()
        configureAllViews()
        createInHandCardForPlayerView()
        createInHandCardForAIView()
        //TEMP
        createInPlayCardForAIView()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Configuration Methods
    private func configureAllViews()
    {
        guard let viewModel = viewModel else
        {
            return
        }
        
        playerDeckListText.text = viewModel.playerNumCardsInDeck
        AIDeckListText.text = viewModel.AINumCardsInDeck
        
        playerBattlePointText.text = viewModel.playerBattlePointsText
        AIBattlePointText.text = viewModel.AIBattlePointsText
        
        playerNameText.text = viewModel.playerName
        AINameText.text = viewModel.AIName
        
        playerHealthText.text = viewModel.playerHealth
        AIHealthText.text = viewModel.AIHealth
    }
    
    //MARK: - Create In Hand Cards
    func createInHandCardForPlayerView()
    {
        guard viewModel != nil else
        {
            return
        }
        
        if (allPlayerHandCards?.count)! > 0
        {
            for (index,_) in (allPlayerHandCards?.enumerated())!
            {
                let cardView = allPlayerHandCards?[index] as! UIView
                cardView.removeFromSuperview()
            }
        }
        
        allPlayerHandCards?.removeAllObjects()
        
        let gap = viewModel?.playerHandGap
        var lastXValue : CGFloat?
        
        for (index,_) in (viewModel?.playerCardsInHand?.enumerated())!
        {
            var xValue : CGFloat?
            let cardInfoDict : Dictionary<String, Any> = viewModel?.playerCardsInHand?[index] as! Dictionary<String, Any>
            
            if index == 0
            {
                xValue = (viewModel?.playerHandStartRect?.origin.x)!
            }
            else
            {
                xValue = lastXValue! + (viewModel?.playerHandStartRect?.size.width)! + CGFloat(gap!)
            }
            
            let cardView = UIView(frame: CGRect(x: xValue!, y: (viewModel?.playerHandStartRect?.origin.y)!, width: (viewModel?.playerHandStartRect?.size.width)!, height: (viewModel?.playerHandStartRect?.size.height)!))
            cardView.backgroundColor = UIColor.black
            
            //BATTLE POINT
            let bpView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            bpView.backgroundColor = UIColor.blue
            
            var bpText = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            bpText.text = cardInfoDict["battlePoint"] as? String
            bpText = SetTextProperties(textLbl: bpText)
            bpView.addSubview(bpText)
            
            cardView.addSubview(bpView)
            
            //ATTACK
            let attackView = UIView(frame: CGRect(x: 0, y: 0 + (cardView.frame.size.height) - 50, width: 50, height: 50))
            attackView.backgroundColor = UIColor.red
            
            var attackText = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            attackText.text = cardInfoDict["attack"] as? String
            attackText = SetTextProperties(textLbl: attackText)
            attackView.addSubview(attackText)
            
            cardView.addSubview(attackView)
            
            //HEALTH
            let healthView = UIView(frame: CGRect(x: 0 + (cardView.frame.size.width) - 50, y: 0 + (cardView.frame.size.height) - 50, width: 50, height: 50))
            healthView.backgroundColor = UIColor.green
            
            var healthText = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            healthText.text = cardInfoDict["health"] as? String
            healthText = SetTextProperties(textLbl: healthText)
            healthView.addSubview(healthText)
            
            cardView.addSubview(healthView)
            
            //CARD NAME
            let nameView = UIView(frame: CGRect(x: 0 , y: 0, width: (cardView.frame.size.width), height: (cardView.frame.size.height)))
            nameView.backgroundColor = UIColor.clear
            
            var nameText = UILabel(frame: CGRect(x: 0 , y: 0, width: (nameView.frame.size.width), height: (nameView.frame.size.height)))
            nameText.text = cardInfoDict["name"] as? String
            nameText = SetTextProperties(textLbl: nameText)
            nameText.numberOfLines = 2
            nameText.font = UIFont(name: "systemFont", size: 60);
            nameView.addSubview(nameText)
            
            cardView.addSubview(nameView)
            
            //BUTTON
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 0 , y: 0, width: (cardView.frame.size.width), height: (cardView.frame.size.height))
            button.tag = index
            button.setTitle("", for: UIControlState.normal)
            cardView.addSubview(button)
            button.addTarget(self, action: #selector(PlayCardPressed), for: UIControlEvents.touchUpInside)
            
            playerHandView.addSubview(cardView)
            allPlayerHandCards?.add(cardView)
            
            lastXValue = xValue
        }
    }
    
    func createInHandCardForAIView()
    {
        guard viewModel != nil else
        {
            return
        }
        
        if (allAIHandCards?.count)! > 0
        {
            for (index,_) in (allAIHandCards?.enumerated())!
            {
                let cardView = allAIHandCards?[index] as! UIView
                cardView.removeFromSuperview()
            }
        }

        allAIHandCards?.removeAllObjects()
        
        let gap = viewModel?.AIHandGap
        var lastXValue : CGFloat?
        
        for (index,_) in (viewModel?.AICardsInHand?.enumerated())!
        {
            var xValue : CGFloat?
            //USE LATER IF REQUIRED
            let _ : Dictionary<String, Any> = viewModel?.AICardsInHand?[index] as! Dictionary<String, Any>
            
            if index == 0
            {
                xValue = (viewModel?.AIHandStartRect?.origin.x)!
            }
            else
            {
                xValue = lastXValue! + (viewModel?.AIHandStartRect?.size.width)! + CGFloat(gap!)
            }
            
            let cardView = UIView(frame: CGRect(x: xValue!, y: (viewModel?.AIHandStartRect?.origin.y)!, width: (viewModel?.AIHandStartRect?.size.width)!, height: (viewModel?.AIHandStartRect?.size.height)!))
            cardView.backgroundColor = UIColor.black
            
            AIHandView.addSubview(cardView)
            
            allAIHandCards?.add(cardView)
            
            lastXValue = xValue
        }
    }
    
    
    //MARK: - Create In Play Cards
    func createInPlayCardForPlayerView()
    {
        guard viewModel != nil else
        {
            return
        }
        
        if (allPlayerPlayedCards?.count)! > 0
        {
            for (index,_) in (allPlayerPlayedCards?.enumerated())!
            {
                let cardView = allPlayerPlayedCards?[index] as! UIView
                cardView.removeFromSuperview()
            }
        }
        
        allPlayerPlayedCards?.removeAllObjects()
        
        let gap = viewModel?.playerGameAreaGap
        var lastXValue : CGFloat?
        
        for (index,_) in (viewModel?.playerCardsInPlay?.enumerated())!
        {
            var xValue : CGFloat?
            let cardInfoDict : Dictionary<String, Any> = viewModel?.playerCardsInPlay?[index] as! Dictionary<String, Any>
            
            if index == 0
            {
                xValue = (viewModel?.playerGameAreaStartRect?.origin.x)!
            }
            else
            {
                xValue = lastXValue! + (viewModel?.playerGameAreaStartRect?.size.width)! + CGFloat(gap!)
            }
            
            let cardView = UIView(frame: CGRect(x: xValue!, y: (viewModel?.playerGameAreaStartRect?.origin.y)!, width: (viewModel?.playerGameAreaStartRect?.size.width)!, height: (viewModel?.playerGameAreaStartRect?.size.height)!))
            cardView.backgroundColor = UIColor.black
            
            //BATTLE POINT
            let bpView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            bpView.backgroundColor = UIColor.blue
            
            var bpText = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            bpText.text = cardInfoDict["battlePoint"] as? String
            bpText = SetTextProperties(textLbl: bpText)
            bpView.addSubview(bpText)
            
            cardView.addSubview(bpView)
            
            //ATTACK
            let attackView = UIView(frame: CGRect(x: 0, y: 0 + (cardView.frame.size.height) - 50, width: 50, height: 50))
            attackView.backgroundColor = UIColor.red
            
            var attackText = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            attackText.text = cardInfoDict["attack"] as? String
            attackText = SetTextProperties(textLbl: attackText)
            attackView.addSubview(attackText)
            
            cardView.addSubview(attackView)
            
            //HEALTH
            let healthView = UIView(frame: CGRect(x: 0 + (cardView.frame.size.width) - 50, y: 0 + (cardView.frame.size.height) - 50, width: 50, height: 50))
            healthView.backgroundColor = UIColor.green
            
            var healthText = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            healthText.text = cardInfoDict["health"] as? String
            healthText = SetTextProperties(textLbl: healthText)
            healthView.addSubview(healthText)
            
            cardView.addSubview(healthView)
            
            //CARD NAME
            let nameView = UIView(frame: CGRect(x: 0 , y: 0, width: (cardView.frame.size.width), height: (cardView.frame.size.height)))
            nameView.backgroundColor = UIColor.clear
            
            var nameText = UILabel(frame: CGRect(x: 0 , y: 0, width: (nameView.frame.size.width), height: (nameView.frame.size.height)))
            nameText.text = cardInfoDict["name"] as? String
            nameText = SetTextProperties(textLbl: nameText)
            nameText.numberOfLines = 2
            nameText.font = UIFont(name: "systemFont", size: 60);
            nameView.addSubview(nameText)
            
            cardView.addSubview(nameView)
            
            self.view.addSubview(cardView)
            allPlayerPlayedCards?.add(cardView)
            
            lastXValue = xValue
        }
    }

    func createInPlayCardForAIView()
    {
        guard viewModel != nil else
        {
            return
        }
        
        if (allAIPlayedCards?.count)! > 0
        {
            for (index,_) in (allAIPlayedCards?.enumerated())!
            {
                let cardView = allAIPlayedCards?[index] as! UIView
                cardView.removeFromSuperview()
            }
        }
        
        allAIPlayedCards?.removeAllObjects()
        
        let gap = viewModel?.AIGameAreaGap
        var lastXValue : CGFloat?
        
        for (index,_) in (viewModel?.AICardsInPlay?.enumerated())!
        {
            var xValue : CGFloat?
            let cardInfoDict : Dictionary<String, Any> = viewModel?.AICardsInPlay?[index] as! Dictionary<String, Any>
            
            if index == 0
            {
                xValue = (viewModel?.AIGameAreaStartRect?.origin.x)!
            }
            else
            {
                xValue = lastXValue! + (viewModel?.AIGameAreaStartRect?.size.width)! + CGFloat(gap!)
            }
            
            let cardView = UIView(frame: CGRect(x: xValue!, y: (viewModel?.AIGameAreaStartRect?.origin.y)!, width: (viewModel?.AIGameAreaStartRect?.size.width)!, height: (viewModel?.AIGameAreaStartRect?.size.height)!))
            cardView.backgroundColor = UIColor.black
            
            //BATTLE POINT
            let bpView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            bpView.backgroundColor = UIColor.blue
            
            var bpText = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            bpText.text = cardInfoDict["battlePoint"] as? String
            bpText = SetTextProperties(textLbl: bpText)
            bpView.addSubview(bpText)
            
            cardView.addSubview(bpView)
            
            //ATTACK
            let attackView = UIView(frame: CGRect(x: 0, y: 0 + (cardView.frame.size.height) - 50, width: 50, height: 50))
            attackView.backgroundColor = UIColor.red
            
            var attackText = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            attackText.text = cardInfoDict["attack"] as? String
            attackText = SetTextProperties(textLbl: attackText)
            attackView.addSubview(attackText)
            
            cardView.addSubview(attackView)
            
            //HEALTH
            let healthView = UIView(frame: CGRect(x: 0 + (cardView.frame.size.width) - 50, y: 0 + (cardView.frame.size.height) - 50, width: 50, height: 50))
            healthView.backgroundColor = UIColor.green
            
            var healthText = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            healthText.text = cardInfoDict["health"] as? String
            healthText = SetTextProperties(textLbl: healthText)
            healthView.addSubview(healthText)
            
            cardView.addSubview(healthView)
            
            //CARD NAME
            let nameView = UIView(frame: CGRect(x: 0 , y: 0, width: (cardView.frame.size.width), height: (cardView.frame.size.height)))
            nameView.backgroundColor = UIColor.clear
            
            var nameText = UILabel(frame: CGRect(x: 0 , y: 0, width: (nameView.frame.size.width), height: (nameView.frame.size.height)))
            nameText.text = cardInfoDict["name"] as? String
            nameText = SetTextProperties(textLbl: nameText)
            nameText.numberOfLines = 2
            nameText.font = UIFont(name: "systemFont", size: 60);
            nameView.addSubview(nameText)
            
            cardView.addSubview(nameView)
            
            self.view.addSubview(cardView)
            allAIPlayedCards?.add(cardView)
            
            lastXValue = xValue
        }
    }
    
    // MARK - Actions
    @IBAction private func endTurnPressed(sender: UIButton)
    {
        //if (viewModel?.isPlayerTurn)!
        //{
            viewModel?.endTurnPressed()
            configureAllViews()
            createInHandCardForPlayerView()
            createInHandCardForAIView()
        //}
    }
    
    @IBAction private func PlayCardPressed(sender: UIButton!)
    {
        let tag = sender.tag
        
        let cardInfoDict : Dictionary<String, Any> = viewModel?.playerCardsInHand?[tag] as! Dictionary<String, Any>
        let requiredBattlePointsText : String = cardInfoDict["battlePoint"] as! String
        let requiredBattlePoints = Int(requiredBattlePointsText)
        if (viewModel?.isPlayerTurn)! && requiredBattlePoints! <= (viewModel?.playerBattlePoints)!
        {
            viewModel?.PlayCardPressed(cardIndex: tag)
            createInHandCardForPlayerView()
            createInHandCardForAIView()
            createInPlayCardForPlayerView()
            createInPlayCardForAIView()
            configureAllViews()
        }
    }
    
    //MARK: Utilities
    
    func SetTextProperties(textLbl : UILabel) -> UILabel
    {
        textLbl.font = UIFont(name: "systemFont-Bold", size: 14)
        textLbl.textColor = UIColor.white
        textLbl.textAlignment = NSTextAlignment.center
        
        return textLbl
    }
    
    
    //MARK: Touch and Drag For Attack
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if !isAttacking!
        {
            let touch = touches.first
            let location = touch?.location(in: self.view)
            
            for (index,_) in (allPlayerPlayedCards?.enumerated())!
            {
                let card = allPlayerPlayedCards?[index] as! UIView
                if (card.frame.contains(location!))
                {
                    selectedCardForAttack = index
                    viewModel?.originalCardViewFrame = card.frame
                    break
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if !isAttacking!
        {
            if selectedCardForAttack! <= 5
            {
                let touch = touches.first
                let location = touch?.location(in: self.view)
                
                let cardView  = allPlayerPlayedCards?[selectedCardForAttack!] as! UIView
                cardView.frame = CGRect(x: (location?.x)! - (cardView.frame.size.width / 2), y: (location?.y)!, width: (cardView.frame.size.width), height: (cardView.frame.size.height))
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if !isAttacking!
        {
            if selectedCardForAttack! <= 5
            {
                let touch = touches.first
                let location = touch?.location(in: self.view)
                
                if AIView.frame.contains(location!)
                {
                    let cardView  = allPlayerPlayedCards?[selectedCardForAttack!] as! UIView
                    isAttacking = true
                    viewModel?.PerformCardToAvatarAttackAnimation(cardView: cardView, toView: AIView, cardIndex: selectedCardForAttack!)
                }
                else
                {
                    var isIntersecting : Bool = false;
                    
                    for (index,_) in (allAIPlayedCards?.enumerated())!
                    {
                        let card = allAIPlayedCards?[index] as! UIView
                        if (card.frame.contains(location!))
                        {
                            //ADD TARGET TO PERFORM CARD ATTACK as PARAMETER
                            isAttacking = true
                            isIntersecting = true;
                            let cardView  = allPlayerPlayedCards?[selectedCardForAttack!] as! UIView
                            viewModel?.PerformCardToCardAttackAnimation(cardView: cardView, toView: card, attackCardIndex: selectedCardForAttack!, defendCardIndex: index)
                        }
                    }
                    
                    if !isIntersecting
                    {
                        isAttacking = false
                        let cardView  = allPlayerPlayedCards?[selectedCardForAttack!] as! UIView
                        viewModel?.PerformBackToPlaceAnimation(cardView: cardView, toFrame: (viewModel?.originalCardViewFrame)!)
                    }
                }
            }
            else
            {
                isAttacking = false
            }
        }
    }
    
    //MARK: - Delegates
    
    func reloadAllViewData()
    {
        isAttacking = false
        selectedCardForAttack = 99
        configureAllViews()
        createInPlayCardForPlayerView()
        createInPlayCardForAIView()
    }
    
    func attackPlayerCard(fromIndex : Int, toIndex : Int)
    {
        let PLCardView  = allPlayerPlayedCards?[toIndex] as! UIView
        let AICardView  = allAIPlayedCards?[fromIndex] as! UIView
        
        isAttacking = true
        viewModel?.PerformCardToCardAttackAnimation(cardView: AICardView, toView: PLCardView, attackCardIndex: fromIndex, defendCardIndex: toIndex)
    }
    
    func attackPlayerAvatar(fromIndex : Int)
    {
        let AICardView  = allAIPlayedCards?[fromIndex] as! UIView
        
        isAttacking = true
        viewModel?.PerformCardToAvatarAttackAnimation(cardView: AICardView, toView: playerView, cardIndex: fromIndex)
    }
}


