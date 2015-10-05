//
//  TheGuardianAPI.swift
//  NewsApp
//
//  Created by Saurabh Arora on 27/09/15.
//  Copyright (c) 2015 Saurabh Arora. All rights reserved.
//

import Foundation

class TheGuardianAPI{
    
    
    static func loadSavedArticles() -> [TheGuardianNewsData]?
    {
            return NSKeyedUnarchiver.unarchiveObjectWithFile(TheGuardianNewsData.ArchiveURL.path!) as? [TheGuardianNewsData]
    }
    
    
    static func fetchData(topic: String)
    {
        var url = NSURL(string: "http://content.guardianapis.com/search?q=\(topic)&api-key=test&show-elements=image&show-blocks=all&order-by=relevance&page-size=45")
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            var dict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil) as! NSDictionary
            var dataReceived = dict["response"]! as! NSDictionary
            var results = dataReceived["results"] as! [AnyObject]
            print(results[0])
        })
        
        task.resume()
    }
    
    static func getImageURL(htmlText: String?) -> String
    {
        if htmlText == nil
        {
            return "Empty"
        }
        var result = ""
        let myNSString = htmlText! as NSString
        for var i = 0; i < myNSString.length - 8; i = i+1
        {
           if myNSString.substringWithRange(NSRange(location: i, length: 8)) == "img src="
           {
            var j = i+9
            var tmpStr = ""
            while tmpStr != "\""
            {
                result = result + tmpStr
                tmpStr = myNSString.substringWithRange(NSRange(location: j, length: 1))
                j = j+1
            }
            }
        }
        return result
    }
    
    static func insertLineBreaks(rawText: String) -> String
    {
        var lineBreakDue = false
        var spaceCount = 0
        var myNSSTring = rawText as NSString
        for var i = 2; i < myNSSTring.length-2; i++
        {
            if myNSSTring.substringWithRange(NSRange(location: i, length: 1)) == " "
            {
                spaceCount = spaceCount + 1
                if myNSSTring.substringWithRange(NSRange(location: i-1, length: 1)) == "."
                {
                    if spaceCount >= 150
                    {
                        lineBreakDue = true
                    }
                }
            }
            
            if lineBreakDue
            {
                lineBreakDue = false
                spaceCount = 0
                if myNSSTring.substringWithRange(NSRange(location: i+1, length: 1)) == "”"
                {
                    i = i + 1
                }
                
                var newString = myNSSTring.substringToIndex(i+1) + "\n \n" + myNSSTring.substringFromIndex(i+1)
                myNSSTring = newString
            }
        }
        
        return myNSSTring as! String
    }
    
    
}