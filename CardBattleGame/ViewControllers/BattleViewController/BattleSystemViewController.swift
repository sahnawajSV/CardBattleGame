//
//  BattleSystemViewController.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 19/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class BattleSystemViewController: UIViewController, GameDelegate
{
    //MARK: - Internal Variables
    var gManager: GameManager?
    
    //MARK: - View Collection
    var allPlayerHandCards: Array<CardView> = Array<CardView>()
    var allAIHandCards: Array<CardView> = Array<CardView>()
    
    //MARK: - Storyboard Connections
    @IBOutlet private weak var playerInDeckText: UILabel!
    @IBOutlet private weak var playerBattlePointText: UILabel!
    @IBOutlet private weak var playerNameText: UILabel!
    @IBOutlet private weak var playerHealthText: UILabel!
    
    @IBOutlet private weak var aiInDeckText: UILabel!
    @IBOutlet private weak var aiBattlePointText: UILabel!
    @IBOutlet private weak var aiNameText: UILabel!
    @IBOutlet private weak var aiHealthText: UILabel!
    
    @IBOutlet private weak var playerView: UIView!
    @IBOutlet private weak var playerDeckView: UIView!
    
    @IBOutlet private weak var aiView: UIView!
    @IBOutlet private weak var aiDeckView: UIView!
    
    //InHand Player Cards
    @IBOutlet private weak var ih_player_cardOne: UIView!
    @IBOutlet private weak var ih_player_cardTwo: UIView!
    @IBOutlet private weak var ih_player_cardThree: UIView!
    @IBOutlet private weak var ih_player_cardFour: UIView!
    @IBOutlet private weak var ih_player_cardFive: UIView!
    
    //InHand AI Cards
    @IBOutlet private weak var ih_ai_cardOne: UIView!
    @IBOutlet private weak var ih_ai_cardTwo: UIView!
    @IBOutlet private weak var ih_ai_cardThree: UIView!
    @IBOutlet private weak var ih_ai_cardFour: UIView!
    @IBOutlet private weak var ih_ai_cardFive: UIView!
    
    //InPlay Player Cards
    @IBOutlet private weak var ip_player_cardOne: UIView!
    @IBOutlet private weak var ip_player_cardTwo: UIView!
    @IBOutlet private weak var ip_player_cardThree: UIView!
    @IBOutlet private weak var ip_player_cardFour: UIView!
    @IBOutlet private weak var ip_player_cardFive: UIView!
    
    //InPlay AI Cards
    @IBOutlet private weak var ip_ai_cardOne: UIView!
    @IBOutlet private weak var ip_ai_cardTwo: UIView!
    @IBOutlet private weak var ip_ai_cardThree: UIView!
    @IBOutlet private weak var ip_ai_cardFour: UIView!
    @IBOutlet private weak var ip_ai_cardFive: UIView!
    
    //MARK: - Gameplay Variables
    //To be used to find the card in the hand that is currently held down by Touch Began and Moved
    var selectedIndexToPlay = 99

    //MARK: - View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Assign View Model and Call Initializers
        gManager = GameManager()
        gManager?.delegate = self;
        gManager?.initializeTheGame()
        
        setupCardBackground()
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
    
    //MARK: - Card BG Creator
    func setupCardBackground()
    {
        ih_player_cardOne.dropShadow(scale: true)
        ih_player_cardTwo.dropShadow(scale: true)
        ih_player_cardThree.dropShadow(scale: true)
        ih_player_cardFour.dropShadow(scale: true)
        ih_player_cardFive.dropShadow(scale: true)
        
        ih_ai_cardOne.dropShadow(scale: true)
        ih_ai_cardTwo.dropShadow(scale: true)
        ih_ai_cardThree.dropShadow(scale: true)
        ih_ai_cardFour.dropShadow(scale: true)
        ih_ai_cardFive.dropShadow(scale: true)
        
        ip_player_cardOne.dropShadow(scale: true)
        ip_player_cardTwo.dropShadow(scale: true)
        ip_player_cardThree.dropShadow(scale: true)
        ip_player_cardFour.dropShadow(scale: true)
        ip_player_cardFive.dropShadow(scale: true)
        
        ip_ai_cardOne.dropShadow(scale: true)
        ip_ai_cardTwo.dropShadow(scale: true)
        ip_ai_cardThree.dropShadow(scale: true)
        ip_ai_cardFour.dropShadow(scale: true)
        ip_ai_cardFive.dropShadow(scale: true)
    }
    
    //MARK: - Create In Hand Cards
    func createInHandCardForPlayerView()
    {
        guard gManager != nil else
        {
            return
        }
        
        if (allPlayerHandCards.count) > 0
        {
            for (index,_) in (allPlayerHandCards.enumerated())
            {
                let cardView = allPlayerHandCards[index]
                cardView.removeFromSuperview()
            }
        }
        
        allPlayerHandCards.removeAll()
        
        for (index,_) in (gManager?.playerStats?.gameStats?.inHand?.enumerated())!
        {
            let card = gManager?.playerStats?.gameStats?.inHand?[index]
            
            var cardFrame: CGRect?
            
            switch index
            {
            case 0:
                cardFrame = ih_player_cardOne.frame
            case 1:
                cardFrame = ih_player_cardTwo.frame
            case 2:
                cardFrame = ih_player_cardThree.frame
            case 3:
                cardFrame = ih_player_cardFour.frame
            case 4:
                cardFrame = ih_player_cardFive.frame
            default:
                cardFrame = ih_player_cardOne.frame
            }
            
            let cardView : CardView = CardView(frame: cardFrame!)
            
            cardView.bpText?.text = card?.battlepoint
            cardView.attackText?.text = card?.attack
            cardView.healthText?.text = card?.health
            cardView.nameText?.text = card?.name
            
            self.view.addSubview(cardView)
            allPlayerHandCards.append(cardView)
            self.view.bringSubview(toFront: playerView)
        }
    }
    
    func createInHandCardForAIView()
    {
        guard gManager != nil else
        {
            return
        }
        
        if (allAIHandCards.count) > 0
        {
            for (index,_) in (allAIHandCards.enumerated())
            {
                let cardView = allAIHandCards[index]
                cardView.removeFromSuperview()
            }
        }
        
        allAIHandCards.removeAll()
        
        for (index,_) in (gManager?.aiStats?.gameStats?.inHand?.enumerated())!
        {
            let card = gManager?.aiStats?.gameStats?.inHand?[index]
            
            var cardFrame: CGRect?
            
            switch index
            {
            case 0:
                cardFrame = ih_ai_cardOne.frame
            case 1:
                cardFrame = ih_ai_cardTwo.frame
            case 2:
                cardFrame = ih_ai_cardThree.frame
            case 3:
                cardFrame = ih_ai_cardFour.frame
            case 4:
                cardFrame = ih_ai_cardFive.frame
            default:
                cardFrame = ih_ai_cardOne.frame
            }
            
            let cardView : CardView = CardView(frame: cardFrame!)
            
            cardView.bpText?.text = card?.battlepoint
            cardView.attackText?.text = card?.attack
            cardView.healthText?.text = card?.health
            cardView.nameText?.text = card?.name
            
            self.view.addSubview(cardView)
            allAIHandCards.append(cardView)
            self.view.bringSubview(toFront: aiView)
        }
    }

    
    //MARK: - Action Methods
    @IBAction private func endTurnPressed(sender: UIButton)
    {
        gManager?.endTurn()
    }
    
    //MARK: - Delegates
    
    func initializationStatus(success : Bool)
    {
        if success
        {
            //Draw initial Cards
            gManager?.drawCardsFromDeck()
            reloadAllViews()
        }
        else
        {
            CBGErrorHandler.handle(error : .failedToIntializeTheGame)
        }
    }
    
    func reloadAllViews()
    {
        let playerStats = gManager?.playerStats
        let aiStats = gManager?.aiStats
        
        playerInDeckText.text = "\(String(describing: (playerStats?.gameStats?.inDeck!.count)!)) / \(Defaults.MAXIMUM_CARD_PER_DECK) Cards"
        aiInDeckText.text = "\(String(describing: (aiStats?.gameStats?.inDeck!.count)!)) / \(Defaults.MAXIMUM_CARD_PER_DECK) Cards"
        
        playerBattlePointText.text = "\(String(describing: playerStats?.gameStats?.battlePoints!)) / \(Defaults.MAXIMUM_BATTLE_POINTS) BP"
        aiBattlePointText.text = "\(String(describing: aiStats?.gameStats?.battlePoints!)) / \(Defaults.MAXIMUM_BATTLE_POINTS) BP"
        
        playerNameText.text = playerStats?.name
        aiNameText.text = aiStats?.name
        
        playerHealthText.text = playerStats?.gameStats?.health!
        aiHealthText.text = aiStats?.gameStats?.health!
        
        createInHandCardForPlayerView()
        createInHandCardForAIView()
    }
    
    
    //MARK: - TOUCH Actions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        let location = touch?.location(in: self.view)
        
        for (index,_) in (allPlayerHandCards.enumerated())
        {
            let card : CardView = allPlayerHandCards[index]
            if (card.frame.contains(location!))
            {
                selectedIndexToPlay = index
                break
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if selectedIndexToPlay <= 5
        {
            let touch = touches.first
            let location = touch?.location(in: self.view)
            
            let cardView : CardView  = allPlayerHandCards[selectedIndexToPlay]
            cardView.frame = CGRect(x: (location?.x)! - (cardView.frame.size.width / 2), y: (location?.y)!, width: (cardView.frame.size.width), height: (cardView.frame.size.height))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
            if selectedIndexToPlay <= 5
            {
                let touch = touches.first
                let location = touch?.location(in: self.view)
                
                var playAreaCardFrame : CGRect?
                var cardIndex : Int?
                
                for index in 0...4
                {
                    switch index {
                    case 0:
                        if (ip_player_cardOne.frame.contains(location!))
                        {
                            playAreaCardFrame = ip_player_cardOne.frame
                        }
                        break
                    case 1:
                        if (ip_player_cardTwo.frame.contains(location!))
                        {
                            playAreaCardFrame = ip_player_cardTwo.frame
                        }
                        break
                    case 2:
                        if (ip_player_cardThree.frame.contains(location!))
                        {
                            playAreaCardFrame = ip_player_cardThree.frame
                        }
                        break
                    case 3:
                        if (ip_player_cardFour.frame.contains(location!))
                        {
                            playAreaCardFrame = ip_player_cardFour.frame
                        }
                        break
                    case 4:
                        if (ip_player_cardFive.frame.contains(location!))
                        {
                            playAreaCardFrame = ip_player_cardFive.frame
                        }
                        break
                    default:
                        if (ip_player_cardOne.frame.contains(location!))
                        {
                            playAreaCardFrame = ip_player_cardOne.frame
                        }
                        break
                    }
                    
                    cardIndex = index
                }
                
                if (playAreaCardFrame != nil)
                {
                    let cardView : CardView  = allPlayerHandCards[selectedIndexToPlay]
                    gManager?.playCardToGameArea(cardView: cardView, toFrame: playAreaCardFrame!, cardIndex: cardIndex!, forPlayer: true)
                    
                    //Reset Index
                    selectedIndexToPlay = 99
                }
            }
        }


}
