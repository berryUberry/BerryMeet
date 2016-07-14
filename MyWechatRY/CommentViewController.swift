//
//  CommitViewController.swift
//  MyWechatRY
//
//  Created by 王凯 on 16/6/22.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    let identifierValue = String(userDefault.objectForKey("identifier")!)
    var dynamic:DynamicModel!
    var thumbUpUsers = Array<Friends>()
    var expectedLabelSize:CGRect!
    var comments = Array<CommentModel>()
    var commentHeight = Array<CGFloat>()
    var personalName:String!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentHead: UIImageView!
    @IBOutlet weak var commentName: UIButton!
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    @IBOutlet weak var commentTableView: UITableView!

    
    var addCommentTextField:UITextField = UITextField()
    

    
    override func viewWillAppear(animated: Bool) {
        for i in thumbUpUsers{
        print(i.id)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentViewController.keyboardWillDisappear(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
        addCommentTextField.backgroundColor = UIColor(red: 165/255, green: 201/255, blue: 219/255, alpha: 1)
        addCommentTextField.frame = CGRectMake(self.view.frame.width/18,self.view.frame.height - 48,self.view.frame.width*8/9,40)
        addCommentTextField.placeholder = "回复:\(dynamic.userName)"
        addCommentTextField.returnKeyType = .Send
        addCommentTextField.borderStyle = .RoundedRect
        addCommentTextField.delegate = self
        view.addSubview(addCommentTextField)
        
        
        let maxLabelSize: CGSize = CGSizeMake(self.view.frame.width*4/5 - 108, CGFloat(9999))
        let contentNSString = dynamic.dynamic as NSString
        print(dynamic.dynamic)
        expectedLabelSize = contentNSString.boundingRectWithSize(maxLabelSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16.0)], context: nil)
        commentView.frame = CGRectMake(0, 0, self.view.frame.width, expectedLabelSize.size.height+8+8+35+10)

        if userDefault.objectForKey("\(dynamic.userName)Head") as? NSData == nil{
            commentHead.image = UIImage(named: "xixi")
        
        }else{
            commentHead.image = UIImage(data: userDefault.objectForKey("\(dynamic.userName)Head") as! NSData)
        }
        
        commentName.setTitle(dynamic.userName, forState: .Normal)
        timeStampLabel.text = dynamic.timeShow
        commentText.text = dynamic.dynamic
        commentText.numberOfLines = 0
        commentText.font = UIFont.systemFontOfSize(16.0)
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.getComment()
        }
        
        print(thumbUpUsers)
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 44
        }else{
            return commentHeight[indexPath.row]
        
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return thumbUpUsers.count
        }else{
            return comments.count
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "参与者:"
        
        }else{
            return "评论:"
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0{
            personalName = thumbUpUsers[indexPath.row].id
            self.performSegueWithIdentifier("commentToPersonal", sender: self)
        }else{
        
            personalName = comments[indexPath.row].commentUser.id
            self.performSegueWithIdentifier("commentToPersonal", sender: self)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
        
            let cell = tableView.dequeueReusableCellWithIdentifier("thumbUpUser") as! AddFriendsCell
            cell.nameLabel.text = thumbUpUsers[indexPath.row].id
            
            cell.userInteractionEnabled = true
            cell.addFriendsButton.hidden = true

            let userPortraitFlag = thumbUpUsers[indexPath.row].portrait
            print(userPortraitFlag)
            if userPortraitFlag == portrait{
                
                
                cell.portraitImage.image = UIImage(named: "xixi")
                
                return cell
            }else{
                if userDefault.objectForKey("\(thumbUpUsers[indexPath.row].id)Head") as? NSData != nil{
                    cell.portraitImage.image = UIImage(data: userDefault.objectForKey("\(thumbUpUsers[indexPath.row].id)Head") as! NSData)
                
                }else{
                    let dateTime = NSDate()
                    let timeInterval = dateTime.timeIntervalSince1970
                    let headImageURL = "\(avatarURLHeader)\(thumbUpUsers[indexPath.row].portrait)?v=\(Int(timeInterval))"
                    print(headImageURL)

                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        let imageURL = NSURL(string: headImageURL)
                        let imageData = NSData(contentsOfURL: imageURL!)
                        let smallImage = UIImageJPEGRepresentation(UIImage(data: imageData!)!, 0.1)
                        
                        userDefault.setObject(smallImage, forKey: "\(self.thumbUpUsers[indexPath.row].id)Head")
                        dispatch_async(dispatch_get_main_queue(), {
                            cell.portraitImage.image = UIImage(data: smallImage!)
                        })
                        
                    }

                
                }
             
                
            }
            
            return cell
        
        }else{
        
            let cell = tableView.dequeueReusableCellWithIdentifier("commentCell") as! CommentCell
            if comments[indexPath.row].commentUser.portrait != portrait{
                cell.commentHeadImage.image = UIImage(data: userDefault.objectForKey("\(comments[indexPath.row].commentUser.id)Head") as! NSData)
            }else{
            
                cell.commentHeadImage.image = UIImage(named: "xixi")
            }
            cell.commentUserName.setTitle(comments[indexPath.row].commentUser.id, forState: .Normal)
            cell.commentTime.text = comments[indexPath.row].timeStamp
            cell.commentContent.text = comments[indexPath.row].content
            cell.commentContent.numberOfLines = 0
            return cell
        
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func getComment(){
        
//        let urlPath: String = "\(ip)/app.timeline.comment?timelineID=\(dynamic.dynamicId)"
//        let url: NSURL = NSURL(string: urlPath)!
//        let request1: NSURLRequest = NSURLRequest(URL: url)
//        let queue:NSOperationQueue = NSOperationQueue()
//        
//        NSURLConnection.sendAsynchronousRequest(request1, queue: queue, completionHandler:{ (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
//            
//            do {
//                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
//                    print("comment\(jsonResult)")
//                }
//            } catch let error as NSError {
//                print(error.localizedDescription)
//            }
//            
//            
//        })

        
        var response:NSURLResponse?
        do {
            
            let url:NSURL! = NSURL(string:"\(ip)/app.timeline.comment?timelineID=\(dynamic.dynamicId)")
            let urlRequest:NSURLRequest = NSURLRequest(URL: url, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 20)
            let data:NSData = try NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: &response)
            let dict:AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            let dic = dict as! NSDictionary
            
            print(dic)
            
            let status = dic.objectForKey("status") as! NSNumber
            
            switch status {
            case 780:
                print("获取评论列表成功")
                let commentsArray = dic.objectForKey("comments") as! [NSDictionary]
                for i in commentsArray{
                    let content = i.objectForKey("content") as! String
                    
                    let maxLabelSize: CGSize = CGSizeMake(self.view.frame.width - 70, CGFloat(9999))
                    let contentNSString = content as NSString
                    let expectedLabelSize = contentNSString.boundingRectWithSize(maxLabelSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16.0)], context: nil)
                    self.commentHeight.append(expectedLabelSize.size.height+60)
                    
                    let timeStamp = i.objectForKey("timeStamp") as! String
                    let timeShow = timeStampToString(timeStamp)
                    let timelineID = i.objectForKey("timelineID") as! Int
                    let userInfo = i.objectForKey("userInfo") as! NSDictionary
                    let userName = userInfo.objectForKey("_id") as! String
                    let isDefaultAvatar = userInfo.objectForKey("isDefaultAvatar") as! Bool
                    var avatarURL:String!
                    let dateTime = NSDate()
                    let timeInterval = dateTime.timeIntervalSince1970
                    
                    
                    if isDefaultAvatar == false{
                        let headImage = userInfo.objectForKey("avatarURL") as! String
                        let headImageURL = "\(avatarURLHeader)\(headImage)?v=\(Int(timeInterval))"
                        
                        if userDefault.objectForKey("\(userName)Head") as? NSData != nil{
                            avatarURL = headImageURL
                        }else{
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                                let imageURL = NSURL(string: headImageURL)
                                let imageData = NSData(contentsOfURL: imageURL!)
                                let smallImage = UIImageJPEGRepresentation(UIImage(data: imageData!)!, 0.1)
                                
                                userDefault.setObject(smallImage, forKey: "\(userName)Head")
                                avatarURL = headImageURL
                            }
                        }
                    
                    }else{
                        avatarURL = portrait
                    }
                    let friend = Friends(id: userName, name: userName, portrait: avatarURL)
                    let commentUser = CommentModel(content: content,timeStamp: timeShow,timelineID: timelineID,commentUser: friend)
                    comments.append(commentUser)
                
                
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.commentTableView.reloadData()
                })
                
                
            case 790:
                print("获取评论列表失败")
            default:
                return
            }
            
            
        }
        catch{
            print("网络问题")
            
        }
    
    }
    

    func sendComment(timelineID:Int,content:String){
        do{
            print(timelineID)
            print(content)
            var response:NSURLResponse?
            let urlString:String = "\(ip)/app.timeline.comment"
            var url:NSURL!
            url = NSURL(string:urlString)
            let request = NSMutableURLRequest(URL:url)
            let body = "account=\(identifierValue)&timelineID=\(timelineID)&content=\(content)"
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
            case "740":
                print("评论成功")
                dispatch_async(dispatch_get_main_queue(), {
                    self.addCommentTextField.text = ""
                    self.addCommentTextField.placeholder = "评论成功"
                    self.commentTableView.reloadData()
                })
                
            case "750":
                print("评论失败,timeline不存在")
                dispatch_async(dispatch_get_main_queue(), {
                    self.addCommentTextField.text = ""
                    self.addCommentTextField.placeholder = "评论失败,timeline不存在"
                })
            case "770":
                print("评论失败")
                dispatch_async(dispatch_get_main_queue(), {
                    self.addCommentTextField.text = ""
                    self.addCommentTextField.placeholder = "评论失败"
                })
            default:
                return
            }
            
        }catch{
            print("error")
            dispatch_async(dispatch_get_main_queue(), {
                self.addCommentTextField.text = ""
                self.addCommentTextField.placeholder = "网络错误"
            })
            
        }
    
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if addCommentTextField.text != ""{
            addCommentTextField.returnKeyType = .Send
            
        }else{
            addCommentTextField.returnKeyType = .Send
        }
    }
    func keyboardWillAppear(notification: NSNotification) {
        
        // 获取键盘信息
        let keyboardinfo = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]
        
        let keyboardheight:CGFloat = (keyboardinfo?.CGRectValue.size.height)!
        
        print("键盘弹起")
        addCommentTextField.frame = CGRectMake(0,self.view.frame.height - keyboardheight - 48,self.view.frame.width,40)
        
        
    }
    
    func keyboardWillDisappear(notification:NSNotification){
        
        
        print("键盘落下")
        addCommentTextField.frame = CGRectMake(self.view.frame.width/18,self.view.frame.height - 48,self.view.frame.width*8/9,40)
    }

    
    ////键盘收回
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if self.addCommentTextField.text == ""{
            addCommentTextField.placeholder = "评论内容不能为空"
        }else{
            self.sendComment(self.dynamic.dynamicId, content: self.addCommentTextField.text!)
            addCommentTextField.text = "评论中..."
            textField.resignFirstResponder()
        }
        
        
        return true
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        view.endEditing(true)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("zhunbie2")
        if segue.identifier == "commentToPersonal"{
            
            let VC = segue.destinationViewController as! PersonalViewController
            VC.name = personalName
            if personalName == identifierValue{
            
                VC.isYourself = true
            }else{
                VC.isYourself = false
            }
            
        }
        
        
        
    }
    
}
