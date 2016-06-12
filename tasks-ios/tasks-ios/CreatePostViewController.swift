//
//  CreatePostViewController.swift
//  tasks-ios
//
//  Created by Katrina Rodriguez on 6/5/16.
//  Copyright © 2016 Kat. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class CreatePostViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var titleField: UITextField!
    var descriptionField: UITextView!
    var emailField: UITextField!
    var currentLocation: CLLocationCoordinate2D!
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Create Post"
    }
    
    override func loadView(){
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.lightGrayColor()
        self.view = view
        
        let padding = CGFloat(20)
        var y = CGFloat(20)
        let width = frame.size.width-2*padding
        
        let btnBack = UIButton(type: .Custom)
        btnBack.setTitle("Back", forState: .Normal)
        btnBack.frame = CGRect(x: padding, y: y, width: 80, height: 32)
        btnBack.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        view.addSubview(btnBack)
        y += btnBack.frame.size.height+padding
        
        let action = #selector(CreatePostViewController.exit(_:))
        btnBack.addTarget(self,
                          action: action,
                          forControlEvents: .TouchUpInside)
        
        self.titleField = UITextField(frame: CGRect(x: padding, y: y, width: width, height: 32))
        self.titleField.backgroundColor = .redColor()
        self.titleField.placeholder = "Title"
        self.titleField.delegate = self
        view.addSubview(self.titleField)
        
        y += self.titleField.frame.size.height+padding
        
        self.descriptionField = UITextView(frame: CGRect(x: padding, y: y, width: width, height: 100))
        self.descriptionField.backgroundColor = .blueColor()
        view.addSubview(self.descriptionField)
        
        y += self.descriptionField.frame.size.height+padding
        
        self.emailField = UITextField(frame: CGRect(x: padding, y: y, width: width, height: 32))
        self.emailField.backgroundColor = .greenColor()
        self.emailField.placeholder = "Email"
        self.emailField.delegate = self
        view.addSubview(self.emailField)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let placeholder = textField.placeholder!.lowercaseString
//        print("textFieldShouldReturn: \(placeholder)")
        
        if (placeholder == "email"){
            var postInfo = Dictionary<String, AnyObject>()
            postInfo["title"] = self.titleField.text!
            postInfo["description"] = self.descriptionField.text!
            postInfo["email"] = self.emailField.text!
            postInfo["geo"] = [self.currentLocation.latitude, self.currentLocation.longitude]
//            print("CREATE POST: \(postInfo)")
            
            let url = Constants.kBaseUrl + "/api/post"
            Alamofire.request(.POST, url, parameters: postInfo).responseJSON { response in
                if let json = response.result.value as? Dictionary<String, AnyObject>{
                    print("\(json)")
                    
                    if let postInfo = json["result"] as? Dictionary<String, AnyObject>{
                        let post = Post()
                        post.populate(postInfo)
                        
                        let notification = NSNotification(
                            name: Constants.kPostCreatedNotification,
                            object: nil,
                            userInfo: ["post": post]
                        )
                        
                        let notificationCenter = NSNotificationCenter.defaultCenter()
                        notificationCenter.postNotification(notification)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.dismissViewControllerAnimated(true, completion: nil)
                        })
                    }
                }
            }

            return true
        }
        
        self.titleField.resignFirstResponder()
        self.emailField.resignFirstResponder()
        
        return true
    }
    
    //MARK: - Custom Functions
    func exit(btn: UIButton){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
