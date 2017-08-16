//
//  YouTube.swift
//  RonaldYule
//
//  Created by Matthew Frankland on 08/08/2017.
//  Copyright © 2017 Matthew Frankland. All rights reserved.
//

import Foundation
import UIKit

class YouTube: UIViewController, UIWebViewDelegate{
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "https://www.youtube.com/user/ronaldyule")
        let urlRequest = NSURLRequest(url: url! as URL)
        webView.loadRequest(urlRequest as URLRequest)
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        webView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.shouldRotate = true // or false to disable rotation
        
        //Set navigation bar colour
        navigationController?.navigationBar.barTintColor = UIColor(hex: "003146")
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        //Set tab bar colour
        tabBarController?.tabBar.barTintColor = UIColor(hex: "003146")
        tabBarController?.tabBar.tintColor = UIColor(hex: "32A4CC")
        tabBarController?.tabBar.unselectedItemTintColor = UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UIWebView Delegate methods
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
}
