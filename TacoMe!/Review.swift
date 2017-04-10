//
//  Review.swift
//  TacoMe!
//
//  Created by Hayden Goldman on 4/7/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.
//

import Foundation

class Review {
    
    var rating :Int?
    var relative_time_description :String?
    var text :String?
    var author_name :String?
    
    
    func toDictionary() -> [String:Any] {
        
        return ["rating":self.rating!,"relative_time_description":self.relative_time_description!,"text":self.text!,"author_name":self.author_name!]
    }
    
}
