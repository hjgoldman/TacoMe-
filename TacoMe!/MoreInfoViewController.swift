//
//  MoreInfoViewController.swift
//  TacoMe!
//
//  Created by Hayden Goldman on 4/5/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.
//

import UIKit
import RandomColorSwift

class MoreInfoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var isOpenLabel: UILabel!
    
    var tacoLocationDetail = TacoLocationDetail()
    var tacoLocationPlace_id :String!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = randomColor(hue: .random, luminosity: .light)
        
        print(self.tacoLocationPlace_id)
        self.getLocationDetails()
        
    }

    
    func populateView() {
        
        self.nameLabel.text = self.tacoLocationDetail.name
        self.addressLabel.text = self.tacoLocationDetail.formatted_address
        self.phoneLabel.text = self.tacoLocationDetail.formatted_phone_number
        
        if self.tacoLocationDetail.open_now == true {
            self.isOpenLabel.text = "Open"
            self.isOpenLabel.textColor = UIColor.green
        } else if self.tacoLocationDetail.open_now == false {
            self.isOpenLabel.text = "Closed"
            self.isOpenLabel.textColor = UIColor.red
        } else {
            self.isOpenLabel.text = ""
        }
        
        if self.tacoLocationDetail.rating! >= 0.0 && self.tacoLocationDetail.rating! < 0.5 {
            self.imageView.image = UIImage(named: "0_stars.png")
        } else if self.tacoLocationDetail.rating! >= 0.5 && self.tacoLocationDetail.rating! < 1.0 {
            self.imageView.image = UIImage(named: "0_5_stars.png")
        } else if self.tacoLocationDetail.rating! >= 1.0 && self.tacoLocationDetail.rating! < 1.5 {
            self.imageView.image = UIImage(named: "1_stars.png")
        } else if self.tacoLocationDetail.rating! >= 1.5 && self.tacoLocationDetail.rating! < 2.0 {
            self.imageView.image = UIImage(named: "1_5_stars.png")
        } else if self.tacoLocationDetail.rating! >= 2.0 && self.tacoLocationDetail.rating! < 2.5 {
            self.imageView.image = UIImage(named: "2_stars.png")
        } else if self.tacoLocationDetail.rating! >= 2.5 && self.tacoLocationDetail.rating! < 3.0 {
            self.imageView.image = UIImage(named: "2_5_stars.png")
        } else if self.tacoLocationDetail.rating! >= 3.0 && self.tacoLocationDetail.rating! < 3.5 {
            self.imageView.image = UIImage(named: "3_stars.png")
        } else if self.tacoLocationDetail.rating! >= 3.5 && self.tacoLocationDetail.rating! < 4.0 {
            self.imageView.image = UIImage(named: "3_5_stars.png")
        } else if self.tacoLocationDetail.rating! >= 4.0 && self.tacoLocationDetail.rating! < 4.5 {
            self.imageView.image = UIImage(named: "4_stars.png")
        } else if self.tacoLocationDetail.rating! >= 4.5 && self.tacoLocationDetail.rating! < 5.0 {
            self.imageView.image = UIImage(named: "4_5_stars.png")
        } else if self.tacoLocationDetail.rating! == 5.0 {
            self.imageView.image = UIImage(named: "5_stars.png")
        } else if self.tacoLocationDetail.rating == nil {
            
        }
    
        
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
            
            print(result)
            
            let geometry = result["geometry"] as! [String:Any]
            let location = geometry["location"] as! [String:Any]
            let opening_hours = result["opening_hours"] as! [String:Any]
            
            
            
            
            guard let formatted_address = result["formatted_address"] as? String,
                let formatted_phone_number = result["formatted_phone_number"] as? String,
                let lat = location["lat"] as? Double,
                let lng = location["lng"] as? Double,
                let name = result["name"] as? String,
                let weekday_text = opening_hours["weekday_text"] as? [String],
                let rating = result["rating"] as? Double,
                let url = result["url"] as? String
                else {
                    return
            }
            
            
            if let open_now = opening_hours["open_now"] {
                 self.tacoLocationDetail.open_now = open_now as? Bool 
            }
            
            if let website = result["website"] {
                self.tacoLocationDetail.website = website as? String
            }
            
            if let price_level = result["price_level"] {
                self.tacoLocationDetail.price_level = price_level as? Double
            }
            
            
            self.tacoLocationDetail.formatted_address = formatted_address
            self.tacoLocationDetail.formatted_phone_number = formatted_phone_number
            self.tacoLocationDetail.lat = lat
            self.tacoLocationDetail.lng = lng
            self.tacoLocationDetail.name = name
           
            self.tacoLocationDetail.weekday_text = weekday_text
            self.tacoLocationDetail.rating = rating
            self.tacoLocationDetail.url = url
            
            DispatchQueue.main.async {
                self.populateView()
            }
        })
        dataTask.resume()
        
    }

}
