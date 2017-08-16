//
//  Donations.swift
//  RonaldYule
//
//  Created by Matthew Frankland on 04/08/2017.
//  Copyright © 2017 Matthew Frankland. All rights reserved.
//

import Foundation
import UIKit
import PassKit
import Stripe

enum STPBackendChargeResult{
    case Success, Failure
}

typealias STPTokenSubmissionHandler = (STPBackendChargeResult?, NSError?) -> Void

extension UITextField{
    
    func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: myAction)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
}

extension Float {
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

class Donations: UIViewController, PKPaymentAuthorizationViewControllerDelegate{
    
    @IBOutlet var picture: UIImageView!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var donationAmount: UITextField!
    @IBOutlet var applePayButton: UIButton!
    var price: String!
    let SupportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex, PKPaymentNetwork.discover]

    let stripePublishableKey = "pk_live_F27oRsOruxafBt76Z3mnpYKG"
    let backendBaseURL: String = "https://matthewf-applepay.herokuapp.com"
    let appleMerchantID: String = "merchant.com.matthewfrankland.stripe"
    let companyName = "Matthew Frankland"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(hex: "003146")
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        //Set navigation bar colour
        
        tabBarController?.tabBar.barTintColor = UIColor(hex: "003146")
        tabBarController?.tabBar.tintColor = UIColor(hex: "32A4CC")
        tabBarController?.tabBar.unselectedItemTintColor = UIColor.white
        //Set tab bar colour
        
        donationAmount.addDoneButtonToKeyboard(myAction: #selector(self.donationAmount.resignFirstResponder))
        
        self.donationAmount.layer.borderColor = UIColor.lightGray.cgColor
        self.donationAmount.layer.borderWidth = 2.0
        
        donationAmount.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        picture.image = UIImage(named: "images/0.jpg")
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
    
    func textFieldDidChange(_ textField: UITextField) {
        if textField.text == ""{
            amountLabel.text = "£--.--"
        }else{
            amountLabel.text = "£" + textField.text!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func payAction(_ sender: Any) {
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: SupportedPaymentNetworks){
        
            if amountLabel.text == "£--.--"{
            
                let alert = UIAlertController(title: "No Donation Amount Given", message: "Please enter an amount", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            
            }else if amountLabel.text?.hasPrefix("£0") == true{
                let alert = UIAlertController(title: "£0 Entered", message: "Donations must be greater than £1", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                price = donationAmount.text
                
                let request = Stripe.paymentRequest(withMerchantIdentifier: appleMerchantID)
                request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Donations", amount: NSDecimalNumber(string: price))]
                
                request.requiredBillingAddressFields = PKAddressField.all
                request.countryCode = "GB"
                request.currencyCode = "GBP"
                request.merchantCapabilities = PKMerchantCapability.capability3DS
                request.supportedNetworks = [PKPaymentNetwork.amex, PKPaymentNetwork.masterCard, PKPaymentNetwork.visa]
                
                let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
                
                applePayController.delegate = self
                
                self.navigationController?.present(applePayController, animated: true, completion: nil)
                
                if Stripe.canSubmitPaymentRequest(request) {
                    
                    let paymentController = PKPaymentAuthorizationViewController(paymentRequest: request)
                    
                    paymentController.delegate = self
                    
                    self.navigationController?.present(paymentController, animated: true, completion: nil)
                }
            }
        }else{
            let alert = UIAlertController(title: "Apple Pay Not Setup", message: "Please enter card details before proceeding", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping ((PKPaymentAuthorizationStatus) -> Void)) {
        let apiClient = STPAPIClient(publishableKey: stripePublishableKey)
        apiClient.createToken(with: payment, completion: { (token, error) -> Void in
            if error == nil {
                if let token = token {
                    print(token.tokenId)
                    self.createBackendChargeWithToken(token, completion: { (result, error) -> Void in
                        if result == STPBackendChargeResult.Success {
                            completion(PKPaymentAuthorizationStatus.success)
                        }
                        else {
                            completion(PKPaymentAuthorizationStatus.failure)
                        }
                    })
                }
            }
            else {
                completion(PKPaymentAuthorizationStatus.failure)
            }
        })
    }
    
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func createBackendChargeWithToken(_ token: STPToken, completion: @escaping STPTokenSubmissionHandler) {
        
        let priceRemoved: NSDecimalNumber = NSDecimalNumber (string: price!)
        let formatter = NumberFormatter()
        formatter.positiveFormat = "0"
        let formattedString: String = formatter.string(from: priceRemoved)!
        
        if self.backendBaseURL != "" {
            if backendBaseURL != "" {
                if let url = URL(string: backendBaseURL  + "/charge") {
                    
                    let session = URLSession(configuration: URLSessionConfiguration.default)
                    let request = NSMutableURLRequest(url: url)
                    request.httpMethod = "POST"
                    let postBody = "stripeToken=\(token.tokenId)&amount=\(formattedString)"
                    let postData = postBody.data(using: String.Encoding.utf8, allowLossyConversion: false)
                    session.uploadTask(with: request as URLRequest, from: postData, completionHandler: { data, response, error in
                        let successfulResponse = (response as? HTTPURLResponse)?.statusCode == 200
                        if successfulResponse && error == nil {
                            completion(.Success, nil)
                        } else {
                            if error != nil {
                                completion(.Failure, error! as NSError)
                            } else {
                                completion(.Failure, NSError(domain: StripeDomain, code: 50, userInfo: [NSLocalizedDescriptionKey: "There was an error communicating with your payment backend."]))
                            }
                            
                        }
                    }).resume()
                    return
                }
            }
            completion(STPBackendChargeResult.Failure, NSError(domain: StripeDomain, code: 50, userInfo: [NSLocalizedDescriptionKey: "You created a token! Its value is \(token.tokenId). Now configure your backend to accept this token and complete a charge."]))
        }
    }
}
