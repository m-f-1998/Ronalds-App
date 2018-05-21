//
//  Contact-TableView.swift
//  RonaldYule
//
//  Created by Matthew Frankland on 29/07/2017.
//  Copyright © 2017 Matthew Frankland. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class Contact: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate{
    
    //Text Fields for Controller
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var subject: UITextField!
    @IBOutlet weak var message: UITextView!
    
    override func viewDidLoad(){
        super.viewDidLoad()

        //Set Delegate
        name.delegate = self
        email.delegate = self
        subject.delegate = self
        message.delegate = self
        
        //Set Navigation Bar Colour
        navigationController?.navigationBar.barTintColor = UIColor(hex: "003146")
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        //Set Tab Bar Colour
        tabBarController?.tabBar.barTintColor = UIColor(hex: "003146")
        tabBarController?.tabBar.tintColor = UIColor(hex: "32A4CC")
        tabBarController?.tabBar.unselectedItemTintColor = UIColor.white
        
        //Set Border Colour
        self.message.layer.borderWidth = 2.5
        self.message.layer.borderColor = UIColor.lightGray.cgColor
        self.name.layer.borderWidth = 2.5
        self.name.layer.borderColor = UIColor.lightGray.cgColor
        self.email.layer.borderWidth = 2.5
        self.email.layer.borderColor = UIColor.lightGray.cgColor
        self.subject.layer.borderWidth = 2.5
        self.subject.layer.borderColor = UIColor.lightGray.cgColor
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
    
    //Resign Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        name.resignFirstResponder()
        email.resignFirstResponder()
        subject.resignFirstResponder()
        return true
    }
    
    //Send Mail
    @IBAction func sendMail(_ sender: Any) {
        
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setSubject(subject.text!)
        
        let email = self.email.text!.lowercased()
        let finalEmail = email.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        let mailContent = "Name: \(name.text!)\n\n E-Mail: \(finalEmail)\n\n Subject: \(subject.text!)"
        
        mailVC.setMessageBody(mailContent, isHTML: false)
        
        let toRecipient = "hello@ronaldyule.co.uk"

        mailVC.setToRecipients([toRecipient])
        
        self.present(mailVC, animated:  true){
            self.name.text = ""
            self.subject.text = ""
            self.message.text = ""
            self.email.text = ""
        }
        
        mailVC.navigationBar.tintColor = UIColor.white
    }
    
    //Compose Mail
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    //Facebook Action
    @IBAction func facebook(_ sender: Any) {
        let url = URL(string: "https://www.facebook.com/ronald.yule")
        
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    //Twitter Action
    @IBAction func twitter(_ sender: Any) {
        let url = URL(string: "https://twitter.com/ronaldyule?lang=en")
        
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
