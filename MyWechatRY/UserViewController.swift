//
//  UserViewController.swift
//  MyWechatRY
//
//  Created by 王凯 on 16/5/10.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    let identifierValue = String(userDefault.objectForKey("identifier")!)
    @IBAction func exit(sender: AnyObject) {
        userDefault.setObject(nil, forKey: "identifier")
        userDefault.setObject(nil, forKey: "token")
        userDefault.setObject(nil, forKey: "portrait")
        friendsList.removeAll()
        friendFlag = true
        
        
    }
    @IBOutlet weak var headPortrait: UIImageView!
    
    @IBOutlet weak var UserName: UILabel!
    
    
    override func viewDidLoad() {
        headPortrait.layer.cornerRadius = self.headPortrait.bounds.width/2 - 29
        headPortrait.clipsToBounds = true
        
        
        let userPortraitFlag = userDefault.objectForKey("portrait")
        if userPortraitFlag == nil{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let imageURL = NSURL(string: portrait)
                let imageData = NSData(contentsOfURL: imageURL!)
                dispatch_async(dispatch_get_main_queue(), {
                    
                    
                    
                    let smallImage = UIImageJPEGRepresentation(UIImage(data: imageData!)!, 0.3)
                    
                    self.headPortrait.image = UIImage(data: smallImage!)
                    userDefault.setObject(smallImage, forKey: "portrait")
                    
                    
                    print("3")
                })
                
                

                
            }
        }else{
            
            
            let userPortraitData:NSData = userDefault.objectForKey("portrait") as! NSData

            let userPortrait = UIImage(data: userPortraitData)
            self.headPortrait.image = userPortrait
        
        }
        UserName.text = identifierValue
    }
    
    
   
    
}
