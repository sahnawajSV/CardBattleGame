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
    @IBOutlet weak var tempratureLbl: UILabel!
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
   
    
    
    
    //  Mark :  Helper Method
    //
    func imageForWeatherIcon(withName name: String) -> UIImage? {
        
        switch name {
        case "clear-day":
            return UIImage(named: "clear-day")
        case "clear-night":
            return UIImage(named: "clear-night")
        case "rain":
            return UIImage(named: "rain")
        case "snow":
            return UIImage(named: "snow")
        case "sleet":
            return UIImage(named: "sleet")
        case "wind", "cloudy", "partly-cloudy-day", "partly-cloudy-night":
            return UIImage(named: "cloudy")
        default:
            return UIImage(named: "clear-day")
        }
    }
    
}


extension MainMenuViewController : MainMenuViewModelDelegate{
    
    func updateWeatherData() {
        
        if let min = mainViewModel.weatherData.minTemprature,  let max = mainViewModel.weatherData.maxTemprature{
            let min = String(format: "%.0f°", min)
            let max = String(format: "%.0f°", max)
            self.tempratureLbl.text = "\(min) - \(max)"
        }
        
        if let time = mainViewModel.weatherData.time {
            self.dateTimeLbl.text = time.toString(dateFormat: "dd MMM yy hh:mm")
        }

        if let timeZon = mainViewModel.weatherData.timeZone {
            self.timeZoneLbl.text = timeZon
        }
        
        if let summary = mainViewModel.weatherData.summary {
            self.summeryLbl.text = summary
        }
        
        if let windSp =  mainViewModel.weatherData.windSpeed {
            self.windLbl.text = String(format: "%.f KPH", windSp)
        }
        
        if let icon = mainViewModel.weatherData.icon {
            self.weatherIcon.image = imageForWeatherIcon(withName: icon)
        }
        
        self.weatherInfoView.fadeIn()
    }
}
