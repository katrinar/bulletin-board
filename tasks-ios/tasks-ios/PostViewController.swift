//
//  PostViewController.swift
//  tasks-ios
//
//  Created by Katrina Rodriguez on 6/12/16.
//  Copyright © 2016 Kat. All rights reserved.
//

import UIKit
import Alamofire

class PostViewController: UIViewController, UITextFieldDelegate {
    
    var post: Post!
    var postSummary: UILabel!
    var replyLabel: UILabel!
    var textFields = Array<UITextField>()

    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Post"
        
    }
    
    override func loadView() {
        self.edgesForExtendedLayout = .None
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.whiteColor()
        self.view = view
        
        self.title = post.postTitle
        
        let originX = frame.width * 0.5
        let font = UIFont(name: "Heiti SC", size: 18)
        let padding = CGFloat(20)

        let width = frame.size.width-2*padding

        self.replyLabel = UILabel(frame: CGRect(x: padding, y: 0, width: width, height: 32))
        self.replyLabel.text = "Reply to this Post"
        var y = replyLabel.frame.origin.y+replyLabel.frame.size.height+20

        view.addSubview(replyLabel)
        
        let str = NSString(string: self.post.summary)
        let bounds = str.boundingRectWithSize(CGSizeMake(frame.size.width-40, 300), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font!], context: nil)

        self.postSummary = UILabel(frame: CGRect(x: padding, y: y, width: width, height: bounds.size.height))
        self.postSummary.text = self.post.summary
        self.postSummary.numberOfLines = 0
        self.postSummary.lineBreakMode = .ByWordWrapping
        y += postSummary.frame.size.height+20
        view.addSubview(postSummary)
        
        let height = CGFloat(32)
        
        let fieldNames = ["Reply", "From"]
        for fieldName in fieldNames {
            let field = UITextField(frame: CGRect(x: padding, y: y, width: width, height: height))
            field.placeholder = fieldName
            field.delegate = self
            field.font = font
            field.autocorrectionType = .No
            let line = UIView(frame: CGRect(x: 0, y: height-1, width: width, height: 1))
            line.backgroundColor = .blackColor()
            field.addSubview(line)
            view.addSubview(field)
            self.textFields.append(field)
            y += height+padding
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let index = self.textFields.indexOf(textField)
        print("textFieldShouldReturn: \(index)")
        
        var replyInfo = Dictionary<String, AnyObject>()
        for textField in self.textFields {
            let placeholder = textField.placeholder?.lowercaseString
            replyInfo[placeholder!] = textField.text!
            replyInfo["post"] = self.post.id
            replyInfo["to"] = self.post.email
            
        }
        
        print("\(replyInfo)")

        let url = Constants.kBaseUrl + "/api/reply"
        Alamofire.request(.POST, url, parameters: replyInfo).responseJSON { response in
            if let json = response.result.value as? Dictionary<String, AnyObject>{
                print("\(json)")
                
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        
        
//        print("\(replyInfo)")
       
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("POST: \(self.post.postTitle)")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   }
