//
//  LocationViewController.swift
//  Weather
//
//  Created by Martin Holla on 13/03/15.
//  Copyright (c) 2015 Martin Holla. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        uiNeedsRefresh = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addLocationIsDone(segue:UIStoryboardSegue) {
        
    }
}
