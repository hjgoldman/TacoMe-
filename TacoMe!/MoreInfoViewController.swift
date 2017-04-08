//
//  MoreInfoViewController.swift
//  TacoMe!
//
//  Created by Hayden Goldman on 4/5/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.
//

import UIKit

class MoreInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource   {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var isOpenLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var phoneButtonOutlet: UIButton!
    
    var tacoLocationDetail = TacoLocationDetail()
    var tacoLocationPlace_id :String!
    var reviews = [Review]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.tacoLocationPlace_id)
        self.getLocationDetails()
        
        //MARK: Table View stuff
        
    }

    
    func populateView() {
        
        self.nameLabel.text = self.tacoLocationDetail.name
        self.addressLabel.text = self.tacoLocationDetail.formatted_address
        self.phoneButtonOutlet.setTitle(self.tacoLocationDetail.formatted_phone_number, for: .normal)
        self.ratingLabel.text = String(describing: self.tacoLocationDetail.rating!)
        
        if self.tacoLocationDetail.weekday_text == nil {
            self.hoursLabel.text = "Opening Hours Not Provided"
        } else {
            
            let hours = self.tacoLocationDetail.weekday_text?.joined(separator: "\n")
            self.hoursLabel.text = hours!

        }
        
        
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
            //let opening_hours = result["opening_hours"] as! [String:Any]
            
            if let opening_hours = result["opening_hours"] as? [String:Any] {
                
                let weekday_text = opening_hours["weekday_text"] as? [String]
                self.tacoLocationDetail.weekday_text = weekday_text

                if let open_now = opening_hours["open_now"] {
                    self.tacoLocationDetail.open_now = open_now as? Bool
                }
                
                
            }
            
            guard let formatted_address = result["formatted_address"] as? String,
                let formatted_phone_number = result["formatted_phone_number"] as? String,
                let lat = location["lat"] as? Double,
                let lng = location["lng"] as? Double,
                let name = result["name"] as? String,
                let rating = result["rating"] as? Double,
                let url = result["url"] as? String,
                let international_phone_number = result["international_phone_number"] as? String
                else {
                    return
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
            self.tacoLocationDetail.rating = rating
            self.tacoLocationDetail.url = url
            self.tacoLocationDetail.international_phone_number = international_phone_number
            
            // Save the rewivew into my review object
            
            let reviews = result["reviews"] as! [[String:Any]]
            for item in reviews {
                
                let author_name = item["author_name"] as! String
                let rating = item["rating"] as! Int
                let relative_time_description = item["relative_time_description"] as! String
                let text = item["text"] as! String
                
                let review = Review()
                review.author_name = author_name
                review.rating = rating
                review.relative_time_description = relative_time_description
                review.text = text
                
                self.reviews.append(review)
                
            }
            
            DispatchQueue.main.async {
                self.populateView()
//                self.reviewTableView.reloadData()
            }
        })
        dataTask.resume()
        
    }
    
    //MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.reviews.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewTableViewCell
        
        let review = reviews[indexPath.row]
        
        cell.nameLabel?.text = review.author_name
        
        if review.rating == 1 {
            cell.ratingLabel?.text = "\(review.rating!) star"
            cell.reviewTextLabel?.text = review.text
            cell.reviewTextLabel?.sizeToFit()
            cell.timeLabel?.text = review.relative_time_description
        } else {
            cell.ratingLabel?.text = "\(review.rating!) stars"
            cell.reviewTextLabel?.text = review.text
            cell.reviewTextLabel?.sizeToFit()
            cell.timeLabel?.text = review.relative_time_description
        }
        
        return cell
    }
    
    //MARK: Buttons
    
    @IBAction func phoneButtonPressed(_ sender: Any) {
        
        let formattedPhoneNumber = self.tacoLocationDetail.international_phone_number?.replacingOccurrences(of: " ", with: "")
        
        if let phoneCallURL = URL(string: "tel://\(String(describing: formattedPhoneNumber!))") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func directionsButtonPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Directions", message:  "\(self.tacoLocationDetail.name!)", preferredStyle: .alert)
        
        let directionsAction = UIAlertAction(title: "Lets do it", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            let url  = NSURL(string: "\(self.tacoLocationDetail.url!)")
            
            if UIApplication.shared.canOpenURL(url! as URL) == true {
                UIApplication.shared.open(url! as URL)
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
        }
        
        alertController.addAction(directionsAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)

    }
    

}
