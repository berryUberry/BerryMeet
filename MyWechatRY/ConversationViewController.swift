//
//  ConversationViewController.swift
//  MyWechatRY
//
//  Created by 王凯 on 16/4/25.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit

class ConversationViewController: RCConversationViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.targetId = RCIMClient.sharedRCIMClient().currentUserInfo.userId
//        self.userName = RCIMClient.sharedRCIMClient().currentUserInfo.name
//        self.conversationType = RCConversationType.ConversationType_PRIVATE
//        self.title = self.userName
        self.setMessageAvatarStyle(RCUserAvatarStyle.USER_AVATAR_CYCLE)
              

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   

}
