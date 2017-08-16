//
//  Featured.swift
//  RonaldYule
//
//  Created by Matthew Frankland on 20/07/2017.
//  Copyright © 2017 Matthew Frankland. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
class Featured: UITableViewController, videoModelDelegate {

    var videos: [Video] = [Video]()
    var selectedVideo: Video?
    let model: VideoModel = VideoModel()
    var navigationBar = UINavigationBar.appearance()
    @IBOutlet var barButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.model.delegate = self
        
        //Fire off request to get videos
        model.getFeedVideo()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        navigationController?.navigationBar.barTintColor = UIColor(hex: "003146")
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        //Set navigation bar colour

        tabBarController?.tabBar.barTintColor = UIColor(hex: "003146")
        tabBarController?.tabBar.tintColor = UIColor(hex: "32A4CC")
        tabBarController?.tabBar.unselectedItemTintColor = UIColor.white
        //Set tab bar colour
        
        self.navigationItem.hidesBackButton = false
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
    
    //MARK: - VideoModel Delegate Methods
    
    func dataReady() {
        
        //Access the video objects that have been downloaded
        self.videos = self.model.videoArray
        
        //Tell the table view to reload
        self.tableView.reloadData()
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Calculate the width of the screen to calculate the height of the row
        return (self.view.frame.size.width/320)*180
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
        
        let videoTitle = videos[indexPath.row].videoTitle

        //Get the label for the cell
        let label = cell.viewWithTag(2) as! UILabel
        label.text = videoTitle
        
        //Construct the video thumbnail URL
        let videoURLString = videos[indexPath.row].videoThumbnailURL
        
        //Create an NSURL object
        let videoThumbnailURL = URL(string: videoURLString)
        
        if videoThumbnailURL != nil {
        
            //Create an NSURLRequest object
            let request = URLRequest(url: videoThumbnailURL!)
        
            //Create an NSURLSession
            let session = URLSession.shared
            
            //Create a datatask and pass in the request
            let dataTask =  session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, Error: Error?) in
                
                DispatchQueue.main.async(execute: {()  -> Void in
                    
                //Get a reference to the imageview element of the cell
                    
                let imageView = cell.viewWithTag(1) as? UIImageView

                //Create an image object from the data and asign it into the imageview
                imageView?.image = UIImage(data: data!)
                })
            })
            
            dataTask.resume()
            
        }
        
        //Create a datatask and pass in the request
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Take note of which video the user has selected
        self.selectedVideo = self.videos[indexPath.row]
        
        //Call the segue
        self.performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToDetail"{
        //Get reference to the destination view controller
        let detailViewController = segue.destination as! VideoDetailViewController
        
        //Set the selected video property of the destination view controller
        detailViewController.selectedVideo = self.selectedVideo
        }
    }
}

