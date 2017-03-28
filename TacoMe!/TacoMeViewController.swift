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
    var closestTaco = TacoLocation()
    var fadeTransition = FadeTransition()
    var accessToken = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.view.backgroundColor = randomColor(hue: .random, luminosity: .light)
        
        self.getAuthToken()
    }
    
    private func getAuthToken() {
        
        let headers = [
            "content-type": "application/x-www-form-urlencoded",
            "cache-control": "no-cache",
            ]
        
        let postData = NSMutableData(data: "grant_type=client_credentials".data(using: String.Encoding.utf8)!)
        postData.append("&client_id=6YTmkfclSSWMdQq_sPr53w".data(using: String.Encoding.utf8)!)
        postData.append("&client_secret=cU9RcGq9Nnmp7oi8GGWPdV59oHRHSKIAHbqhSfHT7E6tmZTRwy30CJrpwX1sV4bY".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.yelp.com/oauth2/token")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!)
            }
            
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
            
            self.accessToken = json["access_token"] as! String!
        })
        
        dataTask.resume()
        
    }
    
    private func getYelpLocations() {
        
        let headers = [
            "authorization": "Bearer \(self.accessToken)",
            "cache-control": "no-cache",
            ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.yelp.com/v3/businesses/search?term=mexican&latitude=\((self.locationManager.location?.coordinate.latitude)!)&longitude=\((self.locationManager.location?.coordinate.longitude)!)")! as URL,
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
                        
            let businesses = json["businesses"] as! [[String:Any]]
            
            for business in businesses {
                
                let tacoLocation = TacoLocation()
                
                let name = business["name"] as! String
                tacoLocation.name = name
                
                let distance = business["distance"] as! Double
                tacoLocation.distance = distance
                
                let rating = business["rating"] as! Double
                tacoLocation.rating = rating
                
                let price = business["price"] as! String
                tacoLocation.price = price
                
                let locationInformation = business["location"] as! [String:Any]
                let address = locationInformation["display_address"] as! [String]
                tacoLocation.address = address
                
                let coordinates = business["coordinates"] as! [String:CLLocationDegrees]
                let latitude = coordinates["latitude"]
                let longitude = coordinates["longitude"]
                let coordinate = CLLocation(latitude: latitude!, longitude: longitude!)
                tacoLocation.coordinate = coordinate
                
                let isClosed = business["is_closed"] as! Bool
                tacoLocation.isClosed = isClosed
                
                let yelpUrl = business["url"] as! String
                tacoLocation.yelpUrl = yelpUrl
                
                self.tacoLocations.append(tacoLocation)
            }
            
        })
        
        dataTask.resume()
    }
    
    
    
    @IBAction func getTacoButtonPressed(_ sender: Any) {
        
        self.getYelpLocations()
        self.findClosestTaco()
        
        guard let distance = self.closestTaco.distance else {
            return
        }
        
        let distanceInMiles = String(format: "%.2f", distance / 1609.34)
        
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Taco Found!", message:  "\(self.closestTaco.name!): \(distanceInMiles) miles away", preferredStyle: .alert)
        
        // Create the actions
        let getTacoAction = UIAlertAction(title: "Get Directions", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            let url  = NSURL(string: "http://maps.apple.com/?q=\(self.closestTaco.coordinate.coordinate.latitude),\(self.closestTaco.coordinate.coordinate.longitude)")
            
            if UIApplication.shared.canOpenURL(url! as URL) == true {
                UIApplication.shared.open(url as! URL)
                
            }
        }
        let moreTacoAction = UIAlertAction(title: "More Tacos", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            self.performSegue(withIdentifier: "MapSegue", sender: self)
            
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

    
    //Finding the location that is closest to the user
    func findClosestTaco() {
        
        var distances = [Double]()
        
        //looping to get all the location distance from user
        for locationDistance in self.tacoLocations {
            
            let distance = locationDistance.distance
            distances.append(distance!)
            
        }
        
        let minDistance = distances.min()
        
        //locationDistance the closest location object to the location with the closest distance
        for locations in self.tacoLocations {
            
            if locations.distance == minDistance {
                self.closestTaco = locations
            }
        }
    }
    
    //Custom segue 
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return nil
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return self.fadeTransition
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MapSegue" {
            
            let mapVC = segue.destination as! MapViewController
            mapVC.tacoLocations = self.tacoLocations
            
            mapVC.transitioningDelegate = self
            
        }
        
    }
    
    
    
}
