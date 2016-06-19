//
//  ViewController.swift
//  NewsApp
//
//  Created by Saurabh Arora on 27/09/15.
//  Copyright (c) 2015 Saurabh Arora. All rights reserved.
//

import UIKit
import Foundation

class ContentViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    //MARK: - Properties
    var newsDataArray = [TheGuardianNewsData]()
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    static var topic = "us-news"
    static var title = "United States"
    
    //MARK: - ViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.navigationItem.title = ContentViewController.title
        
        // Do any additional setup after loading the view, typically from a nib.
        self.revealViewController().rearViewRevealWidth = CGFloat(200)
        menuButton.target = self.revealViewController()
        menuButton.action = Selector("revealToggle:")
        fetchData(ContentViewController.topic)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - TableViewDelegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if newsDataArray.count == 0
        {
         var cell = tableView.dequeueReusableCellWithIdentifier("LoadingCell") as! UITableViewCell
            return cell
        }
        
        if indexPath.row == 0
        {
            var cell = tableView.dequeueReusableCellWithIdentifier("TopCell") as! ContentViewTopTableViewCell
            cell.newsTitle = newsDataArray[indexPath.row].title
            cell.activityIndicator?.startAnimating()
            cell.newsImageView.image = nil
            if newsDataArray[indexPath.row].imageURL == "nil" || newsDataArray[indexPath.row].imageURL == "Empty"
            {
                cell.newsImageView?.image = UIImage(named: "default")
            }
            else if newsDataArray[indexPath.row].imageData != nil
            {
                cell.newsImageView.image = UIImage(data: newsDataArray[indexPath.row].imageData!)
            }
            
            
            return cell
        }
        else
        {
            var cell = tableView.dequeueReusableCellWithIdentifier("DefaultCell") as! ContentViewDefaultTableViewCell
            cell.newsTitle = newsDataArray[indexPath.row].title
            cell.activityIndicator?.startAnimating()
            cell.newsImageView.image = nil
            if newsDataArray[indexPath.row].imageURL == "nil" || newsDataArray[indexPath.row].imageURL == "Empty"
            {
                cell.newsImageView?.image = UIImage(named: "default")
            }
            else if newsDataArray[indexPath.row].imageData != nil
            {
                cell.newsImageView.image = UIImage(data: newsDataArray[indexPath.row].imageData!)
            }
            
            return cell
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newsDataArray.count == 0
        {
            return 1
        }
        return newsDataArray.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if newsDataArray.count == 0
        {
            return 600
        }
        
        if indexPath.row == 0
        {
            return 300
        }
        else
        {
            return 100
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowDetail", sender: indexPath.row)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "ShowDetail"{
                if let destVC = segue.destinationViewController as? DetailsViewController{
                    destVC.newsItem = newsDataArray[sender as! Int]
                }
        }
    }
    }
    
    
    //MARK: - TheGuardian
    //TheGuardian API To Fetch News
    func fetchData(topic: String)
    {
        var url = NSURL(string: "http://content.guardianapis.com/search?q=\(topic)&api-key=test&show-elements=image&show-blocks=all&order-by=relevance&page-size=45")
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue())
            {var dict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil) as! NSDictionary
            var dataReceived = dict["response"]! as! NSDictionary
            var results = dataReceived["results"] as! [AnyObject]
            
            for result in results
            {
                if (result["blocks"] as? NSDictionary) == nil
                {
                    continue
                }
                var blocks = result["blocks"] as! NSDictionary
                var body = blocks["body"] as! NSArray
                var main = blocks["main"] as? NSDictionary
                var bodyTextSummary = ""
                var imageURL = ""
                var detailImageURL = "Empty"
                if main == nil{
                    imageURL = "nil"
                }
                else{
                    imageURL = TheGuardianAPI.getImageURL(main!["bodyHtml"] as? String)
                }
                
                if body.count > 0
                {
                    bodyTextSummary = body[0]["bodyTextSummary"] as! String
                    detailImageURL = TheGuardianAPI.getImageURL(body[0]["bodyHtml"] as? String)
                    
                }
                var newsData = TheGuardianNewsData(title: result["webTitle"] as! String, imageURL: imageURL, bodyText: bodyTextSummary,detailImageURL: detailImageURL,imageData: nil, detailImageData: nil)
                if imageURL != "nil" && imageURL != "Empty"
                {
                 self.newsDataArray.append(newsData)
                }
            }
            self.tableView.reloadData()
            self.getImageDataFromUrl(0)
        }
        
        })
        
        task.resume()
    }
    
    
    func getImageDataFromUrl(id: Int)
    {
        if id >= newsDataArray.count
        {
            return
        }
        var url = NSURL(string: newsDataArray[id].imageURL)
        let qos = Int(QOS_CLASS_USER_INITIATED.value)
        dispatch_async(dispatch_get_global_queue(qos, 0))
            {
                var data = NSData(contentsOfURL: url!)
                self.newsDataArray[id].imageData = data
                if data == nil
                {
                    self.newsDataArray[id].imageURL = "nil"
                    self.newsDataArray.removeAtIndex(id)
                    self.tableView.reloadData()
                    self.getImageDataFromUrl(id)
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue())
                        {
                            var indexPath = NSIndexPath(forRow: id, inSection: 0)
                            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                            self.getImageDataFromUrl(id+1)
                    }
                }
        }
    }
    
}

