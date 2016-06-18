//
//  Friends.swift
//  MyWechatRY
//
//  Created by 王凯 on 16/5/6.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit

class Friends:NSObject,NSCoding{

    var id:String!
    var name:String!
    var portrait:String!

    init(id:String,name:String,portrait:String){
    
        self.id = id
        self.name = name
        self.portrait = portrait
    
    }

    func encodeWithCoder(_encoder:NSCoder){
        
        _encoder.encodeObject(self.id, forKey: "id")
        _encoder.encodeObject(self.name, forKey: "name")
        _encoder.encodeObject(self.portrait, forKey: "portrait")
        
        
    }
    
    required init(coder decoder:NSCoder){
        id = decoder.decodeObjectForKey("id") as! String
        name = decoder.decodeObjectForKey("name") as! String
        portrait = decoder.decodeObjectForKey("portrait") as! String
        
        
    }
}
