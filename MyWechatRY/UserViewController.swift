//
//  UserViewController.swift
//  MyWechatRY
//
//  Created by 王凯 on 16/5/10.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit
import Qiniu

class UserViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    let identifierValue = String(userDefault.objectForKey("identifier")!)
    
    var image:NSData!
    @IBAction func exit(sender: AnyObject) {
        userDefault.setObject(nil, forKey: "identifier")
        userDefault.setObject(nil, forKey: "token")
        userDefault.setObject("", forKey: "portrait")
        friendsList.removeAll()
        friendFlag = true
        
        
    }
    

    @IBAction func changePortrait(sender: AnyObject) {
        
        
        let pick:UIImagePickerController = UIImagePickerController()
        pick.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            print("canmera")
        }
        
        self.presentViewController(pick, animated: true, completion: nil)

        
        
        
        
        
    }
    

    @IBOutlet weak var exitButton: UIButton!
    
    @IBOutlet weak var UserName: UILabel!
    
    @IBOutlet weak var imageButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let userPortraitFlag = userDefault.objectForKey("portrait") as! String
        print(userPortraitFlag)
        if userPortraitFlag != ""{
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let imageURL = NSURL(string: userPortraitFlag)
                let imageData = NSData(contentsOfURL: imageURL!)
                
                
                if imageData == nil{
                    dispatch_async(dispatch_get_main_queue(), {
                        self.imageButton.setImage(UIImage(named: "xixi"), forState: .Normal)
                    })
                    
                    
                }else{
                    let smallImage = UIImageJPEGRepresentation(UIImage(data: imageData!)!, 0.3)
                    dispatch_async(dispatch_get_main_queue(), {
                    
                    self.imageButton.setImage(UIImage(data: smallImage!), forState: .Normal)
                    
                    
                    print("3")
                })
                
                }
                
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        
        
        exitButton.layer.cornerRadius = 10
        
        
        UserName.text = identifierValue
    }
    
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let gotInfo = info[UIImagePickerControllerOriginalImage] as! UIImage
    
        image = UIImageJPEGRepresentation(gotInfo, 0.1)
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
        
        
        
        connectPost()
        
        
        
        
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
    
    func connectPost(){
    
        print("send")
        do{
            
            var response:NSURLResponse?
            let urlString:String = "\(ip)/app.changeavatar"
            var url:NSURL!
            url = NSURL(string:urlString)
            let request = NSMutableURLRequest(URL:url)
            let body = "account=\(identifierValue)"
            //编码POST数据
            let postData = body.dataUsingEncoding(NSASCIIStringEncoding)
            //保用 POST 提交
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            
            
            let data:NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
            let dict:AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            let dic = dict as! NSDictionary
            print(dic)
            let status = dic.objectForKey("status") as! String
            switch status {
            case "700":
                let kToken = dic.objectForKey("token") as! String
                let kFilename = dic.objectForKey("filename") as! String
                
                //let upManager = QNUploadManager()
                let upManager = QNUploadManager()
                upManager.putData(image, key: kFilename, token: kToken, complete: { (info, key, response) in
                    if let info = info{
                        print("info: \(info)")
                    
                    }
                    if let res = response{
                        print("res: \(res)")
                    }
                    let dateTime = NSDate()
                    let timeInterval = dateTime.timeIntervalSince1970 * 1000
                    print(timeInterval)
                    let headImageURL = "\(avatarURLHeader)userAvatar/\(self.identifierValue).jpeg?v=\(timeInterval)"
                    userDefault.setObject(headImageURL, forKey: "portrait")
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        let imageURL = NSURL(string: headImageURL)
                        let imageData = NSData(contentsOfURL: imageURL!)
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            
                            
                            let smallImage = UIImageJPEGRepresentation(UIImage(data: imageData!)!, 0.3)
                            
                            self.imageButton.setImage(UIImage(data: smallImage!), forState: .Normal)
                            
                            
                            print("3")
                        })
                        
                        
                        
                        
                    }
                    
                    }, option: nil)
                
                
            default:
                return
            }
            
            
        }catch{
            
            print(error)
            
        }
    
    
    }
    
}
