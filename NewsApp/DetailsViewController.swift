//
//  DetailsViewController.swift
//  NewsApp
//
//  Created by Saurabh Arora on 28/09/15.
//  Copyright (c) 2015 Saurabh Arora. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController , UIScrollViewDelegate {

    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var newsItem = TheGuardianNewsData(title: "", imageURL: "", bodyText: "", detailImageURL: "", imageData: nil, detailImageData: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.enabled = false
        getImageDataFromUrl(newsItem.detailImageURL , pref: 0)
        setupView()
    }
    
    @IBAction func saveNewsData(sender: UIBarButtonItem) {
        
        if alreadyPresent(newsItem.title)
        {
            showAlertMessage("Article has been saved before")
            return
        }
        
        var newsItemArray = TheGuardianAPI.loadSavedArticles() ?? []
        newsItemArray.insert(newsItem, atIndex: 0)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(newsItemArray, toFile:TheGuardianNewsData.ArchiveURL.path!)
        if !isSuccessfulSave {
            showAlertMessage("Failed to save article")
            }
        else
        {
            showAlertMessage("Article successfully saved")
        }

    }
    
    func alreadyPresent(articleTile: String) -> Bool
    {
        var savedArticles = TheGuardianAPI.loadSavedArticles()
        if savedArticles == nil
        {
            return false
        }
        for article in savedArticles!
        {
         if article.title == articleTile
            {
                return true
            }
        }
        
        return false
    }
    
    func showAlertMessage(message: String)
    {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func setupView()
    {
        var screenWidth = UIScreen.mainScreen().bounds.width
        var screenHeight = UIScreen.mainScreen().bounds.height
        var height = screenHeight * 0.4
        
        var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: screenWidth*0.45, y: screenHeight*0.2 + 10, width: 20, height: 20))
        activityIndicator.color = UIColor.grayColor()
        activityIndicator.startAnimating()
        scrollView.addSubview(activityIndicator)
        
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight * 0.4))
        if newsItem.detailImageData != nil
        {
            imageView.image = UIImage(data: newsItem.detailImageData!)
            saveButton.enabled = true
        }
        else
        {
            if newsItem.detailImageURL == "Empty"
            {
                if newsItem.imageData != nil
                {
                    imageView.image = UIImage(data: newsItem.imageData!)
                    saveButton.enabled = true
                }
                else if newsItem.imageURL == "Empty"
                {
                 imageView.image = UIImage(named: "default")
                    saveButton.enabled = true
                }
            }
        }
        
        var label = UILabel(frame: CGRect(x: 8, y: screenHeight*0.4 + 8, width: screenWidth - 16, height: screenHeight*0.2))
        label.text = newsItem.title
        label.numberOfLines = 0
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        label.sizeToFit()
        height = height + 16 + label.frame.height
        
        var textView = UITextView(frame: CGRect(x: 8, y: height, width: screenWidth - 16, height: screenHeight*100))
        var htmlString = newsItem.bodyText
        textView.editable = false
        textView.text = TheGuardianAPI.insertLineBreaks(newsItem.bodyText)
        textView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        textView.sizeToFit()
        height = height + textView.frame.height + 50
        
        
        scrollView.contentSize = CGSizeMake(screenWidth, height)
        scrollView.addSubview(imageView)
        scrollView.addSubview(label)
        scrollView.addSubview(textView)

    }
    
    func getImageDataFromUrl(imageURL: String , pref: Int)
    {

        var url = NSURL(string: imageURL)
        let qos = Int(QOS_CLASS_USER_INITIATED.value)
        dispatch_async(dispatch_get_global_queue(qos, 0))
            {
                var data = NSData(contentsOfURL: url!)
                if pref == 0
                {   if self.newsItem.detailImageURL == imageURL
                    {
                        self.newsItem.detailImageData = data
                        if data == nil
                        {
                            self.newsItem.detailImageURL = "Empty"
                            dispatch_async(dispatch_get_main_queue())
                                {
                                    if self.newsItem.imageData == nil
                                    {
                                        self.getImageDataFromUrl(self.newsItem.imageURL, pref: 1)
                                    }
                                    else
                                    {
                                        self.setupView()
                                    }
                                
                                }
                        }
                        else
                        {
                            dispatch_async(dispatch_get_main_queue())
                                {
                                    self.setupView()
                                }
                        }
                    }
                }
                
                if pref == 1
                {
                    self.newsItem.imageData = data
                    if data == nil
                    {
                        self.newsItem.imageURL = "Empty"
                    }
                    dispatch_async(dispatch_get_main_queue())
                        {
                            self.setupView()
                    }
                }
            }
    }
    
}
