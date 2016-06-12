//
//  ListViewController.swift
//  tasks-ios
//
//  Created by Katrina Rodriguez on 6/5/16.
//  Copyright © 2016 Kat. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var postsTable: UITableView?
    var posts = Array<Post>()
    

    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "List"
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self,
                                       selector: #selector(ListViewController.postsReceived(_:)),
                                       name: Constants.kPostsReceivedNotification,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(ListViewController.postCreated(_:)),
                                       name: Constants.kPostCreatedNotification,
                                       object: nil)
        
    }
    
    override func loadView() {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.yellowColor()
        self.view = view
        
        let tableFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height - 44)
        
        self.postsTable = UITableView(frame: tableFrame, style: .Plain)
        self.postsTable!.delegate = self
        self.postsTable!.dataSource = self
//        self.posts.contentInset = UIEdgeInsetsMake(0, 0, 44, 0) // make room/padding for navbar
        view.addSubview(postsTable!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func postsReceived(notification: NSNotification){
        
        let pkg = notification.userInfo!
        
        print("postsReceived: \(notification.userInfo!)")
        
        if let posts = pkg["posts"] as? Array<Post>{
            print(" \(posts.count) Posts Received")
            self.posts = posts
            
            if (self.postsTable != nil){
                self.postsTable!.reloadData()
            }

        }
    }
    
    //MARK: - TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let posts = self.posts[indexPath.row]
        let cellId = "cellId"
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellId){
            cell.textLabel?.text = posts.postTitle
            cell.detailTextLabel?.text = posts.formattedDate
            return cell
        }
        
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        cell.textLabel?.text = posts.postTitle
        cell.detailTextLabel?.text = posts.formattedDate
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let post = self.posts[indexPath.row]
        let postVc = PostViewController()
        self.navigationController?.pushViewController(postVc, animated: true)
        
    }
    
    func postCreated(notification: NSNotification){
        print("postCreated: \(notification)")
        if let post = notification.userInfo!["post"] as? Post {
            
           self.posts.append(post)
            if (self.postsTable != nil){
                self.postsTable!.reloadData()
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
