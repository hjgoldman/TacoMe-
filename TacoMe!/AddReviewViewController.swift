//
//  AddReviewViewController.swift
//  TacoMe!
//
//  Created by Hayden Goldman on 4/10/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

protocol AddNewReviewToTableDelegate {
    func addNewReviewToTable(author_name :String,isTacoReview :Bool,rating :Int,text :String,relative_time_description :String)
}

class AddReviewViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {

    @IBOutlet weak var reviewTextTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ratingPickerView: UIPickerView!
    
    var imageArray: [UIImage] = [UIImage(named: "0_stars.png")!,UIImage(named: "1_stars.png")!, UIImage(named: "2_stars.png")!,UIImage(named: "3_stars.png")!,UIImage(named: "4_stars.png")!,UIImage(named: "5_stars.png")!]
    var selectedRowIndex :Int!
    var tacoLocationPlace_id :String!
    var reviews = [Any]()
    var delegate: AddNewReviewToTableDelegate!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Input data into the Array:
        self.reviewTextTextView.delegate = self
        self.nameTextField.delegate = self
        self.ratingPickerView.delegate = self
        self.ratingPickerView.dataSource = self
        
        self.getFireBaseReviews()
    }


    @IBAction func submitButtonPressed(_ sender: Any) {
        
        if self.selectedRowIndex == nil {
            self.selectedRowIndex = 0
        }
        
        if self.nameTextField.text == "" {
            let alertController = UIAlertController(title: "Opps!", message:  "Please enter your name.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
 
        if self.reviewTextTextView.text == "" {
            
            let alertController = UIAlertController(title: "Opps!", message:  "Please enter a review.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        self.saveReviewToFireBase()
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Post and Get FireBase Data
    
    private func getFireBaseReviews() {
        
        let ref = FIRDatabase.database().reference(withPath: "reviews")
        ref.observe(.value) { (snapshot :FIRDataSnapshot) in
            
            let locationInDB = snapshot.childSnapshot(forPath: self.tacoLocationPlace_id!)
            
            
            if locationInDB.exists() == true {
                
                self.reviews.removeAll()
                
                for item in locationInDB.children {
                    
                    let snapshotDictionary = (item as! FIRDataSnapshot).value as! [String:Any]
                    
                    let review = Review()
                    review.author_name = snapshotDictionary["author_name"] as? String
                    review.isTacoMeReview = snapshotDictionary["isTacoMeReview"] as? Bool
                    review.rating = snapshotDictionary["rating"] as? Int
                    review.text = snapshotDictionary["text"] as? String
                    review.relative_time_description = snapshotDictionary["relative_time_description"] as? String
                    
                    self.reviews.append(review.toDictionary())
                    
                }
                
               
              
            }
        }
    }

    
    private func saveReviewToFireBase() {
        
        let ref = FIRDatabase.database().reference(withPath: "reviews")
        
        let reviewRef = ref.child(self.tacoLocationPlace_id!)
        
        let review = Review()
        
        review.author_name = self.nameTextField.text!
        review.rating = self.selectedRowIndex!
        review.text = self.reviewTextTextView.text!
        review.isTacoMeReview = true
        review.relative_time_description = String(describing: Date())
        self.delegate.addNewReviewToTable(author_name: review.author_name!, isTacoReview: review.isTacoMeReview!, rating: review.rating!, text: review.text!, relative_time_description: review.relative_time_description!)
        self.reviews.append(review.toDictionary())
        reviewRef.setValue(self.reviews)
        
    }
 
    
    //MARK: PickerView Setup
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return imageArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 130, height: 25))
        
        switch row {
        case 0:
            myImageView.image = self.imageArray[0]
        case 1:
            myImageView.image = self.imageArray[1]
        case 2:
            myImageView.image = self.imageArray[2]
        case 3:
            myImageView.image = self.imageArray[3]
        case 4:
            myImageView.image = self.imageArray[4]
        case 5:
            myImageView.image = self.imageArray[5]
        default:
            myImageView.image = nil
        }
        return myImageView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRowIndex = ratingPickerView.selectedRow(inComponent: 0)
    }
    
    //MARK: Delegates for keyboard to return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    @IBAction func cencelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
