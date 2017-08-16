//
//  PictureGallery.swift
//  RonaldYule
//
//  Created by Matthew Frankland on 01/08/2017.
//  Copyright © 2017 Matthew Frankland. All rights reserved.
//

import Foundation
import UIKit

func uniqueRandoms(numberOfRandoms: Int, minNum: Int, maxNum: UInt32) -> [Int] {
    var uniqueNumbers = Set<Int>()
    while uniqueNumbers.count < numberOfRandoms {
        uniqueNumbers.insert(Int(arc4random_uniform(maxNum + 1)) + minNum)
    }
    return Array(uniqueNumbers)
}

class PictureGallery: UIViewController{
    
    @IBOutlet var collectionOfImages: [UIImageView]!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet var tapGestureOne: UITapGestureRecognizer!
    @IBOutlet var tapGestureTwo: UITapGestureRecognizer!
    @IBOutlet var tapGestureThree: UITapGestureRecognizer!
    @IBOutlet var tapGestureFour: UITapGestureRecognizer!
    @IBOutlet var tapGestureFive: UITapGestureRecognizer!
    var uniqueNumbers: [Int] = uniqueRandoms(numberOfRandoms: 6, minNum: 0, maxNum: 9)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Set navigation bar colour
        navigationController?.navigationBar.barTintColor = UIColor(hex: "003146")
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        //Set tab bar colour
        tabBarController?.tabBar.barTintColor = UIColor(hex: "003146")
        tabBarController?.tabBar.tintColor = UIColor(hex: "32A4CC")
        tabBarController?.tabBar.unselectedItemTintColor = UIColor.white
        
        var i = 0
        
        //Set colour of border
        for collectionOfImages in self.collectionOfImages{
            collectionOfImages.layer.backgroundColor = UIColor.black.cgColor
            collectionOfImages.layer.borderColor = UIColor.white.cgColor
            collectionOfImages.layer.borderWidth = 2.0
            collectionOfImages.image = UIImage(named: "images/" + String (uniqueNumbers[i]) + ".jpg")
            collectionOfImages.contentMode = .scaleAspectFit
            i += 1
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.shouldRotate = false // or true to enable rotation
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
   
            let collection = sender.view as! UIImageView
        
            let newImageView = UIImageView(image: collection.image)
        
            newImageView.frame = UIScreen.main.bounds
            newImageView.backgroundColor = .black
        
            newImageView.contentMode = .scaleAspectFit
        
            newImageView.layer.masksToBounds = true
            newImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
            newImageView.addGestureRecognizer(tap)
            self.view.addSubview(newImageView)
            self.navigationController?.isNavigationBarHidden = true
            self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
}
