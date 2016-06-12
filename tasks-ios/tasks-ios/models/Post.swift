//
//  Post.swift
//  tasks-ios
//
//  Created by Katrina Rodriguez on 6/5/16.
//  Copyright © 2016 Kat. All rights reserved.
//

import UIKit
import MapKit

class Post: NSObject, MKAnnotation {

    var id: String!
    var postTitle: String!
    var summary: String!
    var email: String!
    var lat: Double!
    var lng: Double!
    var timeStamp: NSDate!
    var formattedDate: String!
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(self.lat!, self.lng!)
    }
    
    var title: String? {
        return self.postTitle
    }
    
    var subtitle: String? {
        return self.formattedDate
    }
    
    func populate(postInfo: Dictionary<String, AnyObject>){
        
        if let _id = postInfo["_id"] as? String {
            self.id = _id
        }
        
        if let _email = postInfo["email"] as? String {
            self.email = _email
        }
        
        if let _description = postInfo["description"] as? String {
            self.summary = _description
        }
        
        if let _title = postInfo["title"] as? String {
            self.postTitle = _title
        }
        
        if let _timestamp = postInfo["timestamp"] as? String {
      
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // 2016-06-05T19:12:00.209Z
            self.timeStamp = dateFormatter.dateFromString(_timestamp)
            
             print("TIMESTAMP: \(self.timeStamp)")
            
            dateFormatter.dateFormat = "MMM dd, yyyy" // "May 16, 2015"
            self.formattedDate = dateFormatter.stringFromDate(self.timeStamp)
            print("Formatted Date: \(self.formattedDate)")

        }
        
        if let _geo = postInfo["geo"] as? Array<Double> {
            self.lat = _geo[0]
            self.lng = _geo[1]
        }
    }
}
