//
//  AllVideoDetailViewController.swift
//  RonaldYule
//
//  Created by Matthew Frankland on 29/07/2017.
//  Copyright © 2017 Matthew Frankland. All rights reserved.
//

import UIKit

class AllVideoDetail: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    var selectedVideo: Video?
    
    override internal func viewDidLoad() {
        if let vid = self.selectedVideo{
            self.titleLabel.text = vid.videoTitle
            self.descriptionField.text = vid.videoDescription
            
            let width = view.frame.size.width
            let height = width/320 * 180
            
            //Adjust the height of the webview constraint
            self.webViewHeightConstraint.constant = height
            
            let videoEmbedString = "<html><head><style type =\"text/css\">body {background-color: transparent; color: white;}</style></head><body style=\"margin:0\"><iframe frameBorder =\"0\" height=\"" + String(describing: height) + "\" width=\"" + String(describing: width) + "\" src=\"http://www.youtube.com/embed/" + vid.videoID + "?showinfo=0&modestbranding=1&frameborder=0&rel=0\"></iframe></body></html>"
            
            self.webView.loadHTMLString(videoEmbedString, baseURL: nil)
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
    
    override internal func didReceiveMemoryWarning() {
        //Placeholder
    }
}
