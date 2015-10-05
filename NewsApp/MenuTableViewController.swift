//
//  MenuTableViewController.swift
//  NewsApp
//
//  Created by Saurabh Arora on 29/09/15.
//  Copyright (c) 2015 Saurabh Arora. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var lbNavTitle = UILabel(frame: CGRectMake(0,0,320,40))
        lbNavTitle.textAlignment = NSTextAlignment.Left
        lbNavTitle.text = "LATEST NEWS"
        lbNavTitle.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = lbNavTitle;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row
        {
            case 0: ContentViewController.topic = "us-news"
                    ContentViewController.title = "United States"
            
            case 1: ContentViewController.topic = "uk-news"
                    ContentViewController.title = "Europe"
            
            case 2: ContentViewController.topic = "world-news"
                    ContentViewController.title = "World"
            
            case 3: ContentViewController.topic = "us-politics"
                    ContentViewController.title = "Politics"
            
            case 4: ContentViewController.topic = "world-sport"
                    ContentViewController.title = "Sports"
            
            case 5: ContentViewController.topic = "health"
                    ContentViewController.title = "Health"
            
            case 6: ContentViewController.topic = "business"
                    ContentViewController.title = "Business"
            
            case 7: ContentViewController.topic = "culture"
                    ContentViewController.title = "Culture"
        
            case 8: ContentViewController.topic = "environment"
                    ContentViewController.title = "Environment"
            
            case 9: ContentViewController.topic = "lifeandstyle"
                    ContentViewController.title = "Life Style"
            
            case 10: ContentViewController.topic = "technology"
                     ContentViewController.title = "Tech"
        
            case 11: ContentViewController.topic = "travel"
                    ContentViewController.title = "Travel"
            
            default: ContentViewController.topic = "us-news"
                    ContentViewController.title = "United States"
        }
        performSegueWithIdentifier("show_content", sender: self)
    }
}
