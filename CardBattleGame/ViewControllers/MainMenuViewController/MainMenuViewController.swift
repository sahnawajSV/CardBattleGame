//
//  MainMenuViewController.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 14/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
  
  var mainViewModel = MainMenuViewModel()
  
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
    self.weatherInfoView.alpha = 0
    
    // Set Main MOdel View Delegate
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
    
    self.temperatureLbl.text = self.mainViewModel.temperatureText
    self.dateTimeLbl.text = self.mainViewModel.timeText
    self.timeZoneLbl.text = self.mainViewModel.timeZoneText
    self.summeryLbl.text = self.mainViewModel.summaryText
    self.windLbl.text = self.mainViewModel.windSpeedText
    self.weatherIcon.image = self.mainViewModel.iconImage
    
    self.weatherInfoView.fadeIn()
  }
}
