//
//  ConversationListViewController.swift
//  MyWechatRY
//
//  Created by 王凯 on 16/4/25.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit

class ConversationListViewController: RCConversationListViewController {

    @IBAction func toFriendTabbar(sender: AnyObject) {
        self.tabBarController?.selectedIndex = 1
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let appDeletage = UIApplication.sharedApplication().delegate as! AppDelegate
//        appDeletage.connectServer { 
//            () -> Void in
//
//            
//            print("连接成功")
//            
//        }
        
        self.setDisplayConversationTypes([
            
            RCConversationType.ConversationType_GROUP.rawValue,
            RCConversationType.ConversationType_SYSTEM.rawValue,
            RCConversationType.ConversationType_PRIVATE.rawValue,
            RCConversationType.ConversationType_CHATROOM.rawValue,
            RCConversationType.ConversationType_APPSERVICE.rawValue,
            RCConversationType.ConversationType_DISCUSSION.rawValue,
            RCConversationType.ConversationType_PUSHSERVICE.rawValue,
            RCConversationType.ConversationType_PUBLICSERVICE.rawValue
            
            
            ])
        
        self.refreshConversationTableViewIfNeeded()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    
    override func onSelectedTableRow(conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, atIndexPath indexPath: NSIndexPath!) {
        
            let conversationViewController = ConversationViewController()
            conversationViewController.targetId = model.targetId
            //conversationViewController.userName = model.conversationTitle
            conversationViewController.conversationType = .ConversationType_PRIVATE
            conversationViewController.title = model.conversationTitle
        
            
            self.navigationController?.pushViewController(conversationViewController, animated: true)
            self.tabBarController?.tabBar.hidden = true
        
        
            
        
        
        
    }
    
    
    
    

}
