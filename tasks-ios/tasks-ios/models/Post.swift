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
    var postTitle: String!
    var summary: String!
    var email: String!
    var lat: Double!
    var lng: Double!
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(self.lat!, self.lng!)
    }
    
    var title: String? {
        return self.postTitle
    }
    
    var subtitle: String? {
        return self.summary
    }
    
    func populate(postInfo: Dictionary<String, AnyObject>){
        if let _email = postInfo["email"] as? String {
            self.email = _email
        }
        
        if let _description = postInfo["description"] as? String {
            self.summary = _description
        }
        
        if let _title = postInfo["title"] as? String {
            self.postTitle = _title
        }
        
        if let _geo = postInfo["geo"] as? Array<Double> {
            self.lat = _geo[0]
            self.lng = _geo[1]
        }
    }
}
