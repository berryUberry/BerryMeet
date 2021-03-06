//
//  mainViewController.swift
//  MyWechatRY
//
//  Created by 王凯 on 16/5/30.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit

import XMSegmentedControl
class mainViewController: UIViewController,XMSegmentedControlDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource{
    let identifierValue = String(userDefault.objectForKey("identifier")!)
    
    var scrollView:UIScrollView!
    var segmentedControl3:XMSegmentedControl!
    var dynamicOnline = Array<DynamicModel>()
    var dynamicTravel = Array<DynamicModel>()
    var dynamicParty = Array<DynamicModel>()
    var dynamicCar = Array<DynamicModel>()
    var dynamics = Array<DynamicModel>()
    var onlineheight = Array<CGFloat>()
    var travelheight = Array<CGFloat>()
    var partyheight = Array<CGFloat>()
    var carheight = Array<CGFloat>()
    
    var dynamicForComment:DynamicModel!
    var thumbUpUsers = Array<Array<Friends>>()
    var thumbUpUserForComment = Array<Friends>()
    
    var name:String!
    
    
    var tableView1:UITableView!
    var tableView2:UITableView!
    var tableView3:UITableView!
    var tableView4:UITableView!
    
    override func viewWillAppear(animated: Bool) {
        
        self.tabBarController?.tabBar.hidden = false
        
        ////////////////////////////
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.postTimeLine()
            
            for i in self.dynamicOnline{
                
                
                
                let maxLabelSize: CGSize = CGSizeMake(self.view.frame.width - 54, CGFloat(9999))
                let contentNSString = i.dynamic as NSString
                let expectedLabelSize = contentNSString.boundingRectWithSize(maxLabelSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16.0)], context: nil)
                self.onlineheight.append(expectedLabelSize.size.height+140)
            }
            for i in self.dynamicParty{
                
                let maxLabelSize: CGSize = CGSizeMake(self.view.frame.width - 54, CGFloat(9999))
                let contentNSString = i.dynamic as NSString
                let expectedLabelSize = contentNSString.boundingRectWithSize(maxLabelSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16.0)], context: nil)
                self.partyheight.append(expectedLabelSize.size.height+140)
            }
            for i in self.dynamicCar{
                
                let maxLabelSize: CGSize = CGSizeMake(self.view.frame.width - 54, CGFloat(9999))
                let contentNSString = i.dynamic as NSString
                let expectedLabelSize = contentNSString.boundingRectWithSize(maxLabelSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16.0)], context: nil)
                self.carheight.append(expectedLabelSize.size.height+140)
            }
            for i in self.dynamicTravel{
                let maxLabelSize: CGSize = CGSizeMake(self.view.frame.width - 54, CGFloat(9999))
                let contentNSString = i.dynamic as NSString
                let expectedLabelSize = contentNSString.boundingRectWithSize(maxLabelSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16.0)], context: nil)
                self.travelheight.append(expectedLabelSize.size.height+140)
                
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView1.reloadData()
                self.tableView2.reloadData()
                self.tableView3.reloadData()
                self.tableView4.reloadData()
            })
        }
        
        
        ////////////

    }
    
    override func viewDidLoad() {
    
        
        
        let appDeletage = UIApplication.sharedApplication().delegate as! AppDelegate
        appDeletage.connectServer {
            () -> Void in
            
            
            print("连接成功")
            
        }
        
        
        
        
        
        /////////
        

        
        super.viewDidLoad()
        segmentedControl3 = XMSegmentedControl(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)! + 20, width: self.view.frame.width, height: 44), segmentTitle: ["线上", "聚会", "旅行","其他"], selectedItemHighlightStyle: XMSelectedItemHighlightStyle.TopEdge)
        
        segmentedControl3.backgroundColor = UIColor(red: 22/255, green: 150/255, blue: 122/255, alpha: 1)
        segmentedControl3.highlightColor = UIColor(red: 25/255, green: 180/255, blue: 145/255, alpha: 1)
        segmentedControl3.tint = UIColor.whiteColor()
        segmentedControl3.highlightTint = UIColor.blackColor()
        
        self.view.addSubview(segmentedControl3)
        segmentedControl3.delegate = self
        
        scrollView = UIScrollView(frame: CGRectMake(0,segmentedControl3.frame.maxY,self.view.frame.width,self.view.frame.height - segmentedControl3.frame.minY))
        scrollView.contentSize = CGSizeMake(self.view.frame.width * 4, self.view.frame.height - segmentedControl3.frame.maxY-(self.navigationController?.navigationBar.frame.height)!-(self.tabBarController?.tabBar.frame.height)!)
        
        scrollView.delegate = self
        
        self.view.addSubview(scrollView)
        
        
        
        tableView1 = UITableView(frame: CGRectMake(0,0, self.view.frame.width, self.view.frame.height - segmentedControl3.frame.minY-(self.navigationController?.navigationBar.frame.height)!-(self.tabBarController?.tabBar.frame.height)!))
        tableView2 = UITableView(frame: CGRectMake(self.view.frame.width,0, self.view.frame.width, self.view.frame.height - segmentedControl3.frame.minY-(self.navigationController?.navigationBar.frame.height)!-(self.tabBarController?.tabBar.frame.height)!))
        tableView3 = UITableView(frame: CGRectMake(self.view.frame.width*2,0, self.view.frame.width, self.view.frame.height - segmentedControl3.frame.minY-(self.navigationController?.navigationBar.frame.height)!-(self.tabBarController?.tabBar.frame.height)!))
        tableView4 = UITableView(frame: CGRectMake(self.view.frame.width*3,0, self.view.frame.width, self.view.frame.height - segmentedControl3.frame.minY-(self.navigationController?.navigationBar.frame.height)!-(self.tabBarController?.tabBar.frame.height)!))
        
        scrollView.addSubview(tableView1)
        scrollView.addSubview(tableView2)
        scrollView.addSubview(tableView3)
        scrollView.addSubview(tableView4)
        
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView2.delegate = self
        tableView2.dataSource = self
        tableView3.delegate = self
        tableView3.dataSource = self
        tableView4.delegate = self
        tableView4.dataSource = self

        tableView1.registerNib(UINib(nibName: "DynamicCell",bundle: nil), forCellReuseIdentifier: "cell")
        tableView2.registerNib(UINib(nibName: "DynamicCell",bundle: nil), forCellReuseIdentifier: "cell")
        tableView3.registerNib(UINib(nibName: "DynamicCell",bundle: nil), forCellReuseIdentifier: "cell")
        tableView4.registerNib(UINib(nibName: "DynamicCell",bundle: nil), forCellReuseIdentifier: "cell")
        scrollView.scrollEnabled = false
        self.view.addSubview(scrollView)
        
        
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView1{
            return dynamicOnline.count
        }else if tableView == tableView2{
            return dynamicParty.count
        
        }else if tableView == tableView3{
            return dynamicTravel.count
        
        }else if tableView == tableView4{
        
            return dynamicCar.count
        }else{
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let ce = cell as! DynamicCell
        
        
        //点赞
        
        ce.thumbUp.addTarget(self, action: #selector(thumbUp(_:)), forControlEvents: .TouchUpInside)
        //参与
        ce.join.addTarget(self, action: #selector(join(_:)), forControlEvents: .TouchUpInside)
        //点击名字
        ce.userName.addTarget(self, action: #selector(chat(_:)), forControlEvents: .TouchUpInside)
        ce.join.hidden = true
        
        if tableView == tableView1{
            
            ce.thumbUp.tag = indexPath.row
            ce.join.tag = indexPath.row
            ce.userName.tag = indexPath.row

//            ce.userPortrait.image = UIImage(data: NSData(contentsOfURL: NSURL(string: dynamicOnline[indexPath.row].userPortraitUrl)!)!)
            //ce.userPortrait.image = UIImage(named:"xixi.jpg")
            
            if dynamicOnline[indexPath.row].userPortraitUrl != portrait{
                if userDefault.objectForKey("\(dynamicOnline[indexPath.row].userName)Head") as? NSData != nil{
                
                    ce.userPortrait.image = UIImage(data: userDefault.objectForKey("\(dynamicOnline[indexPath.row].userName)Head") as! NSData)
                
                }else{
                
                    let dateTime = NSDate()
                    let timeInterval = dateTime.timeIntervalSince1970
                    print(Int(timeInterval))
                    let headImageURL = "\(avatarURLHeader)\(dynamicOnline[indexPath.row].userPortraitUrl)?v=\(Int(timeInterval))"
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        let imageURL = NSURL(string: headImageURL)
                        let imageData = NSData(contentsOfURL: imageURL!)
                        let smallImage = UIImageJPEGRepresentation(UIImage(data: imageData!)!, 0.1)
                        userDefault.setObject(smallImage, forKey: "\(self.dynamicOnline[indexPath.row].userName)Head")
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            ce.userPortrait.image = UIImage(data: smallImage!)
                        })
                        
                    }
                }
            }else{
                ce.userPortrait.image = UIImage(named:"xixi.jpg")
            }
            
            ce.userName.setTitle(dynamicOnline[indexPath.row].userName, forState: .Normal)
            ce.dynamicContent.text = dynamicOnline[indexPath.row].dynamic
            ce.dynamicContent.sizeThatFits(CGSizeMake(self.view.frame.width - 54, 9999))
            ce.dynamicContent.font = UIFont.systemFontOfSize(16.0)
            ce.dynamicContent.numberOfLines = 0
            ce.timeShow.text = dynamicOnline[indexPath.row].timeShow
            
        //处理点赞参与评论颜色
            if dynamicOnline[indexPath.row].isThumbUp == true{
                ce.thumbUp.setImage(UIImage(named: "heart-red"), forState: .Normal)
                ce.thumbUpNumber.textColor = UIColor.redColor()
            
            }else{
                ce.thumbUp.setImage(UIImage(named: "heart"), forState: .Normal)
                ce.thumbUpNumber.textColor = UIColor.blackColor()
            }
            
            if dynamicOnline[indexPath.row].isJoin == true{
                ce.join.setImage(UIImage(named: "hand-red"), forState: .Normal)
                ce.joinNumber.textColor = UIColor.redColor()
            }else{
                ce.join.setImage(UIImage(named: "cursor_hand"), forState: .Normal)
                ce.joinNumber.textColor = UIColor.blackColor()
            }
            
            if dynamicOnline[indexPath.row].thumbUpNumber == 0{
                ce.thumbUpNumber.text = ""
            }else{
            
                ce.thumbUpNumber.text = "\(dynamicOnline[indexPath.row].thumbUpNumber)"
            }
            if dynamicOnline[indexPath.row].joinNumber == 0{
            
                ce.joinNumber.text = ""
            }else{
            
                ce.joinNumber.text = "\(dynamicOnline[indexPath.row].joinNumber)"
            }
            if dynamicOnline[indexPath.row].commentsNumber == 0{
                ce.commentsNumber.text = ""
            }else{
                ce.commentsNumber.text = "\(dynamicOnline[indexPath.row].commentsNumber)"
            }
        
            
        }else if tableView == tableView2{
            ce.thumbUp.tag = 1*10000 + indexPath.row
            ce.join.tag = 1*10000 + indexPath.row
            ce.userName.tag = 1*10000 + indexPath.row
            
//            ce.userPortrait.image = UIImage(data: NSData(contentsOfURL: NSURL(string: dynamicParty[indexPath.row].userPortraitUrl)!)!)
            
            if dynamicParty[indexPath.row].userPortraitUrl != portrait{
                if userDefault.objectForKey("\(dynamicParty[indexPath.row].userName)Head") as? NSData != nil{
                    
                    ce.userPortrait.image = UIImage(data: userDefault.objectForKey("\(dynamicParty[indexPath.row].userName)Head") as! NSData)
                    
                }else{
                    
                    let dateTime = NSDate()
                    let timeInterval = dateTime.timeIntervalSince1970
                    print(Int(timeInterval))
                    let headImageURL = "\(avatarURLHeader)\(dynamicParty[indexPath.row].userPortraitUrl)?v=\(Int(timeInterval))"
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        let imageURL = NSURL(string: headImageURL)
                        let imageData = NSData(contentsOfURL: imageURL!)
                        let smallImage = UIImageJPEGRepresentation(UIImage(data: imageData!)!, 0.1)
                        userDefault.setObject(smallImage, forKey: "\(self.dynamicParty[indexPath.row].userName)Head")
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            ce.userPortrait.image = UIImage(data: smallImage!)
                        })
                        
                    }
                }
            }else{
                ce.userPortrait.image = UIImage(named:"xixi.jpg")
            }

            
            ce.userName.setTitle(dynamicParty[indexPath.row].userName, forState: .Normal)
            ce.dynamicContent.text = dynamicParty[indexPath.row].dynamic
            
            ce.dynamicContent.sizeThatFits(CGSizeMake(self.view.frame.width - 54, 9999))
            ce.dynamicContent.font = UIFont.systemFontOfSize(16.0)
            ce.dynamicContent.numberOfLines = 0
            ce.timeShow.text = dynamicParty[indexPath.row].timeShow
            
            //处理点赞参与评论颜色
            if dynamicParty[indexPath.row].isThumbUp == true{
                ce.thumbUp.setImage(UIImage(named: "heart-red"), forState: .Normal)
                ce.thumbUpNumber.textColor = UIColor.redColor()
                
            }else{
                ce.thumbUp.setImage(UIImage(named: "heart"), forState: .Normal)
                ce.thumbUpNumber.textColor = UIColor.blackColor()
            }
            
            if dynamicParty[indexPath.row].isJoin == true{
                ce.join.setImage(UIImage(named: "hand-red"), forState: .Normal)
                ce.joinNumber.textColor = UIColor.redColor()
            }else{
                ce.join.setImage(UIImage(named: "cursor_hand"), forState: .Normal)
                ce.joinNumber.textColor = UIColor.blackColor()
            }
            
            if dynamicParty[indexPath.row].thumbUpNumber == 0{
                ce.thumbUpNumber.text = ""
            }else{
                
                ce.thumbUpNumber.text = "\(dynamicParty[indexPath.row].thumbUpNumber)"
            }
            if dynamicParty[indexPath.row].joinNumber == 0{
                
                ce.joinNumber.text = ""
            }else{
                
                ce.joinNumber.text = "\(dynamicParty[indexPath.row].joinNumber)"
            }
            if dynamicParty[indexPath.row].commentsNumber == 0{
                ce.commentsNumber.text = ""
            }else{
                ce.commentsNumber.text = "\(dynamicParty[indexPath.row].commentsNumber)"
            }

        }else if tableView == tableView3{
            ce.thumbUp.tag = 2*10000 + indexPath.row
            ce.join.tag = 2*10000 + indexPath.row
            ce.userName.tag = 2*10000 + indexPath.row
            
//            ce.userPortrait.image = UIImage(data: NSData(contentsOfURL: NSURL(string: dynamicTravel[indexPath.row].userPortraitUrl)!)!)
            
            if dynamicTravel[indexPath.row].userPortraitUrl != portrait{
                if userDefault.objectForKey("\(dynamicTravel[indexPath.row].userName)Head") as? NSData != nil{
                    
                    ce.userPortrait.image = UIImage(data: userDefault.objectForKey("\(dynamicTravel[indexPath.row].userName)Head") as! NSData)
                    
                }else{
                    
                    let dateTime = NSDate()
                    let timeInterval = dateTime.timeIntervalSince1970
                    print(Int(timeInterval))
                    let headImageURL = "\(avatarURLHeader)\(dynamicTravel[indexPath.row].userPortraitUrl)?v=\(Int(timeInterval))"
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        let imageURL = NSURL(string: headImageURL)
                        let imageData = NSData(contentsOfURL: imageURL!)
                        let smallImage = UIImageJPEGRepresentation(UIImage(data: imageData!)!, 0.1)
                        userDefault.setObject(smallImage, forKey: "\(self.dynamicTravel[indexPath.row].userName)Head")
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            ce.userPortrait.image = UIImage(data: smallImage!)
                        })
                        
                    }
                }
            }else{
                ce.userPortrait.image = UIImage(named:"xixi.jpg")
            }
            
            ce.userName.setTitle(dynamicTravel[indexPath.row].userName, forState: .Normal)
            ce.dynamicContent.text = dynamicTravel[indexPath.row].dynamic
            ce.dynamicContent.sizeThatFits(CGSizeMake(self.view.frame.width - 54, 9999))
            ce.dynamicContent.font = UIFont.systemFontOfSize(16.0)
            ce.dynamicContent.numberOfLines = 0
            ce.timeShow.text = dynamicTravel[indexPath.row].timeShow
            
            
            //处理点赞参与评论颜色
            if dynamicTravel[indexPath.row].isThumbUp == true{
                ce.thumbUp.setImage(UIImage(named: "heart-red"), forState: .Normal)
                ce.thumbUpNumber.textColor = UIColor.redColor()
                
            }else{
                ce.thumbUp.setImage(UIImage(named: "heart"), forState: .Normal)
                ce.thumbUpNumber.textColor = UIColor.blackColor()
            }
            
            if dynamicTravel[indexPath.row].isJoin == true{
                ce.join.setImage(UIImage(named: "hand-red"), forState: .Normal)
                ce.joinNumber.textColor = UIColor.redColor()
            }else{
                ce.join.setImage(UIImage(named: "cursor_hand"), forState: .Normal)
                ce.joinNumber.textColor = UIColor.blackColor()
            }
            
            if dynamicTravel[indexPath.row].thumbUpNumber == 0{
                ce.thumbUpNumber.text = ""
            }else{
                
                ce.thumbUpNumber.text = "\(dynamicTravel[indexPath.row].thumbUpNumber)"
            }
            if dynamicTravel[indexPath.row].joinNumber == 0{
                
                ce.joinNumber.text = ""
            }else{
                
                ce.joinNumber.text = "\(dynamicTravel[indexPath.row].joinNumber)"
            }
            if dynamicTravel[indexPath.row].commentsNumber == 0{
                ce.commentsNumber.text = ""
            }else{
                ce.commentsNumber.text = "\(dynamicTravel[indexPath.row].commentsNumber)"
            }

            
        }else{
            
            ce.thumbUp.tag = 3*10000 + indexPath.row
            ce.join.tag = 3*10000 + indexPath.row
            ce.userName.tag = 3*10000 + indexPath.row
            
//            ce.userPortrait.image = UIImage(data: NSData(contentsOfURL: NSURL(string: dynamicCar[indexPath.row].userPortraitUrl)!)!)
            if dynamicCar[indexPath.row].userPortraitUrl != portrait{
                if userDefault.objectForKey("\(dynamicCar[indexPath.row].userName)Head") as? NSData != nil{
                    
                    ce.userPortrait.image = UIImage(data: userDefault.objectForKey("\(dynamicCar[indexPath.row].userName)Head") as! NSData)
                    
                }else{
                    
                    let dateTime = NSDate()
                    let timeInterval = dateTime.timeIntervalSince1970
                    print(Int(timeInterval))
                    let headImageURL = "\(avatarURLHeader)\(dynamicCar[indexPath.row].userPortraitUrl)?v=\(Int(timeInterval))"
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        let imageURL = NSURL(string: headImageURL)
                        let imageData = NSData(contentsOfURL: imageURL!)
                        let smallImage = UIImageJPEGRepresentation(UIImage(data: imageData!)!, 0.1)
                        userDefault.setObject(smallImage, forKey: "\(self.dynamicCar[indexPath.row].userName)Head")
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            ce.userPortrait.image = UIImage(data: smallImage!)
                        })
                        
                    }
                }
            }else{
                ce.userPortrait.image = UIImage(named:"xixi.jpg")
            }
            
            ce.userName.setTitle(dynamicCar[indexPath.row].userName, forState: .Normal)
            ce.dynamicContent.text = dynamicCar[indexPath.row].dynamic
           
            ce.dynamicContent.sizeThatFits(CGSizeMake(self.view.frame.width - 54, 9999))
            ce.dynamicContent.font = UIFont.systemFontOfSize(16.0)
            ce.dynamicContent.numberOfLines = 0
            ce.timeShow.text = dynamicCar[indexPath.row].timeShow
            
            //处理点赞参与评论颜色
            if dynamicCar[indexPath.row].isThumbUp == true{
                ce.thumbUp.setImage(UIImage(named: "heart-red"), forState: .Normal)
                ce.thumbUpNumber.textColor = UIColor.redColor()
                
            }else{
                ce.thumbUp.setImage(UIImage(named: "heart"), forState: .Normal)
                ce.thumbUpNumber.textColor = UIColor.blackColor()
            }
            
            if dynamicCar[indexPath.row].isJoin == true{
                ce.join.setImage(UIImage(named: "hand-red"), forState: .Normal)
                ce.joinNumber.textColor = UIColor.redColor()
            }else{
                ce.join.setImage(UIImage(named: "cursor_hand"), forState: .Normal)
                ce.joinNumber.textColor = UIColor.blackColor()
            }
            
            if dynamicCar[indexPath.row].thumbUpNumber == 0{
                ce.thumbUpNumber.text = ""
            }else{
                
                ce.thumbUpNumber.text = "\(dynamicCar[indexPath.row].thumbUpNumber)"
            }
            if dynamicCar[indexPath.row].joinNumber == 0{
                
                ce.joinNumber.text = ""
            }else{
                
                ce.joinNumber.text = "\(dynamicCar[indexPath.row].joinNumber)"
            }
            if dynamicCar[indexPath.row].commentsNumber == 0{
                ce.commentsNumber.text = ""
            }else{
                ce.commentsNumber.text = "\(dynamicCar[indexPath.row].commentsNumber)"
            }
            
            
            
            

        }

    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == tableView1{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! DynamicCell
            
            return cell
            
        }else if tableView == tableView2{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! DynamicCell

            return cell
        }else if tableView == tableView3{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! DynamicCell

            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! DynamicCell

            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == tableView1{
            
            return onlineheight[indexPath.row]
        }else if tableView == tableView2{
            return partyheight[indexPath.row]
            
        }else if tableView == tableView3{
            return travelheight[indexPath.row]
            
        }else if tableView == tableView4{
            
            return carheight[indexPath.row]
        }else{
            return 0
            
        }
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView == tableView1{
        
            dynamicForComment = dynamicOnline[indexPath.row]
            thumbUpUserForComment = dynamicOnline[indexPath.row].thumbUpUser
        
        }else if tableView == tableView2{
            dynamicForComment = dynamicParty[indexPath.row]
            thumbUpUserForComment = dynamicParty[indexPath.row].thumbUpUser
        }else if tableView == tableView3{
            dynamicForComment = dynamicTravel[indexPath.row]
            thumbUpUserForComment = dynamicTravel[indexPath.row].thumbUpUser
        }else{
            dynamicForComment = dynamicCar[indexPath.row]
            thumbUpUserForComment = dynamicCar[indexPath.row].thumbUpUser
        }
        
//        dynamicForComment = dynamicOnline[indexPath.row]
//        thumbUpUserForComment = thumbUpUsers[indexPath.row]
//        print(thumbUpUserForComment)
        self.tabBarController?.tabBar.hidden = true
        self.performSegueWithIdentifier("meetsToComment", sender: self)
        
    }
    
    
    
    
    
    
    
    
    func xmSegmentedControl(xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        print(selectedSegment)
        
        var frame = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(selectedSegment)
        frame.origin.y = segmentedControl3.frame.maxY
        
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    func thumbUp(btn:UIButton){
        print("here")
        switch btn.tag/10000 {
        
        case 0:
            if dynamicOnline[btn.tag].isThumbUp == false{
                dynamicOnline[btn.tag].isThumbUp = true
                dynamicOnline[btn.tag].thumbUpNumber = dynamicOnline[btn.tag].thumbUpNumber + 1
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    self.thumbUpHttp("like", timelineID: self.dynamicOnline[btn.tag].dynamicId,tag: btn.tag/10000,type: 0)
                })
                
                
                
            }else{
                
                dynamicOnline[btn.tag].isThumbUp = false
                dynamicOnline[btn.tag].thumbUpNumber = dynamicOnline[btn.tag].thumbUpNumber - 1
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    self.thumbUpHttp("unlike", timelineID: self.dynamicOnline[btn.tag].dynamicId,tag: btn.tag/10000,type: 0)
                })
            }
            
            let ce = tableView1.cellForRowAtIndexPath(NSIndexPath(forRow: btn.tag, inSection: 0)) as!DynamicCell
            if dynamicOnline[btn.tag].isThumbUp == true{
                ce.thumbUp.setImage(UIImage(named: "heart-red"), forState: .Normal)
                ce.thumbUpNumber.textColor = UIColor.redColor()
                
            }else{
                ce.thumbUp.setImage(UIImage(named: "heart"), forState: .Normal)
                ce.thumbUpNumber.textColor = UIColor.blackColor()
            }
            
            if dynamicOnline[btn.tag].thumbUpNumber == 0{
                ce.thumbUpNumber.text = ""
            }else{
                
                ce.thumbUpNumber.text = "\(dynamicOnline[btn.tag].thumbUpNumber)"
            }
            
        case 1:
            print(btn.tag)
            let number = btn.tag - 10000
            if dynamicParty[number].isThumbUp == false{
                dynamicParty[number].isThumbUp = true
                dynamicParty[number].thumbUpNumber = dynamicParty[number].thumbUpNumber + 1
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    self.thumbUpHttp("like", timelineID: self.dynamicParty[number].dynamicId,tag: number,type: 1)
                })
            }else{
                
                dynamicParty[number].isThumbUp = false
                dynamicParty[number].thumbUpNumber = dynamicParty[number].thumbUpNumber - 1
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    self.thumbUpHttp("unlike", timelineID: self.dynamicParty[number].dynamicId,tag: number,type: 1)
                })
            }
            
            let ce = tableView2.cellForRowAtIndexPath(NSIndexPath(forRow: number, inSection: 0)) as!DynamicCell
            if dynamicParty[number].isThumbUp == true{
                ce.thumbUp.setImage(UIImage(named: "heart-red"), forState: .Normal)
                ce.thumbUpNumber.textColor = UIColor.redColor()
                
            }else{
                ce.thumbUp.setImage(UIImage(named: "heart"), forState: .Normal)
                ce.thumbUpNumber.textColor = UIColor.blackColor()
            }
            
            if dynamicParty[number].thumbUpNumber == 0{
                ce.thumbUpNumber.text = ""
            }else{
                
                ce.thumbUpNumber.text = "\(dynamicParty[number].thumbUpNumber)"
            }
            
        case 2:
            let number = btn.tag - 20000
            if dynamicTravel[number].isThumbUp == false{
                dynamicTravel[number].isThumbUp = true
                dynamicTravel[number].thumbUpNumber = dynamicTravel[number].thumbUpNumber + 1
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    self.thumbUpHttp("like", timelineID: self.dynamicTravel[number].dynamicId,tag: number,type: 2)
                })
            }else{
                
                dynamicTravel[number].isThumbUp = false
                dynamicTravel[number].thumbUpNumber = dynamicTravel[number].thumbUpNumber - 1
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    self.thumbUpHttp("unlike", timelineID: self.dynamicTravel[number].dynamicId,tag: number,type: 2)
                })
            }
            
            let ce = tableView3.cellForRowAtIndexPath(NSIndexPath(forRow: number, inSection: 0)) as!DynamicCell
            if dynamicTravel[number].isThumbUp == true{
                ce.thumbUp.setImage(UIImage(named: "heart-red"), forState: .Normal)
                ce.thumbUpNumber.textColor = UIColor.redColor()
                
            }else{
                ce.thumbUp.setImage(UIImage(named: "heart"), forState: .Normal)
                ce.thumbUpNumber.textColor = UIColor.blackColor()
            }
            if dynamicTravel[number].thumbUpNumber == 0{
                ce.thumbUpNumber.text = ""
            }else{
                
                ce.thumbUpNumber.text = "\(dynamicTravel[number].thumbUpNumber)"
            }
            
        case 3:
            let number = btn.tag - 30000
            if dynamicCar[number].isThumbUp == false{
                dynamicCar[number].isThumbUp = true
                dynamicCar[number].thumbUpNumber = dynamicCar[number].thumbUpNumber + 1
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    self.thumbUpHttp("like", timelineID: self.dynamicCar[number].dynamicId,tag: number,type: 3)
                })
            }else{
                
                dynamicCar[number].isThumbUp = false
                dynamicCar[number].thumbUpNumber = dynamicCar[number].thumbUpNumber - 1
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    self.thumbUpHttp("unlike", timelineID: self.dynamicCar[number].dynamicId,tag: number,type: 3)
                })
            }
            
            let ce = tableView4.cellForRowAtIndexPath(NSIndexPath(forRow: number, inSection: 0)) as!DynamicCell
            if dynamicCar[number].isThumbUp == true{
                ce.thumbUp.setImage(UIImage(named: "heart-red"), forState: .Normal)
                ce.thumbUpNumber.textColor = UIColor.redColor()
                
            }else{
                ce.thumbUp.setImage(UIImage(named: "heart"), forState: .Normal)
                ce.thumbUpNumber.textColor = UIColor.blackColor()
            }
            if dynamicCar[number].thumbUpNumber == 0{
                ce.thumbUpNumber.text = ""
            }else{
                
                ce.thumbUpNumber.text = "\(dynamicCar[number].thumbUpNumber)"
            }
        default:
            return
        }
       
    
    }
    
    func join(btn:UIButton){
        print("join")
        switch btn.tag/10000 {
            
        case 0:
            if dynamicOnline[btn.tag].isJoin == false{
                dynamicOnline[btn.tag].isJoin = true
                dynamicOnline[btn.tag].joinNumber = dynamicOnline[btn.tag].joinNumber + 1
            }else{
                
                dynamicOnline[btn.tag].isJoin = false
                dynamicOnline[btn.tag].joinNumber = dynamicOnline[btn.tag].joinNumber - 1
            }
            let ce = tableView1.cellForRowAtIndexPath(NSIndexPath(forRow: btn.tag, inSection: 0)) as!DynamicCell
            if dynamicOnline[btn.tag].isJoin == true{
                ce.join.setImage(UIImage(named: "hand-red"), forState: .Normal)
                ce.joinNumber.textColor = UIColor.redColor()
            }else{
                ce.join.setImage(UIImage(named: "cursor_hand"), forState: .Normal)
                ce.joinNumber.textColor = UIColor.blackColor()
            }
            if dynamicOnline[btn.tag].joinNumber == 0{
                
                ce.joinNumber.text = ""
            }else{
                
                ce.joinNumber.text = "\(dynamicOnline[btn.tag].joinNumber)"
            }
            
        case 1:
            print(btn.tag)
            let number = btn.tag - 10000
            if dynamicParty[number].isJoin == false{
                dynamicParty[number].isJoin = true
                dynamicParty[number].joinNumber = dynamicParty[number].joinNumber + 1
            }else{
                
                dynamicParty[number].isJoin = false
                dynamicParty[number].joinNumber = dynamicParty[number].joinNumber - 1
            }
            let ce = tableView2.cellForRowAtIndexPath(NSIndexPath(forRow: number, inSection: 0)) as!DynamicCell
            if dynamicParty[number].isJoin == true{
                ce.join.setImage(UIImage(named: "hand-red"), forState: .Normal)
                ce.joinNumber.textColor = UIColor.redColor()
            }else{
                ce.join.setImage(UIImage(named: "cursor_hand"), forState: .Normal)
                ce.joinNumber.textColor = UIColor.blackColor()
            }
            
            if dynamicParty[number].joinNumber == 0{
                
                ce.joinNumber.text = ""
            }else{
                
                ce.joinNumber.text = "\(dynamicParty[number].joinNumber)"
            }
            
        case 2:
            let number = btn.tag - 20000
            if dynamicTravel[number].isJoin == false{
                dynamicTravel[number].isJoin = true
                dynamicTravel[number].joinNumber = dynamicTravel[number].joinNumber + 1
            }else{
                
                dynamicTravel[number].isJoin = false
                dynamicTravel[number].joinNumber = dynamicTravel[number].joinNumber - 1
            }
            let ce = tableView3.cellForRowAtIndexPath(NSIndexPath(forRow: number, inSection: 0)) as!DynamicCell
            if dynamicTravel[number].isJoin == true{
                ce.join.setImage(UIImage(named: "hand-red"), forState: .Normal)
                ce.joinNumber.textColor = UIColor.redColor()
            }else{
                ce.join.setImage(UIImage(named: "cursor_hand"), forState: .Normal)
                ce.joinNumber.textColor = UIColor.blackColor()
            }
            
            if dynamicTravel[number].joinNumber == 0{
                
                ce.joinNumber.text = ""
            }else{
                
                ce.joinNumber.text = "\(dynamicTravel[number].joinNumber)"
            }
        case 3:
            let number = btn.tag - 30000
            if dynamicCar[number].isJoin == false{
                dynamicCar[number].isJoin = true
                dynamicCar[number].joinNumber = dynamicCar[number].joinNumber + 1
            }else{
                
                dynamicCar[number].isJoin = false
                dynamicCar[number].joinNumber = dynamicCar[number].joinNumber - 1
            }
            
            let ce = tableView4.cellForRowAtIndexPath(NSIndexPath(forRow: number, inSection: 0)) as!DynamicCell
            if dynamicCar[number].isJoin == true{
                ce.join.setImage(UIImage(named: "hand-red"), forState: .Normal)
                ce.joinNumber.textColor = UIColor.redColor()
            }else{
                ce.join.setImage(UIImage(named: "cursor_hand"), forState: .Normal)
                ce.joinNumber.textColor = UIColor.blackColor()
            }
            if dynamicCar[number].joinNumber == 0{
                
                ce.joinNumber.text = ""
            }else{
                
                ce.joinNumber.text = "\(dynamicCar[number].joinNumber)"
            }
        default:
            return
        }
    
    
    }
    
    
    func chat(btn:UIButton){
        print("chat")
        print(btn.titleLabel?.text!)
        name = btn.titleLabel?.text!
        self.performSegueWithIdentifier("toPersonal", sender: self)
        self.tabBarController?.tabBar.hidden = true
        
//        switch btn.tag/10000 {
//            
//        case 0:
//            let conversationViewController = ConversationViewController()
//            conversationViewController.targetId = dynamicOnline[btn.tag].userName
//            conversationViewController.conversationType = .ConversationType_PRIVATE
//            conversationViewController.title = dynamicOnline[btn.tag].userName
//            self.navigationController?.pushViewController(conversationViewController, animated: true)
//            self.tabBarController?.tabBar.hidden = true
//            
//        case 1:
//            print(btn.tag)
//            let number = btn.tag - 10000
//            let conversationViewController = ConversationViewController()
//            conversationViewController.targetId = dynamicParty[number].userName
//            conversationViewController.conversationType = .ConversationType_PRIVATE
//            conversationViewController.title = dynamicParty[number].userName
//            self.navigationController?.pushViewController(conversationViewController, animated: true)
//            self.tabBarController?.tabBar.hidden = true
//        case 2:
//            let number = btn.tag - 20000
//            let conversationViewController = ConversationViewController()
//            conversationViewController.targetId = dynamicTravel[number].userName
//            conversationViewController.conversationType = .ConversationType_PRIVATE
//            conversationViewController.title = dynamicTravel[number].userName
//            self.navigationController?.pushViewController(conversationViewController, animated: true)
//            self.tabBarController?.tabBar.hidden = true
//        case 3:
//            let number = btn.tag - 30000
//            let conversationViewController = ConversationViewController()
//            conversationViewController.targetId = dynamicCar[number].userName
//            conversationViewController.conversationType = .ConversationType_PRIVATE
//            conversationViewController.title = dynamicCar[number].userName
//            self.navigationController?.pushViewController(conversationViewController, animated: true)
//            self.tabBarController?.tabBar.hidden = true
//        default:
//            return
//        }
    
    
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("zhunbie2")
        if segue.identifier == "toPersonal"{
            print("zhunbei")
            let VC = segue.destinationViewController as! PersonalViewController
            VC.name = name
            print("...\(name)")
            if name == identifierValue{
                VC.isYourself = true
            }else{
                VC.isYourself = false
            }
        
        }else if segue.identifier == "meetsToComment"{
            let VC = segue.destinationViewController as! CommentViewController
            VC.dynamic = dynamicForComment
            VC.thumbUpUsers = thumbUpUserForComment
        }
        
        
        
    }
   
    
    
    func postTimeLine(){
        
        
        let urlString:String = "\(ip)/app.timeline.getAll?account=\(identifierValue)&count=30"
        let url: NSURL = NSURL(string: urlString)!
        let request1: NSURLRequest = NSURLRequest(URL: url)
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        
        
        do{
            
            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
            
            print(response)
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(dataVal, options: []) as? NSDictionary {
                    print("Synchronous\(jsonResult)")
                    
                    
                    let status = jsonResult.objectForKey("status") as! String
                    switch status {
                    case "620":
                        dynamicOnline.removeAll()
                        dynamicParty.removeAll()
                        dynamicCar.removeAll()
                        dynamicTravel.removeAll()
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
                            print(timeShow)
                            let likedUser = i.objectForKey("liked") as! [NSDictionary]
                            let thumbUpNumber = likedUser.count
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
                            let type = i.objectForKey("type") as! NSNumber
                            switch type {
                            case 0:
                                dynamicOnline.append(dynamicModel)
                            case 1:
                                dynamicParty.append(dynamicModel)
                            case 2:
                                dynamicTravel.append(dynamicModel)
                            case 3:
                                dynamicCar.append(dynamicModel)
                            default:
                                return
                            }
                            
                            number += 1
                        }
                        

                    case "630":
                        print("评论加载失败")
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
    
    func thumbUpHttp(islike:String,timelineID:Int,tag:Int,type:Int){
        
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
                
                switch type {
                case 0:
                    if userDefault.objectForKey("portrait") as! String != ""{
                        dynamicOnline[tag].thumbUpUser.append(Friends(id: identifierValue, name: identifierValue, portrait: userDefault.objectForKey("portrait") as! String))
                    }else{
                        dynamicOnline[tag].thumbUpUser.append(Friends(id: identifierValue, name: identifierValue, portrait: portrait))
                    }
                case 1:
                    if userDefault.objectForKey("portrait") as! String != ""{
                        dynamicParty[tag].thumbUpUser.append(Friends(id: identifierValue, name: identifierValue, portrait: userDefault.objectForKey("portrait") as! String))
                    }else{
                        dynamicParty[tag].thumbUpUser.append(Friends(id: identifierValue, name: identifierValue, portrait: portrait))
                    }
                case 2:
                    if userDefault.objectForKey("portrait") as! String != ""{
                        dynamicTravel[tag].thumbUpUser.append(Friends(id: identifierValue, name: identifierValue, portrait: userDefault.objectForKey("portrait") as! String))
                    }else{
                        dynamicTravel[tag].thumbUpUser.append(Friends(id: identifierValue, name: identifierValue, portrait: portrait))
                    }
                case 3:
                    if userDefault.objectForKey("portrait") as! String != ""{
                        dynamicCar[tag].thumbUpUser.append(Friends(id: identifierValue, name: identifierValue, portrait: userDefault.objectForKey("portrait") as! String))
                    }else{
                        dynamicCar[tag].thumbUpUser.append(Friends(id: identifierValue, name: identifierValue, portrait: portrait))
                    }
                default:
                    return
                }
                
                
            case "650":
                print("点赞失败")
            case "660":
                print("取消点赞成功")
                switch type {
                case 0:
                    for i in 0...dynamicOnline[tag].thumbUpUser.count-1{
                        if dynamicOnline[tag].thumbUpUser[i].id == identifierValue{
                            dynamicOnline[tag].thumbUpUser.removeAtIndex(i)
                        }
                    
                    }
                case 1:
                    for i in 0...dynamicParty[tag].thumbUpUser.count-1{
                        if dynamicParty[tag].thumbUpUser[i].id == identifierValue{
                            dynamicParty[tag].thumbUpUser.removeAtIndex(i)
                        }
                        
                    }
                case 2:
                    for i in 0...dynamicTravel[tag].thumbUpUser.count-1{
                        if dynamicTravel[tag].thumbUpUser[i].id == identifierValue{
                            dynamicTravel[tag].thumbUpUser.removeAtIndex(i)
                        }
                        
                    }
                case 3:
                    for i in 0...dynamicCar[tag].thumbUpUser.count-1{
                        if dynamicCar[tag].thumbUpUser[i].id == identifierValue{
                            dynamicCar[tag].thumbUpUser.removeAtIndex(i)
                        }
                        
                    }
                default:
                    return
                }
//                for i in 0...thumbUpUsers[tag].count-1{
//                    if thumbUpUsers[tag][i].id == identifierValue{
//                        thumbUpUsers[tag].removeAtIndex(i)
//                    }
//                }
            case "670":
                print("取消点赞失败")
            default:
                return
            }
            
        }catch{
            print("error")
            
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
