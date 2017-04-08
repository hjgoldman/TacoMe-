//
//  TacoMeViewController.swift
//  TacoMe!
//
//  Created by Hayden Goldman on 3/20/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.
//

import UIKit
import MapKit
import RandomColorSwift

class TacoMeViewController: UIViewController, CLLocationManagerDelegate, UIViewControllerTransitioningDelegate {
    
    var locationManager = CLLocationManager()
    var tacoLocations = [TacoLocation]()
    var fadeTransition = FadeTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.view.backgroundColor = randomColor(hue: .random, luminosity: .light)
        self.getGoogleData()
        
        //
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    
    @IBAction func getTacoButtonPressed(_ sender: Any) {

        let closestTaco = self.tacoLocations[0] 
        
        guard let distance = closestTaco.distanceFromUser else {
            return
        }
        
        let distanceInMiles = String(format: "%.2f", distance / 1609.34)
        
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Tacos Found!  🌮", message:  "\(closestTaco.name!): \(distanceInMiles) miles away", preferredStyle: .alert)
        
        // Create the actions
        let getTacoAction = UIAlertAction(title: "Get Directions", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            let url  = NSURL(string: "http://maps.apple.com/?q=\(String(describing: closestTaco.locationLat)),\(String(describing: closestTaco.locationLng))")

            if UIApplication.shared.canOpenURL(url! as URL) == true {
                UIApplication.shared.open(url! as URL)
                
            }
        }
        let moreTacoAction = UIAlertAction(title: "More Tacos", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            self.performSegue(withIdentifier: "GoogleMapsSegue", sender: self)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
        }
        
        // Add the actions
        alertController.addAction(getTacoAction)
        alertController.addAction(moreTacoAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        

 
    }

    
    //Custom segue 
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return nil
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return self.fadeTransition
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "GoogleMapsSegue" {
            
            let navController = segue.destination as! UINavigationController
            let mapVC = navController.topViewController as! GoogleMapsViewController
            mapVC.tacoLocations = self.tacoLocations
            
            navController.transitioningDelegate = self
            
        }
        
    }
    
    //Mark: API GET request
   
    func getGoogleData() {
        
        guard let lat = self.locationManager.location?.coordinate.latitude else {
            return
        }
        
        guard let lng = self.locationManager.location?.coordinate.longitude else {
            return
        }
        
        let headers = [
            "cache-control": "no-cache",
            ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat)%2C\(lng)%0A&radius=3218.69&keyword=mexican&pagetoken&key=AIzaSyBbvw_RKKdzBigdZGjXTJZjgC3IMJVV6rU")! as URL,
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
 //               let opening_hours = item["opening_hours"] as! [String:Any]
                
                let name = item["name"] as? String
                let locationLat = location["lat"] as? Double
                let locationLng = location["lng"] as? Double
                let place_id = item["place_id"] as? String
                let price_level = item["price_level"] as? Int
                let rating = item["rating"] as? Double
                let vicinity = item["vicinity"] as? String
                
                let tacoLocation = TacoLocation()
                
                if let opening_hours = item["opening_hours"] {
                    let openingHours = opening_hours as! [String:Any]
                    if let open_now = openingHours["open_now"] {
                        tacoLocation.open_now = open_now as? Bool
                    }
                }

//                if let open_now = opening_hours["open_now"] {
//                    tacoLocation.open_now = open_now as? Bool
//                }
                
                tacoLocation.locationLat = locationLat
                tacoLocation.locationLng = locationLng
                tacoLocation.name = name
                tacoLocation.place_id = place_id
                tacoLocation.price_level = price_level
                tacoLocation.rating = rating
                tacoLocation.vicinity = vicinity
                
                self.tacoLocations.append(tacoLocation)
                
            }
            
            print(self.tacoLocations.count)
            self.findClosestTaco()
        })
        
        dataTask.resume()
    }
    
    //Finding the location that is closest to the user
    func findClosestTaco() {
        
        var distances = [Double]()
        //looping to get all the location distance from user
        for location in self.tacoLocations {
            let distance = self.locationManager.location?.distance(from: CLLocation(latitude: CLLocationDegrees(location.locationLat!), longitude: CLLocationDegrees(location.locationLng!)))
            location.distanceFromUser = distance as Double!
            distances.append(distance!)
        }
        self.tacoLocations.sort(by: {$0.distanceFromUser! < $1.distanceFromUser!})
    }

    
    
    
}
