//
//  MainMenuViewController.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 14/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit


/// MainMenuViewController : Card Battle Game Main Menu
class MainMenuViewController: UIViewController {
  
  var mainViewModel = MainMenuViewModel()
  
  @IBOutlet weak var deckBuilderButton: UIButton!
  @IBOutlet weak var battleButton: UIButton!
  @IBOutlet weak var timeZoneLbl: UILabel!
  @IBOutlet weak var dateTimeLbl: UILabel!
  @IBOutlet weak var summeryLbl: UILabel!
  @IBOutlet weak var weatherIcon: UIImageView!
  @IBOutlet weak var temperatureLbl: UILabel!
  @IBOutlet weak var windLbl: UILabel!
  @IBOutlet weak var weatherInfoView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Hide the Weather Info VIew
    //
    weatherInfoView.alpha = 0
    
    //Create Round Button
    deckBuilderButton.roundBorder(cornerRadius: 4.0, borderWidth: 2.0, borderColor: UIColor.white.cgColor)
    battleButton.roundBorder(cornerRadius: 4.0, borderWidth: 2.0, borderColor: UIColor.white.cgColor)
    
    // Set Main Model View Delegate
    mainViewModel.delegate = self
    // Request For Weather Data
    mainViewModel.fetchWeatherReport()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

extension MainMenuViewController : MainMenuViewModelDelegate{
  
  func updateWeatherData() {
    temperatureLbl.text = mainViewModel.temperatureText
    dateTimeLbl.text = mainViewModel.timeText
    timeZoneLbl.text = mainViewModel.timeZoneText
    summeryLbl.text = mainViewModel.summaryText
    windLbl.text = mainViewModel.windSpeedText
    weatherIcon.image = mainViewModel.iconImage
    
    weatherInfoView.fadeIn()
  }
}
