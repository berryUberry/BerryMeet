//
//  CommitViewController.swift
//  MyWechatRY
//
//  Created by 王凯 on 16/6/22.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var dynamic:DynamicModel!
    var thumbUpUsers = Array<Friends>()
    var expectedLabelSize:CGRect!
    var comments = Array<CommentModel>()
    
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentHead: UIImageView!
    @IBOutlet weak var commentName: UIButton!
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        for i in thumbUpUsers{
        print(i.id)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let maxLabelSize: CGSize = CGSizeMake(self.view.frame.width*4/5 - 108, CGFloat(9999))
        let contentNSString = dynamic.dynamic as NSString
        print(dynamic.dynamic)
        expectedLabelSize = contentNSString.boundingRectWithSize(maxLabelSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16.0)], context: nil)
        commentView.frame = CGRectMake(0, 0, self.view.frame.width, expectedLabelSize.size.height+8+8+35+10)

        commentHead.image = UIImage(data: userDefault.objectForKey("\(dynamic.userName)Head") as! NSData)
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
        
            let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! AddFriendsCell
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
        }
        catch{
            print("网络问题")
            
        }
    
    }
    
    
}
