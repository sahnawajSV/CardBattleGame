//
//  DeckListViewController.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 14/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class DeckListViewController: UIViewController {
  
  fileprivate let identifier = "CellIdentifier"
  
  @IBOutlet weak var deckCollectionView: UICollectionView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.deckCollectionView.delegate = self
    self.deckCollectionView.dataSource = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  // MARK: - Navigation
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    
  }
  
  
  /// Back Action
  @IBAction func backAction(_ sender: Any) {
    self.navigationController!.popViewController(animated: true)
    
  }
  
  
}


extension DeckListViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
  
  
  
  // MARK:- UICollectionView DataSource
  
  // Collection View - Number Of Items In Section
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return ServiceManager.sharedInstance.numbeOfCards()
  }
  
  /// Collection View - Cell For Row At Index Path
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! DeckCollectionViewCell
    
    
    let cardList: [Card] = ServiceManager.sharedInstance.fetchCardList()
    let card = cardList[indexPath.row]
    
    
    cell.attackLbl.text = String(describing: card.attack)
    cell.healthLbl.text = String(describing: card.health)
    cell.battlePointLbl.text = String(describing: card.battlepoint)
    cell.nameLbl.text = String(describing: card.name)
    
    print(card.name)
    
    return cell
  }
  
  
  
  
  // MARK:- UICollectionViewDelegate Methods
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    highlightCell(indexPath, flag: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    highlightCell(indexPath, flag: false)
  }
  
  // MARK:- UICollectioViewDelegateFlowLayout methods
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
  {
    let length = (UIScreen.main.bounds.width-4)/3
    return CGSize(width: length,height: length);
  }
  
  
  // MARK:- Highlight
  func highlightCell(_ indexPath : IndexPath, flag: Bool) {
    
    let cell = deckCollectionView.cellForItem(at: indexPath)
    
    if flag {
      cell?.contentView.backgroundColor = UIColor.orange
    } else {
      cell?.contentView.backgroundColor = nil
    }
  }
  
}
