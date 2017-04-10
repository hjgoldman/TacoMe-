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

class AddReviewViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func buttonPressed(_ sender: Any) {
        
        let ref = FIRDatabase.database().reference(withPath: "reviews")
        
        let testRef = ref.child("resturant_UID")
        
        let review1 = Review()
        
        review1.author_name = "Hayden Goldman"
        review1.rating = 4
        review1.text = "This place is great!"
        review1.relative_time_description = String(describing: Date())
        
        testRef.setValue(review1.toDictionary())
        
    }
    
    @IBAction func cencelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
