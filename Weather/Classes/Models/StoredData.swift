//
//  StoredData.swift
//  Weather
//
//  Created by Martin Holla on 15/03/15.
//  Copyright (c) 2015 Martin Holla. All rights reserved.
//

import Foundation



class StoredData
{
    // singleton for using one User data
    class var sharedInstance: StoredData {
        struct Static {
            static var instance: StoredData?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = StoredData()
        }
        
        return Static.instance!
    }

    var defaults=NSUserDefaults()
    
    private let celsius = "celsius"
    private let meters = "meters"
    private let cities = "cities"
    
    var unitLengthAreMeters: Bool? {
        didSet {
            if (unitLengthAreMeters != oldValue){
                defaults.setValue(unitLengthAreMeters, forKey: meters)
                defaults.synchronize()
            }
        }
    }
    
    var unitTemperatureAreCelsius: Bool? {
        didSet {
            if (unitTemperatureAreCelsius != oldValue){
                defaults.setValue(unitTemperatureAreCelsius, forKey: celsius)
                defaults.synchronize()
            }
        }
    }
    
    var citiesArray: [NSString]? { // NSString because problem with saving of array of String in NSUserDefaults
        didSet {
            if ((citiesArray != nil && oldValue == nil) || (oldValue != nil && citiesArray! != oldValue!) ) {
                defaults.setValue(citiesArray, forKey: cities)
                defaults.synchronize()
            }
        }
    }
    
    
    func LoadData()
    {
        // loading of data from User Defaults
        var defaults=NSUserDefaults()
        unitLengthAreMeters = defaults.objectForKey(meters) as Bool? ?? true
        unitTemperatureAreCelsius = defaults.objectForKey(celsius) as Bool? ?? true
        citiesArray = defaults.objectForKey(cities) as [NSString]?
        if ( citiesArray != nil )
        {
            // transform of NSArray to [string]
        }
        else
        {
            // some default cities
            citiesArray = ["Prague", "Paris", "Tokio, Japan", "San Francisco", "New York", "Barcelona"]
        }
        
        
        var len:Int = citiesArray?.count ?? 0
        var cit: [String] = [String]()
        for i in 0...len-1 {
            let str = citiesArray![i]
            cit.append(str)
        }
        //var cit: [String] = citiesArray
        
    }
    
    init()
    {
        LoadData()
    }
}
