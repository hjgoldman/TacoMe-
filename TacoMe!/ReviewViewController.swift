//
//  ReviewViewController.swift
//  TacoMe!
//
//  Created by Hayden Goldman on 4/10/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var reviews = [Review]()
    var tacoLocationDetail = TacoLocationDetail()
    var tacoLocationPlace_id :String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 175
        
        self.getLocationDetails()
    }
    
    func populateView() {
        
        self.nameLabel.text = self.tacoLocationDetail.name
        self.ratingLabel.text = String(describing: self.tacoLocationDetail.rating!)
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
    
    //MARK: API GET request 
    
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
            let name = result["name"] as? String
            let rating = result["rating"] as? Double
            
            self.tacoLocationDetail.name = name
            self.tacoLocationDetail.rating = rating

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
                self.tableView.reloadData()
                self.populateView()
            }
        })
        dataTask.resume()
        
    }


}
