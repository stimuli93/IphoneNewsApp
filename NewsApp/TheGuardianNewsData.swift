//
//  TheGuardianNewsData.swift
//  NewsApp
//
//  Created by Saurabh Arora on 27/09/15.
//  Copyright (c) 2015 Saurabh Arora. All rights reserved.
//

import Foundation

class TheGuardianNewsData: NSObject, NSCoding{
    
    //MARK: - Properties
    var title = ""
    var imageURL = ""
    var imageData : NSData?
    var bodyText = ""
    var detailImageURL = ""
    var detailImageData : NSData?
    
    required init(title: String,imageURL: String,bodyText: String , detailImageURL: String , imageData: NSData?, detailImageData: NSData?)
    {
        self.title = title
        self.imageURL = imageURL
        self.imageData = imageData
        self.bodyText = bodyText
        self.detailImageURL = detailImageURL
        self.detailImageData = detailImageData
        super.init()
    }
    
    struct PropertyKey{
        static let titleKey = "title"
        static let imageURLKey = "imageURL"
        static let imageDataKey = "imageData"
        static let bodyTextKey = "bodyText"
        static let detailImageURLKey = "detailImageURL"
        static let detailImageDataKey = "detailImageData"
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: PropertyKey.titleKey)
        aCoder.encodeObject(imageURL, forKey: PropertyKey.imageURLKey)
        aCoder.encodeObject(imageData, forKey: PropertyKey.imageDataKey)
        aCoder.encodeObject(bodyText, forKey: PropertyKey.bodyTextKey)
        aCoder.encodeObject(detailImageURL, forKey: PropertyKey.detailImageURLKey)
        aCoder.encodeObject(detailImageData, forKey: PropertyKey.detailImageDataKey)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObjectForKey(PropertyKey.titleKey) as! String
        let imageURL = aDecoder.decodeObjectForKey(PropertyKey.imageURLKey) as! String
        let imageData = aDecoder.decodeObjectForKey(PropertyKey.imageDataKey) as? NSData
        let bodyText = aDecoder.decodeObjectForKey(PropertyKey.bodyTextKey) as! String
        let detailImageURL = aDecoder.decodeObjectForKey(PropertyKey.detailImageURLKey) as! String
        let detailImageData = aDecoder.decodeObjectForKey(PropertyKey.detailImageDataKey) as? NSData
        
        self.init(title: title, imageURL: imageURL, bodyText: bodyText, detailImageURL: detailImageURL, imageData: imageData, detailImageData: detailImageData)
    }
    
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory: AnyObject = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("NewsData")
    
    
}