//
//  LocationDetailTabBarController.swift
//  TacoMe!
//
//  Created by Hayden Goldman on 4/11/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.
//

import UIKit

class LocationDetailTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let infoVC = self.viewControllers![0] as! MoreInfoViewController
        let reviewVC = self.viewControllers![1] as! ReviewViewController
        reviewVC.tacoLocationDetail = infoVC.tacoLocationDetail
        reviewVC.reviews = infoVC.reviews
    }
    
    override func awakeFromNib() {
        self.delegate = self;
    }

}
