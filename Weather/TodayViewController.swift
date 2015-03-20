//
//  ViewController.swift
//  Weather
//
//  Created by Martin Holla on 11/03/15.
//  Copyright (c) 2015 Martin Holla. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "meteoDataArrived:", name: meteoDataArrivedKey, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func LocationClick(sender: AnyObject) {
    }
    
    @IBAction func locationIsDone(segue:UIStoryboardSegue) {
        
    }

    @IBAction func refresh(sender: AnyObject) {
        var meteoData = MeteoData();
        var str = meteoData.GetData("Prague", numOfDays:5)
    }
    
    func meteoDataArrived(notification: NSNotification) {
        var meteoData: MeteoData = notification.object as MeteoData
        
        var temperature = StoredData.sharedInstance.unitTemperatureAreCelsius! ? meteoData.actualWeather!.temperatureC : meteoData.actualWeather!.temperatureF
        
        // setting of meteo data to visual components
        dispatch_async(dispatch_get_main_queue()) {
            var text = "\(temperature)"
            if StoredData.sharedInstance.unitTemperatureAreCelsius! {
                text += "\u{00B0}C"
            }
            else{
                text += "\u{00B0}F"
            }
            text += " \(meteoData.actualWeather!.weatherDesc)"
            self.todayWeather.text = text
            
            // setting of picture
            var ImageName = ""
            switch meteoData.actualWeather!.weatherDesc {
                case "Cloudy": ImageName = "Cloudy_Big"
                case "Windy": ImageName = "WInd_Big"
                case "Lightning": ImageName = "Lightning_Big"
            default: ImageName="Sun_Big"
            }
            
            ImageName += ".png"
            self.weatherImage.image = UIImage(named:ImageName)
            
            self.place.text = meteoData.city!
            self.chanceOfRain.text = "\(meteoData.forecasts![0].chanceOfRain)"
            self.precipitation.text = "\(meteoData.forecasts![0].precipitationMM) mm"
            self.pressure.text = "\(meteoData.actualWeather!.pressure)"
            self.windSpeed.text = (StoredData.sharedInstance.unitLengthAreMeters!) ? "\(meteoData.actualWeather!.windSpeedKM)" : "\(meteoData.actualWeather!.windSpeedMiles)"
            self.winddir16Point.text = meteoData.actualWeather!.windDir16Point
        }
    }
    

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var todayWeather: UILabel!    
    @IBOutlet weak var chanceOfRain: UILabel!
    @IBOutlet weak var precipitation: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var winddir16Point: UILabel!
}

