//
//  CircleOfFriendModel.swift
//  MyWechatRY
//
//  Created by 王凯 on 16/5/9.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit

class CircleOfFriendModel {
    
    internal var name:String
    internal var text:String
    internal var image:UIImage
    internal var portraitUri:String
    
    init(name:String,text:String,image:UIImage,portraitUri:String){
        self.name = name
        self.text = text
        self.image = image
        self.portraitUri = portraitUri
    
    }
    func encodeWithCoder(_encoder:NSCoder){
    
        _encoder.encodeObject(self.name, forKey: "name")
        _encoder.encodeObject(self.text, forKey: "text")
        _encoder.encodeObject(self.image, forKey: "image")
        _encoder.encodeObject(self.portraitUri, forKey: "portraitUri")
    
    }
    
    init(coder decoder:NSCoder){
        name = decoder.decodeObjectForKey("name") as! String
        text = decoder.decodeObjectForKey("text") as! String
        image = decoder.decodeObjectForKey("image") as! UIImage
        portraitUri = decoder.decodeObjectForKey("portraitUri") as! String
        
    
    }
    
}



