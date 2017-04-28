//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Hayden Goldman on 4/27/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.
//

import WatchKit
import Foundation
import MapKit


class InterfaceController: WKInterfaceController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var locations = [Location]()

    @IBOutlet var tacoImage: WKInterfaceImage!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        self.locations.removeAll()
        
        self.tacoImage.stopAnimating()
        self.tacoImage.setImageNamed("frame_1")
    }
    
    @IBAction func tacoTap(_ sender: Any) {
        
        print("taco has been tapped")
        self.tacoAnimationWithResults()
        
    }
    
    func tacoAnimationWithResults() {
        self.tacoImage.setImageNamed("frame_")
        self.tacoImage.startAnimatingWithImages(in: NSMakeRange(0, 30), duration: 1, repeatCount: -1)
        DispatchQueue.global().async {
            
            self.getGoogleData()
            sleep(7)
            
            DispatchQueue.main.async {
                self.tacoImage.stopAnimating()
                self.presentAlerts()
                
                
            }
        }
    }
    
    func presentAlerts() {
        
        if self.locations.count == 0 {
            
            let cancelAction = WKAlertAction(title: "Dismiss", style: .default) {
            
                self.locations.removeAll()
            }
            
            self.presentAlert(withTitle: "No Taco Found", message: "☹️", preferredStyle: .actionSheet, actions: [cancelAction])
            
        } else {
            
            let closestTaco = self.locations[0]
            
            guard let distance = closestTaco.distanceFromUser else {
            
                return
            }
            
            let distanceInMiles = String(format: "%.2f", distance / 1609.34)
            
            let action1 = WKAlertAction(title: "Directions", style: .default) {
            
                print("ok")
            }
            let cancelAction = WKAlertAction(title: "🚫", style: .cancel) {
                self.locations.removeAll()
            }

            self.presentAlert(withTitle: "Taco Found!", message: "Closest Taco: \n \(closestTaco.name!) \n \(distanceInMiles) miles away", preferredStyle: .actionSheet, actions: [action1,cancelAction])

        }
   
    }
    

    
    func getGoogleData() {
        
        self.locations.removeAll()
        
        guard let lat = self.locationManager.location?.coordinate.latitude else {
            return
        }
        
        guard let lng = self.locationManager.location?.coordinate.longitude else {
            return
        }
        
        let headers = [
            "cache-control": "no-cache",
            ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat)%2C\(lng)%0A&radius=2000&type=resturant&keyword=taco&pagetoken&key=AIzaSyBbvw_RKKdzBigdZGjXTJZjgC3IMJVV6rU")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!)
            }
            
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
            
            let results = json["results"] as! [[String:Any]]
            
            for item in results {
                
                let geometry = item["geometry"] as! [String:Any]
                let location = geometry["location"] as! [String:Any]
                
                let name = item["name"] as? String
                let locationLat = location["lat"] as? Double
                let locationLng = location["lng"] as? Double
                let place_id = item["place_id"] as? String
                let price_level = item["price_level"] as? Int
                let rating = item["rating"] as? Double
                let vicinity = item["vicinity"] as? String
                
                let itemLocation = Location()
                
                if let opening_hours = item["opening_hours"] {
                    let openingHours = opening_hours as! [String:Any]
                    if let open_now = openingHours["open_now"] {
                        itemLocation.open_now = open_now as? Bool
                    }
                }
                
                itemLocation.locationLat = locationLat
                itemLocation.locationLng = locationLng
                itemLocation.name = name
                itemLocation.place_id = place_id
                itemLocation.price_level = price_level
                itemLocation.rating = rating
                itemLocation.vicinity = vicinity
                
                self.locations.append(itemLocation)
            }
            
            print(self.locations.count)
            self.findClosestTaco()
        })
        dataTask.resume()
    }
    
    //Finding the location that is closest to the user
    func findClosestTaco() {
        
        var distances = [Double]()
        //looping to get all the location distance from user
        for location in self.locations {
            let distance = self.locationManager.location?.distance(from: CLLocation(latitude: CLLocationDegrees(location.locationLat!), longitude: CLLocationDegrees(location.locationLng!)))
            location.distanceFromUser = distance as Double!
            distances.append(distance!)
        }
        self.locations.sort(by: {$0.distanceFromUser! < $1.distanceFromUser!})
    }


}
