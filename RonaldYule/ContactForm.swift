//
//  ContactForm.swift
//  RonaldYule
//
//  Created by Matthew Frankland on 04/08/2017.
//  Copyright © 2017 Matthew Frankland. All rights reserved.
//

import Foundation
import UIKit

class ContactForm: UIViewController{
    
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var twitterButton: UIButton!
    
    @IBOutlet weak var emailButton: UIButton!
    
    override func viewDidLoad() {
        //Set navigation bar colour
        navigationController?.navigationBar.barTintColor = UIColor(hex: "005D95")
        self.navigationController?.navigationBar.tintColor = UIColor.red;
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        //Set tab bar colour
        tabBarController?.tabBar.barTintColor = UIColor(hex: "005D95")
        tabBarController?.tabBar.tintColor = UIColor.black
        tabBarController?.tabBar.unselectedItemTintColor = UIColor.white
        
        facebookButton.backgroundColor = UIColor.lightGray
    }
}
