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
    
    @IBOutlet weak var indicatorView :UIActivityIndicatorView!
    var locationManager = CLLocationManager()
    var tacoLocations = [TacoLocation]()
    var closestTaco = TacoLocation()
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
        self.indicatorView.isHidden = true

    }
    
    private func launchTimerToLetEverythingLoad() {
        
        self.findTacos()
        sleep(2);
        self.findClosestTaco()

        
    }
    
    
    @IBAction func getTacoButtonPressed(_ sender: Any) {

        self.indicatorView.isHidden = false
        self.indicatorView.startAnimating()
        
        // background // lane for time consuming tasks
        DispatchQueue.global().async {
            
            self.launchTimerToLetEverythingLoad()
            
            // switch to the main thread to run UI specific tasks
            DispatchQueue.main.async {
                self.indicatorView.stopAnimating()
                self.indicatorView.isHidden = true

                
                guard let distance = self.closestTaco.distanceFromUser else {
                    return
                }
                
                let distanceInMiles = String(format: "%.2f", distance / 1609.34)
                
                
                // Create the alert controller
                let alertController = UIAlertController(title: "Taco Found!", message:  "\(self.closestTaco.name!): \(distanceInMiles) miles away", preferredStyle: .alert)
                
                // Create the actions
                let getTacoAction = UIAlertAction(title: "Get Directions", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    //self.performSegue(withIdentifier: "MapSegue", sender: self)
                    
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
        }

 
    }
    
    func findTacos() {
        let categoryRequest = MKLocalSearchRequest()
        
        categoryRequest.naturalLanguageQuery = "taco"
        
        let region = MKCoordinateRegionMakeWithDistance((self.locationManager.location?.coordinate)!, 250, 250)
        
        categoryRequest.region = region
        
        let search = MKLocalSearch(request: categoryRequest)
        search.start { (response :MKLocalSearchResponse?, error: Error?) in
            
            for requestItem in (response?.mapItems)! {
                
                let tacoLocation = TacoLocation()
                tacoLocation.name = requestItem.name
                tacoLocation.coordinate = requestItem.placemark.location
                tacoLocation.address = requestItem.placemark.addressDictionary?["FormattedAddressLines"] as! [String]
                tacoLocation.street = requestItem.placemark.addressDictionary?["Street"] as! String!
                tacoLocation.city = requestItem.placemark.addressDictionary?["City"] as! String
                tacoLocation.state = requestItem.placemark.addressDictionary?["State"] as! String
                tacoLocation.zip = requestItem.placemark.addressDictionary?["ZIP"] as! String
                
                self.tacoLocations.append(tacoLocation)
            }
        }
        
    }
    
    //Finding the location that is closest to the user
    func findClosestTaco() {
        
        var distances = [Double]()
        
        //looping to get all the location distance from user
        for locationDistance in self.tacoLocations {
            
            let distance = self.locationManager.location?.distance(from: locationDistance.coordinate)
            locationDistance.distanceFromUser = distance as Double!
            distances.append(distance!)
            
        }
        
        let minDistance = distances.min()
        
        //setting the closest location object to the location with the closest distance
        for location in self.tacoLocations {
            
            if self.locationManager.location?.distance(from: location.coordinate) == minDistance {
                self.closestTaco = location
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
        
        let mapVC = segue.destination as! MapViewController
        mapVC.transitioningDelegate = self
        
    }
    
    
    
}
