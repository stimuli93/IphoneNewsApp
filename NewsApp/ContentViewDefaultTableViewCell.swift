//
//  ContentViewDefaultTableViewCell.swift
//  NewsApp
//
//  Created by Saurabh Arora on 28/09/15.
//  Copyright (c) 2015 Saurabh Arora. All rights reserved.
//

import UIKit

class ContentViewDefaultTableViewCell: UITableViewCell {

    var newsImage: UIImage?{
        didSet{
            newsImageView?.image = newsImage
        }
    }
    var newsTitle = ""{
        didSet{
            newsLabel?.text = newsTitle
        }
        
    }

    @IBOutlet var newsImageView: UIImageView!{
        didSet{
            newsImageView?.image = newsImage
        }
    }

    @IBOutlet var newsLabel: UILabel!{
        didSet{
            newsLabel?.text = newsTitle
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
}
