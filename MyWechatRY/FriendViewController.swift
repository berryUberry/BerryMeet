//
//  FriendViewController.swift
//  MyWechatRY
//
//  Created by 王凯 on 16/5/6.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit




class FriendViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let identifierValue = String(userDefault.objectForKey("identifier")!)
    var selectedName:String!
    @IBOutlet weak var friendsListTableView: UITableView!
    
    @IBAction func addFriendsAction(sender: AnyObject) {

        self.performSegueWithIdentifier("addfriends", sender: self)
        self.tabBarController?.tabBar.hidden = true
        
    }
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)

        print("friendList\(friendsList.count)")
        if friendFlag == true{
            let userData = userDefault.objectForKey("\(identifierValue)friendsList") as! NSData
            let user = NSKeyedUnarchiver.unarchiveObjectWithData(userData) as! Array<Friends>
            
            for i in user{
                print(i.id)
                friendsList.append(i)
            }
            
            friendFlag = false
        }
        
        
        self.friendsListTableView.reloadData()
        
        
        
        self.tabBarController?.tabBar.hidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        selectedName = friendsList[indexPath.row].id
        self.performSegueWithIdentifier("friendToPersonal", sender: self)
        
        self.tabBarController?.tabBar.hidden = true
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let ce = cell as! FriendCell
        
        let userPortraitFlagData = userDefault.objectForKey("\(identifierValue)friendsList") as! NSData
        let userPortraitFlag = NSKeyedUnarchiver.unarchiveObjectWithData(userPortraitFlagData) as! Array<Friends>
        if userPortraitFlag[indexPath.row].portrait == portrait{
            
            ce.photoImage.image = UIImage(named: "xixi")
            
            
        }else{
            
            
            if userDefault.objectForKey("\(userPortraitFlag[indexPath.row].id)Head") as? NSData != nil{
                ce.photoImage.image = UIImage(data: userDefault.objectForKey("\(userPortraitFlag[indexPath.row].id)Head") as! NSData)
                
            }else{
            
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    
                    let dateTime = NSDate()
                    let timeInterval = dateTime.timeIntervalSince1970
                    let url = String("\(userPortraitFlag[indexPath.row].portrait)?v=\(Int(timeInterval))")
                    
                    let imageURL = NSURL(string: url)
                    let imageData = NSData(contentsOfURL: imageURL!)
                    if imageData == nil{
                        dispatch_async(dispatch_get_main_queue(), {
                            ce.photoImage.image = UIImage(named: "xixi")
                        })
                        
                    }else{
                        let smallImage = UIImageJPEGRepresentation(UIImage(data: imageData!)!, 0.1)
                        userDefault.setObject(smallImage, forKey: "\(userPortraitFlag[indexPath.row].id)Head")
                        dispatch_async(dispatch_get_main_queue(), {
                            ce.photoImage.image = UIImage(data: smallImage!)
                        })
                    }
                    
                    
                    print("here2")
                })

                
            
            }
            
            
        }
        
        
        ce.nameLabel.text = friendsList[indexPath.row].name
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        print("here")
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! FriendCell
        
        
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "friendToPersonal"{
            let VC = segue.destinationViewController as! PersonalViewController
            VC.name = selectedName
            VC.isYourself = false
        }
    }

}
