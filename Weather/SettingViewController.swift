//
//  SettingViewController.swift
//  Weather
//
//  Created by Martin Holla on 14/03/15.
//  Copyright (c) 2015 Martin Holla. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    

    @IBOutlet weak var lenghtUnitButton: UIButton!
    
    @IBOutlet weak var temperatureUnitButton: UIButton!
    
    @IBAction func unitOfLengthClicked(sender: AnyObject) {
        // changing unit from metres into miles and vice versa
        StoredData.sharedInstance.unitLengthAreMeters! = !StoredData.sharedInstance.unitLengthAreMeters!
        setTexts()
    }
    
    @IBAction func unitOfTemperatureClicked(sender: AnyObject) {
        // changing unit from ceslius into fahrenheit and vice versa
        StoredData.sharedInstance.unitTemperatureAreCelsius! = !StoredData.sharedInstance.unitTemperatureAreCelsius!
        setTexts()
    }
    
    func setTexts()
    {
        // setting of texts on buttons
        lenghtUnitButton.setTitle((StoredData.sharedInstance.unitLengthAreMeters! ? "Meters" : "Miles"), forState: UIControlState.Normal)
        
        temperatureUnitButton.setTitle(StoredData.sharedInstance.unitTemperatureAreCelsius! ? "Celsius" : "Fahrenheit", forState: UIControlState.Normal)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // setting of texts on buttons
        setTexts()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        uiNeedsRefresh = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}