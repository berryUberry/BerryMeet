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
    @IBOutlet weak var friendsListTableView: UITableView!
    
    @IBAction func addFriendsAction(sender: AnyObject) {
        //let addFriendsViewController = AddFriendsViewController()
        
        //self.navigationController?.pushViewController(addFriendsViewController, animated: true)
        self.performSegueWithIdentifier("addfriends", sender: self)
        self.tabBarController?.tabBar.hidden = true
        
    }
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
//        let friends2 = userDefault.objectForKey("\(self.identifierValue)")
//        if friends2 != nil{
//            friends = userDefault.objectForKey("\(self.identifierValue)") as! Array<String>
//        
//        }
//        
//        print(friends2)
//        print("asdfasdfsdfddddddddsaaaa")
//        if friends2 != nil && friendFlag == true{
//            for i in friends2 as! Array<String>{
//                print(i)
//                let friends3 = Friends(id: i, name: i, portrait: portrait)
//                friendsList.append(friends3)
//                
//            }
//        }
        //
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
        let conversationViewController = ConversationViewController()
        conversationViewController.targetId = friendsList[indexPath.row].id
        //conversationViewController.userName = friendsList[indexPath.row].name
        conversationViewController.conversationType = .ConversationType_PRIVATE
        conversationViewController.title = friendsList[indexPath.row].name
        
        
        self.navigationController?.pushViewController(conversationViewController, animated: true)
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
            
            //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            //                let imageURL = NSURL(string: portrait)
            //                let imageData = NSData(contentsOfURL: imageURL!)
            //                let smallImage = UIImageJPEGRepresentation(UIImage(data: imageData!)!, 0.3)
            //                dispatch_async(dispatch_get_main_queue(), {
            //                    cell.photoImage.image = UIImage(data: smallImage!)
            //
            //
            //                    userDefault.setObject(smallImage, forKey: "portrait")
            //                    print("1")
            //                })
            //
            //
            //
            //            }
        }else{
            
            //            let userPortraitData:NSData = userDefault.objectForKey("portrait") as! NSData
            //
            //            let userPortrait = UIImage(data: userPortraitData)
            //            cell.photoImage.image = userPortrait
            
            
    
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    let imageURL = NSURL(string: userPortraitFlag[indexPath.row].portrait)
                    let imageData = NSData(contentsOfURL: imageURL!)
                    if imageData == nil{
                        dispatch_async(dispatch_get_main_queue(), {
                            ce.photoImage.image = UIImage(named: "xixi")
                        })
                        
                    }else{
                        let smallImage = UIImageJPEGRepresentation(UIImage(data: imageData!)!, 0.1)
                        dispatch_async(dispatch_get_main_queue(), {
                            ce.photoImage.image = UIImage(data: smallImage!)
                        })
                    }
                
                
                print("here2")
            })
            
            
            
            
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

}
