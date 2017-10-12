//
//  ViewController.swift
//  Airports
//
//  Created by Joep on 24-09-17.
//  Copyright © 2017 Joep. All rights reserved.
//

import UIKit
import SQLite


class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apdbhelper = AirportDatabaseHelper()
        
        for airport in apdbhelper.getAllAirports() {
            
            print(airport.name)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

