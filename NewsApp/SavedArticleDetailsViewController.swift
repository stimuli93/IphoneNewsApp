//
//  SavedArticleDetailsViewController.swift
//  NewsApp
//
//  Created by Saurabh Arora on 30/09/15.
//  Copyright (c) 2015 Saurabh Arora. All rights reserved.
//

import UIKit

class SavedArticleDetailsViewController: UIViewController {

    var newsItem = TheGuardianNewsData(title: "", imageURL: "", bodyText: "", detailImageURL: "", imageData: nil, detailImageData: nil)
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButton.target = self
        shareButton.action = Selector("shareAction:")
        setupView()
    }
    
    func shareAction(sender: UIBarButtonItem)
    {
        let string = TheGuardianAPI.insertLineBreaks(newsItem.bodyText)
        var image = UIImage(named: "default")
        if newsItem.imageData != nil
        {
            image = UIImage(data: newsItem.imageData!)
        }
        let activityViewController = UIActivityViewController(activityItems: [image! , string], applicationActivities: nil)
        navigationController?.presentViewController(activityViewController, animated: true) {
            // ...
        }
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
        }
        else
        {
            if newsItem.detailImageURL == "Empty"
            {
                if newsItem.imageData != nil
                {
                    imageView.image = UIImage(data: newsItem.imageData!)
                }
                else if newsItem.imageURL == "Empty"
                {
                    imageView.image = UIImage(named: "default")
                    
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
}
