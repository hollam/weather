//
//  MeteoData.swift
//  Weather
//
//  Created by Martin Holla on 15/03/15.
//  Copyright (c) 2015 Martin Holla. All rights reserved.
//

import Foundation
import UIKit

// class for getting of meteo data

let meteoDataArrivedKey = "MeteoDataArrived"

class MeteoDataSet
{

    var temperatureC: Int
    var temperatureF: Int
    var windSpeedKM: Int
    var windSpeedMiles: Int
    var precipitationMM: String
    var windDir16Point: String
    var pressure: Int
    var chanceOfRain: Int
    var date: NSDate?
    var weatherDesc: String
    
    init()
    {
        temperatureC = 0
        temperatureF = 0
        windSpeedKM = 0
        windSpeedMiles = 0
        precipitationMM = ""
        windDir16Point = ""
        pressure = 0
        weatherDesc = ""
        chanceOfRain = 0
    }
}

class MeteoData {
    var city: String?
    var actualWeather: MeteoDataSet?
    var forecasts: [MeteoDataSet]?  // forecast is get as a forecast for a noon - middle of the day
    
    
    // function fills actualWeather and array forecastForTime (if succeeds)
    func GetData(location:String, numOfDays: Int) -> Bool {
        // numOfDays shouldn't exceed 5 for free version of API
        var nDays = numOfDays
        if ( nDays > 5 ){
            nDays = 5
        }
        
        var res: Bool = false
        
        self.city = location
        
        // key for meteo API
        //let meteoApiKey = "aa470060a2c7dd91957dbf0d0deee" // premium key
        let meteoApiKey = "6f31aa947553653df92cb124355e8"  // free key
        
        var url: NSURL!
        url = NSURL(string: "http://api2.worldweatheronline.com/free/v2/weather.ashx?key=\(meteoApiKey)&q=\(location)&num_of_days=\(nDays)&format=json")

        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            println("response = \(response)")
            
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("responseString = \(responseString)")
            
            var err: NSError?

             var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            
            if (err != nil) {
                println("JSON Error \(err!.localizedDescription)")
            }

            if let data = jsonResult["data"] as? NSDictionary {
                if let currentCondition = data["current_condition"] as? NSArray {
                    if let curCondDict = currentCondition[0] as? NSDictionary {
                        let tempC = curCondDict["temp_C"] as NSString;
                        let tempF = curCondDict["temp_F"] as NSString;
                        let windSpeedKM = curCondDict["windspeedKmph"] as NSString;
                        let windSpeedMiles = curCondDict["windspeedMiles"] as NSString;
                        let windDir16Point = curCondDict["winddir16Point"] as NSString;
                        let pressure = curCondDict["pressure"] as NSString;
                        let chanceOfRain = curCondDict["chanceofrain"] as NSString?
                        
                        // setting of result structure
                        self.actualWeather = MeteoDataSet()
                        self.actualWeather!.temperatureC = (tempC as String).toInt()!
                        self.actualWeather!.temperatureF = (tempF as String).toInt()!
                        self.actualWeather!.windSpeedKM = (windSpeedKM as String).toInt()!
                        self.actualWeather!.windSpeedMiles = (windSpeedMiles as String).toInt()!
                        self.actualWeather!.windDir16Point = (windDir16Point as String)
                        self.actualWeather!.pressure = (pressure as String).toInt()!
                        let chanceOfRainInt = (chanceOfRain as? String) == nil ? 0 : (chanceOfRain as String).toInt()!
                        self.actualWeather!.chanceOfRain = chanceOfRainInt
                        self.actualWeather!.weatherDesc = ((curCondDict["weatherDesc"] as NSArray!)[0] as NSDictionary)["value"] as NSString
                    }
                }
            }
            
            // getting of forecast data
            if let data = jsonResult["data"] as? NSDictionary {
                if let weather = data["weather"] as? NSArray {
                    for i in 0...weather.count-1 {
                        if let dayWeather = weather[i] as? NSDictionary {
                            if let hourly = dayWeather["hourly"] as? NSArray{
                                let noonIndex = hourly.count/2
                                    if let hourlyWeather = hourly[noonIndex] as? NSDictionary {
                                        // getting of weather during day - it i
                            
                            
                                        let tempC = hourlyWeather["tempC"] as NSString
                                        let tempF = hourlyWeather["tempF"] as NSString
                                        let windSpeedKM = hourlyWeather["windspeedKmph"] as NSString
                                        let windSpeedMiles = hourlyWeather["windspeedMiles"] as NSString
                                        let windDir16Point = hourlyWeather["winddir16Point"] as NSString
                                        let pressure = hourlyWeather["pressure"] as NSString
                                        let chanceOfRain = hourlyWeather["chanceofrain"] as NSString?
                                        let time = hourlyWeather["time"] as NSString
                                        var precipMM = hourlyWeather["precipMM"] as NSString?
                                        if precipMM == nil {
                                            precipMM = hourlyWeather["precipitationMM"] as NSString?
                                        }
                        
                                        var weatherInTime = MeteoDataSet()
                        
                                        // setting of result structure
                                        weatherInTime = MeteoDataSet()
                                        weatherInTime.temperatureC = (tempC as String).toInt()!
                                        weatherInTime.temperatureF = (tempF as String).toInt()!
                                        weatherInTime.windSpeedKM = (windSpeedKM as String).toInt()!
                                        weatherInTime.windSpeedMiles = (windSpeedMiles as String).toInt()!
                                        weatherInTime.windDir16Point = (windDir16Point as String)
                                        weatherInTime.pressure = (pressure as String).toInt()!
                                        weatherInTime.chanceOfRain = (chanceOfRain as String).toInt()!
                                        weatherInTime.precipitationMM = (precipMM as String)
                                        let wDescArr = hourlyWeather["weatherDesc"] as NSArray!
                                        weatherInTime.weatherDesc = ((hourlyWeather["weatherDesc"] as NSArray!)[0] as NSDictionary)["value"] as NSString
                                        
                                        let date = dayWeather["date"] as? NSString
                                        // conversion into date	
                                        
                                        let dateFormatter = NSDateFormatter()
                                        dateFormatter.dateFormat = 	"yyyy-MM-dd"
                                        weatherInTime.date = dateFormatter.dateFromString(date!)!
                                        //weatherInTime.date
                                        
                                        if self.forecasts != nil
                                        {
                                            self.forecasts!.append(weatherInTime)
                                        }
                                        else
                                        {
                                            self.forecasts = [];
                                            self.forecasts!.append(weatherInTime)
                                            
                                        }
                                        
                                    
                                }
                            }
                        }
                    }
                }
            }

            
            // sending of notification about recieved answer from meteo server
            NSNotificationCenter.defaultCenter().postNotificationName(meteoDataArrivedKey, object: self)
            
            
            
            //let data = responseString!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)

            
        }
        task.resume()
        
//        let urlSession = NSURLSession.sharedSession()
//        
//        
//        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
//            if (error != nil) {
//                println(error.localizedDescription)
//            }
//            var err: NSError?
//            
//            // 3
//            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
//            
//            if (err != nil) {
//                println("JSON Error \(err!.localizedDescription)")
//            }
//            
//            // 4
//            let jsonDate: String! = jsonResult["date"] as NSString
//            let jsonTime: String! = jsonResult["time"] as NSString
//            
//            //dispatch_async(dispatch_get_main_queue(), {
//            //    dateLabel.text = jsonDate
//            //    timeLabel.text = jsonTime
//            //})
//        })
//        // 5
//        jsonQuery.resume()
    
    

        
        // zxc some parsing of response
        return res
        
    }
    

    init () {
        self.actualWeather = nil
    }


}
