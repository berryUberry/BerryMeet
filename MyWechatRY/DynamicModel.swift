//
//  DynamicModel.swift
//  MyWechatRY
//
//  Created by 王凯 on 16/5/30.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit

class DynamicModel{

    var userPortraitUrl:String!
    var userName:String!
    var dynamic:String!
    var thumbUpNumber:Int!
    var isThumbUp:Bool!
    var joinNumber:Int!
    var isJoin:Bool!
    var commentsNumber:Int!

    init(userPortraitUrl:String,userName:String,dynamic:String,thumbUpNumber:Int,isThumbUp:Bool,joinNumber:Int,isJoin:Bool,commentsNumber:Int){
        self.userPortraitUrl = userPortraitUrl
        self.userName = userName
        self.dynamic = dynamic
        self.thumbUpNumber = thumbUpNumber
        self.joinNumber = joinNumber
        self.commentsNumber = commentsNumber
        self.isThumbUp = isThumbUp
        self.isJoin = isJoin
    
    }

}
