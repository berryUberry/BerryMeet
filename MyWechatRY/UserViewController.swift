//
//  UserViewController.swift
//  MyWechatRY
//
//  Created by 王凯 on 16/5/10.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit
import Qiniu

class UserViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource{

    let identifierValue = String(userDefault.objectForKey("identifier")!)
    var myDynamic = Array<DynamicModel>()
    var dynamicForComment:DynamicModel!
    var thumbUpUsers = Array<Array<Friends>>()
    var thumbUpUserForComment = Array<Friends>()
    var DyHeight = Array<CGFloat>()
    
    var image:NSData!
    var changeImg:Bool = false
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
    

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var exitButton: UIButton!
    
    @IBOutlet weak var UserName: UILabel!
    
    @IBOutlet weak var imageButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let userPortraitFlag = userDefault.objectForKey("portrait") as! String
        print(userPortraitFlag)
        if userPortraitFlag != "" && changeImg == false{
            
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
        
        tableView.delegate = self
        tableView.dataSource = self
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.getMyTimeline()
            for i in self.myDynamic{
                
                let maxLabelSize: CGSize = CGSizeMake(self.view.frame.width - 54, CGFloat(9999))
                let contentNSString = i.dynamic as NSString
                let expectedLabelSize = contentNSString.boundingRectWithSize(maxLabelSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16.0)], context: nil)
                self.DyHeight.append(expectedLabelSize.size.height+140)
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
        
    }
    
    override func viewDidLoad() {
        
        
        exitButton.layer.cornerRadius = 10
        
        
        UserName.text = identifierValue
        tableView.registerNib(UINib(nibName: "DynamicCell",bundle: nil), forCellReuseIdentifier: "cell")
        
    }
    
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let gotInfo = info[UIImagePickerControllerOriginalImage] as! UIImage
    
        image = UIImageJPEGRepresentation(gotInfo, 0.1)
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
        
        
        changeImg = true
        connectPost()
        
        
        
        
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDynamic.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return DyHeight[indexPath.row]
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "动态"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        dynamicForComment = myDynamic[indexPath.row]
        thumbUpUserForComment = thumbUpUsers[indexPath.row]
        print(thumbUpUserForComment)
        self.performSegueWithIdentifier("myToComment", sender: self)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! DynamicCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let ce = cell as! DynamicCell
        
        //点赞
        ce.thumbUp.tag = indexPath.row
        ce.thumbUp.addTarget(self, action: #selector(PersonalViewController.doThumbUp), forControlEvents: .TouchUpInside)
        
        ce.join.hidden = true
        
        if userDefault.objectForKey("\(myDynamic[indexPath.row].userName)Head") as? NSData != nil{
            
            ce.userPortrait.image = UIImage(data: userDefault.objectForKey("\(myDynamic[indexPath.row].userName)Head") as! NSData)
            
        }else{
            
            ce.userPortrait.image = UIImage(named:"xixi.jpg")
        }
        
        
        ce.userName.setTitle(myDynamic[indexPath.row].userName, forState: .Normal)
        ce.dynamicContent.text = myDynamic[indexPath.row].dynamic
        ce.dynamicContent.sizeThatFits(CGSizeMake(self.view.frame.width - 54, 9999))
        ce.dynamicContent.font = UIFont.systemFontOfSize(16.0)
        ce.dynamicContent.numberOfLines = 0
        ce.timeShow.text = myDynamic[indexPath.row].timeShow
        
        //处理点赞参与评论颜色
        if myDynamic[indexPath.row].isThumbUp == true{
            ce.thumbUp.setImage(UIImage(named: "heart-red"), forState: .Normal)
            ce.thumbUpNumber.textColor = UIColor.redColor()
            
        }else{
            ce.thumbUp.setImage(UIImage(named: "heart"), forState: .Normal)
            ce.thumbUpNumber.textColor = UIColor.blackColor()
        }
        
        if myDynamic[indexPath.row].isJoin == true{
            ce.join.setImage(UIImage(named: "hand-red"), forState: .Normal)
            ce.joinNumber.textColor = UIColor.redColor()
        }else{
            ce.join.setImage(UIImage(named: "cursor_hand"), forState: .Normal)
            ce.joinNumber.textColor = UIColor.blackColor()
        }
        
        if myDynamic[indexPath.row].thumbUpNumber == 0{
            ce.thumbUpNumber.text = ""
        }else{
            
            ce.thumbUpNumber.text = "\(myDynamic[indexPath.row].thumbUpNumber)"
        }
        if myDynamic[indexPath.row].joinNumber == 0{
            
            ce.joinNumber.text = ""
        }else{
            
            ce.joinNumber.text = "\(myDynamic[indexPath.row].joinNumber)"
        }
        if myDynamic[indexPath.row].commentsNumber == 0{
            ce.commentsNumber.text = ""
        }else{
            ce.commentsNumber.text = "\(myDynamic[indexPath.row].commentsNumber)"
        }
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
            let postData = body.dataUsingEncoding(NSUTF8StringEncoding)
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
                    
                    do{
                        
                        var response:NSURLResponse?
                        let urlString:String = "\(ip)/app.changeavatar.success"
                        var url:NSURL!
                        url = NSURL(string:urlString)
                        let request = NSMutableURLRequest(URL:url)
                        let body = "account=\(self.identifierValue)"
                        //编码POST数据
                        let postData = body.dataUsingEncoding(NSUTF8StringEncoding)
                        //保用 POST 提交
                        request.HTTPMethod = "POST"
                        request.HTTPBody = postData
                        
                        
                        let data:NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
                        let dict:AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                        let dic = dict as! NSDictionary
                        print(dic)
                        let status = dic.objectForKey("status") as! String
                        print(status)
                        switch status{
                        case "720":
                            let dateTime = NSDate()
                            let timeInterval = dateTime.timeIntervalSince1970
                            print(Int(timeInterval))
                            let headImageURL = "\(avatarURLHeader)userAvatar/\(self.identifierValue).jpeg?v=\(Int(timeInterval))"
                            print(headImageURL)
                            
                            userDefault.setObject(headImageURL, forKey: "portrait")
                            
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                                let imageURL = NSURL(string: headImageURL)
                                let imageData = NSData(contentsOfURL: imageURL!)
                                dispatch_async(dispatch_get_main_queue(), {
                                    
                                    
                                    
                                    let smallImage = UIImageJPEGRepresentation(UIImage(data: imageData!)!, 0.3)
                                    
                                    self.imageButton.setImage(UIImage(data: smallImage!), forState: .Normal)
                                    
                                    self.changeImg = false
                                    print("更改照片")
                                })
                                
                                
                                
                                
                            }
                            
                        case "730":
                            print("更改照片失败")
                        default:
                            return
                        }
                        
                    }catch{
                        print(error)
                    
                    }
                    
                    
                    
                    
                    }, option: nil)
                
                
            default:
                return
            }
            
            
        }catch{
            
            print(error)
            
        }
    
    
    }
    
    func getMyTimeline(){
        let urlString:String = "\(ip)/app.timeline.get?account=\(identifierValue)"
        let url: NSURL = NSURL(string: urlString)!
        let request1: NSURLRequest = NSURLRequest(URL: url)
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        
        
        do{
            
            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
            
            print(response)
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(dataVal, options: []) as? NSDictionary {
                    print("personalSynchronous\(jsonResult)")
                    
                    
                    let status = jsonResult.objectForKey("status") as! String
                    switch status {
                    case "620":
                        print("动态加载成功")
                        
                        DyHeight.removeAll()
                        myDynamic.removeAll()
                        thumbUpUsers.removeAll()
                        
                        let timelines = jsonResult.objectForKey("timelines") as! [NSDictionary]
                        var number = 0
                        
                        for i in timelines{
                            thumbUpUsers.append([])
                            let userInfo = i.objectForKey("userInfo") as! NSDictionary
                            let isDefaultAvatar = userInfo.objectForKey("isDefaultAvatar") as! Bool
                            let userPortraitUrl:String!
                            if isDefaultAvatar == false{
                                userPortraitUrl = userInfo.objectForKey("avatarURL") as! String
                            }else{
                                userPortraitUrl = portrait
                            }
                            let userName = userInfo.objectForKey("_id") as! String
                            let dynamic = i.objectForKey("text") as! String
                            let dynamicId = i.objectForKey("_id") as! Int
                            let timeStamp = i.objectForKey("timeStamp") as! String
                            let timeShow = timeStampToString(timeStamp)
                            let likedUser = i.objectForKey("liked") as! [NSDictionary]
                            let thumbUpNumber = likedUser.count
                            print("\(thumbUpNumber)jjjjjjjjj")
                            print("\(number)kkkkk")
                            var isThumbUp = false
                            
                            for j in likedUser{
                                let id = j.objectForKey("_id") as! String
                                if id == identifierValue{
                                    isThumbUp = true
                                }
                                let isDefaultAvatar = j.objectForKey("isDefaultAvatar") as! Bool
                                let userPortraitUrl:String!
                                if isDefaultAvatar == false{
                                    userPortraitUrl = j.objectForKey("avatarURL") as! String
                                }else{
                                    userPortraitUrl = portrait
                                }
                                let thumbUpUser = Friends(id: id, name: id, portrait: userPortraitUrl)
                                
                                thumbUpUsers[number].append(thumbUpUser)
                            }
                            let commentsNumber = i.objectForKey("commentCount") as! Int
                            
                            let dynamicModel = DynamicModel(userPortraitUrl: userPortraitUrl, userName: userName, dynamic: dynamic, thumbUpNumber: thumbUpNumber, isThumbUp: isThumbUp, joinNumber: 0, isJoin: false, commentsNumber: commentsNumber, thumbUpUser: thumbUpUsers[number],timeShow: timeShow,dynamicId: dynamicId)
                            
                            myDynamic.append(dynamicModel)
                            
                            number += 1
                        }
                    case "630":
                        print("动态加载失败")
                    default:
                        return
                    }
                    
                    
                    
                    
                    
                    
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            
            
        }catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
    }
    
    func doThumbUp(btn:UIButton){
        
        if myDynamic[btn.tag].isThumbUp == true{
            myDynamic[btn.tag].isThumbUp = false
            myDynamic[btn.tag].thumbUpNumber = myDynamic[btn.tag].thumbUpNumber - 1
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                self.thumbUpHttp("unlike", timelineID: self.myDynamic[btn.tag].dynamicId,tag: btn.tag)
            })
        }else{
            myDynamic[btn.tag].isThumbUp = true
            myDynamic[btn.tag].thumbUpNumber = myDynamic[btn.tag].thumbUpNumber + 1
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                self.thumbUpHttp("like", timelineID: self.myDynamic[btn.tag].dynamicId,tag: btn.tag)
            })
        }
        
        let ce = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: btn.tag, inSection: 0)) as!DynamicCell
        if myDynamic[btn.tag].isThumbUp == true{
            ce.thumbUp.setImage(UIImage(named: "heart-red"), forState: .Normal)
            ce.thumbUpNumber.textColor = UIColor.redColor()
            
        }else{
            ce.thumbUp.setImage(UIImage(named: "heart"), forState: .Normal)
            ce.thumbUpNumber.textColor = UIColor.blackColor()
        }
        
        if myDynamic[btn.tag].thumbUpNumber == 0{
            ce.thumbUpNumber.text = ""
        }else{
            
            ce.thumbUpNumber.text = "\(myDynamic[btn.tag].thumbUpNumber)"
        }
        
        
    }
    
    func thumbUpHttp(islike:String,timelineID:Int,tag:Int){
        
        do{
            
            var response:NSURLResponse?
            let urlString:String = "\(ip)/app.timeline.\(islike)"
            var url:NSURL!
            url = NSURL(string:urlString)
            let request = NSMutableURLRequest(URL:url)
            let body = "account=\(identifierValue)&timelineID=\(timelineID)"
            //编码POST数据
            let postData = body.dataUsingEncoding(NSUTF8StringEncoding)
            //保用 POST 提交
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            
            
            let data:NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
            let dict:AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            let dic = dict as! NSDictionary
            print(dic)
            let status = dic.objectForKey("status") as! String
            switch status {
            case "640":
                print("点赞成功")
                if userDefault.objectForKey("portrait") as! String != ""{
                    thumbUpUsers[tag].append(Friends(id: identifierValue, name: identifierValue, portrait: userDefault.objectForKey("portrait") as! String))
                }else{
                    thumbUpUsers[tag].append(Friends(id: identifierValue, name: identifierValue, portrait: portrait))
                }
            case "650":
                print("点赞失败")
            case "660":
                print("取消点赞成功")
                
                for i in 0...thumbUpUsers[tag].count-1{
                    if thumbUpUsers[tag][i].id == identifierValue{
                        thumbUpUsers[tag].removeAtIndex(i)
                    }
                }
                
                
            case "670":
                print("取消点赞失败")
            default:
                return
            }
            
        }catch{
            print("error")
            
        }
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "myToComment"{
            let VC = segue.destinationViewController as! CommentViewController
            VC.dynamic = dynamicForComment
            VC.thumbUpUsers = thumbUpUserForComment
        }
    }

    
    func timeStampToString(timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:NSTimeInterval = string.doubleValue
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="yy/MM/dd"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        print(dfmatter.stringFromDate(date))
        return dfmatter.stringFromDate(date)
    }

    
}
