//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Hayden Goldman on 4/27/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBOutlet var group: WKInterfaceGroup!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
//        self.group.setBackgroundColor(randomColor(hue: .random, luminosity: .light))
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    @IBAction func tacoButton() {
        
        print("taco pressed!")
    }

}
