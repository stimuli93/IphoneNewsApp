//
//  SavedArticlesTableViewController.swift
//  NewsApp
//
//  Created by Saurabh Arora on 30/09/15.
//  Copyright (c) 2015 Saurabh Arora. All rights reserved.
//

import UIKit

class SavedArticlesTableViewController: UITableViewController {

    var newsItemArray = [TheGuardianNewsData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        newsItemArray = TheGuardianAPI.loadSavedArticles() ?? []
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return newsItemArray.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("DefaultCell") as! ContentViewDefaultTableViewCell
        cell.newsTitle = newsItemArray[indexPath.row].title
        cell.activityIndicator?.startAnimating()
        cell.newsImageView.image = nil
        if newsItemArray[indexPath.row].imageURL == "nil" || newsItemArray[indexPath.row].imageURL == "Empty"
        {
            cell.newsImageView?.image = UIImage(named: "default")
        }
        else if newsItemArray[indexPath.row].imageData != nil
        {
            cell.newsImageView.image = UIImage(data: newsItemArray[indexPath.row].imageData!)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            newsItemArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(newsItemArray, toFile:TheGuardianNewsData.ArchiveURL.path!)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowSavedArticleDetails", sender: newsItemArray[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier{
            if identifier == "ShowSavedArticleDetails"
            {
                if let destVC = segue.destinationViewController as? SavedArticleDetailsViewController
                {
                    destVC.newsItem = sender as! TheGuardianNewsData
                }
            }
        }
    }
}
