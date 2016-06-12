//
//  MapViewController.swift
//  tasks-ios
//
//  Created by Katrina Rodriguez on 6/5/16.
//  Copyright © 2016 Kat. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var posts = Array<Post>()
    
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Map"
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(
            self,
            selector: #selector(MapViewController.postCreated(_:)),
            name: Constants.kPostCreatedNotification,
            object: nil
        )
    }
    
    override func loadView() {
        self.edgesForExtendedLayout = .None
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.brownColor()
        self.view = view
        
        self.mapView = MKMapView(frame: frame)
        self.mapView.delegate = self
        view.addSubview(mapView)
        
        let padding = CGFloat(20)
        let height = CGFloat(44)
        
        let btnCreate = UIButton(type: .Custom)
        btnCreate.frame = CGRect(x: padding, y: padding+44, width: frame.size.width-2*padding, height: height)
        btnCreate.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        btnCreate.setTitle("Create Post Here", forState: .Normal)
        btnCreate.layer.borderColor = UIColor.whiteColor().CGColor
        btnCreate.layer.borderWidth = 2
        btnCreate.layer.cornerRadius = 0.5*height
        btnCreate.layer.masksToBounds = true
        view.addSubview(btnCreate)
    
        let action = #selector(MapViewController.showCreatePost(_:))
        btnCreate.addTarget(self,
                            action: action,
                            forControlEvents: .TouchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    //MARK: - LocationManagerDelegate
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == .AuthorizedWhenInUse){
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        self.locationManager.stopUpdatingLocation()
        let coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        self.mapView.centerCoordinate = coordinate
        let regionRadius = CLLocationDistance(500)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(self.mapView.centerCoordinate, regionRadius, regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
        
        
        let url = "http://localhost:3000/api/post"
        Alamofire.request(.GET, url, parameters: nil).responseJSON { response in
            
            if let json = response.result.value as? Dictionary<String, AnyObject> {
                if let results = json["results"] as? Array<Dictionary<String, AnyObject>> {
                    
                    for postInfo in results {
                        let post = Post()
                        post.populate(postInfo)
                        self.posts.append(post)
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.mapView.addAnnotations(self.posts)
                        
                        let notification = NSNotification(
                            name: Constants.kPostsReceivedNotification,
                            object: nil,
                            userInfo: ["posts":self.posts]
                        )
                        
                        let notificationCenter = NSNotificationCenter.defaultCenter()
                        notificationCenter.postNotification(notification)
                    })
                }
            }
        }
    }
    
    //MARK: - MapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let pinId = "pin"
        if let pin = mapView.dequeueReusableAnnotationViewWithIdentifier(pinId) as? MKPinAnnotationView{
            pin.annotation = annotation
            return pin
        }
        
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinId)
        pin.animatesDrop = true
        pin.canShowCallout = true
        
        let btnDetail = UIButton(type: .Custom)
        btnDetail.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let accessoryBtn = UIButton(type: .InfoDark)
        pin.rightCalloutAccessoryView = accessoryBtn
        
        return pin
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let post = view.annotation as? Post
      

        print("\(post?.postTitle)")
        let postVc = PostViewController()
        postVc.post = post
        self.navigationController?.pushViewController(postVc, animated: true)

    }
    
    //MARK: - Custom Functions
    func showCreatePost(btn: UIButton){
        let createPostVc = CreatePostViewController()
        createPostVc.currentLocation = self.mapView.centerCoordinate
        self.presentViewController(createPostVc, animated: true, completion: nil)
    }
    
    func postCreated(notification: NSNotification){
        print("postCreated: \(notification)")
        if let post = notification.userInfo!["post"] as? Post {
            dispatch_async(dispatch_get_main_queue(), {
                self.mapView.addAnnotation(post)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
