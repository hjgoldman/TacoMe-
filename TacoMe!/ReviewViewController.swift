//
//  ReviewViewController.swift
//  TacoMe!
//
//  Created by Hayden Goldman on 4/10/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ReviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddNewReviewToTableDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var reviews = [Review]()
    var tacoLocationDetail = TacoLocationDetail()
    var tacoLocationPlace_id :String!
    var accumulatedFireBaseRatings = 0
    var numberOfFirebaseRatings = 0
    var newRating :Double!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 175
        
        self.getFireBaseReviews()
    }
    //MARK: Delegate to add new review to current table
    func addNewReviewToTable(author_name :String,isTacoReview :Bool,rating :Int, text:String, relative_time_description:String) {
        let review = Review()
        review.author_name = author_name
        review.isTacoMeReview = isTacoReview
        review.rating = rating
        review.text = text
        review.relative_time_description = relative_time_description
        
        self.tableView.reloadData()
    }
    
    //MARK: Get FireBase Data and add it to the Google reviews
    private func getFireBaseReviews() {
        
        let ref = FIRDatabase.database().reference(withPath: "reviews")
        ref.observe(.value) { (snapshot :FIRDataSnapshot) in
            
            let locationInDB = snapshot.childSnapshot(forPath: self.tacoLocationPlace_id!)
            
            
            if locationInDB.exists() == true {
                
                for item in locationInDB.children {
                    
                    let snapshotDictionary = (item as! FIRDataSnapshot).value as! [String:Any]
                    
                    let review = Review()
                    review.author_name = snapshotDictionary["author_name"] as? String
                    review.isTacoMeReview = snapshotDictionary["isTacoMeReview"] as? Bool
                    review.rating = snapshotDictionary["rating"] as? Int
                    
                    self.accumulatedFireBaseRatings += review.rating!
                    self.numberOfFirebaseRatings += 1
                    
                    review.text = snapshotDictionary["text"] as? String
                    review.relative_time_description = snapshotDictionary["relative_time_description"] as? String
                    
                    self.reviews.insert(review, at: 0)
                    
                }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.newRating = (Double(self.accumulatedFireBaseRatings) + self.tacoLocationDetail.rating!) / Double(self.numberOfFirebaseRatings + 1)
                    self.populateView()
                }
            } else {
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.populateView()
                }
                
            }
        }
    }

    
    func populateView() {
        
        self.nameLabel.text = self.tacoLocationDetail.name
        
        if self.numberOfFirebaseRatings == 0 {
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
        } else {
            
            let ratingString = String(format: "%.1f", self.newRating!)
            
            self.ratingLabel.text = ratingString
            
            if self.newRating! >= 0.0 && self.newRating! < 0.5 {
                self.imageView.image = UIImage(named: "0_stars.png")
            } else if self.newRating! >= 0.5 && self.newRating! < 1.0 {
                self.imageView.image = UIImage(named: "0_5_stars.png")
            } else if self.newRating! >= 1.0 && self.newRating! < 1.5 {
                self.imageView.image = UIImage(named: "1_stars.png")
            } else if self.newRating! >= 1.5 && self.newRating! < 2.0 {
                self.imageView.image = UIImage(named: "1_5_stars.png")
            } else if self.newRating! >= 2.0 && self.newRating! < 2.5 {
                self.imageView.image = UIImage(named: "2_stars.png")
            } else if self.newRating! >= 2.5 && self.newRating! < 3.0 {
                self.imageView.image = UIImage(named: "2_5_stars.png")
            } else if self.newRating! >= 3.0 && self.newRating! < 3.5 {
                self.imageView.image = UIImage(named: "3_stars.png")
            } else if self.newRating! >= 3.5 && self.newRating! < 4.0 {
                self.imageView.image = UIImage(named: "3_5_stars.png")
            } else if self.newRating! >= 4.0 && self.newRating! < 4.5 {
                self.imageView.image = UIImage(named: "4_stars.png")
            } else if self.newRating! >= 4.5 && self.newRating! < 5.0 {
                self.imageView.image = UIImage(named: "4_5_stars.png")
            } else if self.newRating! == 5.0 {
                self.imageView.image = UIImage(named: "5_stars.png")
            } else if self.newRating == nil {
                
            }
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddReviewSegue" {
            
            let addReviewVC = segue.destination as! AddReviewViewController

            addReviewVC.tacoLocationPlace_id = self.tacoLocationPlace_id
            addReviewVC.delegate = self
            
        }

    }


}
