//
//  MoreInfoViewController.swift
//  TacoMe!
//
//  Created by Hayden Goldman on 4/5/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.
//

import UIKit

class MoreInfoViewController: UIViewController {
    
    var tacoLocationPlace_id :String!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        print(self.tacoLocationPlace_id)
        self.getLocationDetails()

    }


    func getLocationDetails() {
        
        let headers = [
            "cache-control": "no-cache",
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(self.tacoLocationPlace_id!)&key=AIzaSyA3RhbSXz2Enph92mEeehvXogH8cDg5VGQ")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in

            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
            
            let result = json["result"] as! [String:Any]
            
            let formatted_address = result["formatted_address"] // capture this
            
            
            
            
            

        })
        
        dataTask.resume()
        
        
    }

}
