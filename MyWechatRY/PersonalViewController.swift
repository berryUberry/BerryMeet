//
//  PersonalViewController.swift
//  MyWechatRY
//
//  Created by 王凯 on 16/6/1.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit

class PersonalViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
//////////////////////数据模拟
    
    var personalDynamic = Array<DynamicModel>()
//    let a = DynamicModel.init(userPortraitUrl: "http://ww1.sinaimg.cn/crop.0.0.1080.1080.1024/006411vBjw8esguzhdwj7j30u00u0dhf.jpg", userName: "Berry", dynamic: "sdfdsddhsdhdhdhdhdshkadhfjksdahfasdhjkfhasdfhsdajkfhaskjdfhaskdfhkasdflhasdkfkhasdjkfhsjadkfhjdsafhajsdkfhjaskdfhjkasdfhjasdhfeuiywuieyrfiuqweyriqweryqwejiwjefjkfhjsdgfasgdfhfjashfdhsadfhkfiuqwyeruiyerweqyiryqweuryeuwqirhjsdhfashfjkasdhfiuwyruiehfjsahfksadfjkashfyweuryhuewfhsjadfkjhdakfhsdjfhaskdfhsajdkfhakdsjfhklasdfhkjaslfdhjakdfhjkasdfhjsdkfhjkasdhfkjasdfasdhfjksdhfjsdhfjskahdfkjahsdlfjashdfahsdfjkhadfjkladhfadhfjksdhfkjsadhfjaksdfhdfiuwhefiuqhweufhuqwefhweuifheuwihfuwehfweufhuwehfuqwehfuwhqefdsjkfhaklsfjdsafhlkadjhfkhsdfhkjskdfhksdhfjskhdfkjshdfjksdhfjkasdjfhsakjdfhjksadhfjkashdfjkashfjsd", thumbUpNumber: 0,isThumbUp:false, joinNumber:0,isJoin:false, commentsNumber: 99,thumbUpUser: [])
//    let b = DynamicModel.init(userPortraitUrl: "http://ww1.sinaimg.cn/crop.0.0.1080.1080.1024/006411vBjw8esguzhdwj7j30u00u0dhf.jpg", userName: "Berry", dynamic: "sdlkfjkalsjdflajksdkfjaskldf", thumbUpNumber: 0,isThumbUp: false, joinNumber: 0, isJoin: false,commentsNumber: 0,thumbUpUser: [])
//    let c = DynamicModel.init(userPortraitUrl: "http://ww1.sinaimg.cn/crop.0.0.1080.1080.1024/006411vBjw8esguzhdwj7j30u00u0dhf.jpg", userName: "Berry", dynamic: "asdf", thumbUpNumber: 0, isThumbUp: false,joinNumber: 0, isJoin: false,commentsNumber: 0,thumbUpUser: [])
    /////////////
    
    var DyHeight = Array<CGFloat>()
    var name:String!
    let identifierValue = String(userDefault.objectForKey("identifier")!)
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    
    @IBOutlet weak var userHead: UIImageView!
    
    
    
    
    
    
    
    @IBAction func addFriend(sender: AnyObject) {
        
        if addButton.titleLabel?.text == "关注"{
            addButton.setTitle("已关注", forState: .Normal)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                self.addFriendHttp("follow")
            }
        }else{
            let alert = UIAlertController(title: "\(name)", message: nil, preferredStyle: .ActionSheet)
            let unfollow = UIAlertAction(title: "不再关注", style: .Destructive, handler: { (UIAlertAction) in
                self.addButton.setTitle("关注", forState: .Normal)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    self.addFriendHttp("unfollow")
                }
            })
            let cancle = UIAlertAction(title: "取消", style: .Cancel, handler: { (UIAlertAction) in
            })
            alert.addAction(unfollow)
            alert.addAction(cancle)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
        
        
        
    }
    
    
    
    
    @IBAction func chat(sender: AnyObject) {
        
        let conversationViewController = ConversationViewController()
        conversationViewController.targetId = name
        conversationViewController.conversationType = .ConversationType_PRIVATE
        conversationViewController.title = name
        self.navigationController?.pushViewController(conversationViewController, animated: true)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let color = UIColor(red: 18/255, green: 26/255, blue: 38/255, alpha: 0)
        self.navigationController?.navigationBar.lt_setBackgroundColor(color)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.getPersonalTimeline()
            for i in self.personalDynamic{
                
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.delegate = nil
        self.navigationController?.navigationBar.lt_reset()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        personalDynamic.append(a)
//        personalDynamic.append(b)
//        personalDynamic.append(c)
        
        nameLabel.text = name
        chatButton.layer.cornerRadius = 10
        addButton.layer.cornerRadius = 10
        addButton.setTitle("关注", forState: .Normal)
        
        let userData = userDefault.objectForKey("\(identifierValue)friendsList") as! NSData
        let user = NSKeyedUnarchiver.unarchiveObjectWithData(userData) as! Array<Friends>

        for i in user{
            
            if name == i.id{
                addButton.setTitle("已关注", forState: .Normal)
            }
        
        }
        
        if userDefault.objectForKey("\(name)Head") as? NSData != nil{
            
            userHead.image = UIImage(data: userDefault.objectForKey("\(name)Head") as! NSData)
        
        }else{
        
            userHead.image = UIImage(named: "xixi")
        }
       
        
        tableView.registerNib(UINib(nibName: "DynamicCell",bundle: nil), forCellReuseIdentifier: "cell")
        
    }
    
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personalDynamic.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return DyHeight[indexPath.row]
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "动态"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! DynamicCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let ce = cell as! DynamicCell
        
        
        
        
        if userDefault.objectForKey("\(personalDynamic[indexPath.row].userName)Head") as? NSData != nil{
        
            ce.userPortrait.image = UIImage(data: userDefault.objectForKey("\(personalDynamic[indexPath.row].userName)Head") as! NSData)
        
        }else{
        
            ce.userPortrait.image = UIImage(named:"xixi.jpg")
        }
        
        
        ce.userName.setTitle(personalDynamic[indexPath.row].userName, forState: .Normal)
        ce.dynamicContent.text = personalDynamic[indexPath.row].dynamic
        ce.dynamicContent.sizeThatFits(CGSizeMake(self.view.frame.width - 54, 9999))
        ce.dynamicContent.font = UIFont.systemFontOfSize(16.0)
        ce.dynamicContent.numberOfLines = 0
        ce.timeShow.text = personalDynamic[indexPath.row].timeShow
        
        //处理点赞参与评论颜色
        if personalDynamic[indexPath.row].isThumbUp == true{
            ce.thumbUp.setImage(UIImage(named: "heart-red"), forState: .Normal)
            ce.thumbUpNumber.textColor = UIColor.redColor()
            
        }else{
            ce.thumbUp.setImage(UIImage(named: "heart"), forState: .Normal)
            ce.thumbUpNumber.textColor = UIColor.blackColor()
        }
        
        if personalDynamic[indexPath.row].isJoin == true{
            ce.join.setImage(UIImage(named: "hand-red"), forState: .Normal)
            ce.joinNumber.textColor = UIColor.redColor()
        }else{
            ce.join.setImage(UIImage(named: "cursor_hand"), forState: .Normal)
            ce.joinNumber.textColor = UIColor.blackColor()
        }
        
        if personalDynamic[indexPath.row].thumbUpNumber == 0{
            ce.thumbUpNumber.text = ""
        }else{
            
            ce.thumbUpNumber.text = "\(personalDynamic[indexPath.row].thumbUpNumber)"
        }
        if personalDynamic[indexPath.row].joinNumber == 0{
            
            ce.joinNumber.text = ""
        }else{
            
            ce.joinNumber.text = "\(personalDynamic[indexPath.row].joinNumber)"
        }
        if personalDynamic[indexPath.row].commentsNumber == 0{
            ce.commentsNumber.text = ""
        }else{
            ce.commentsNumber.text = "\(personalDynamic[indexPath.row].commentsNumber)"
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let color = UIColor(red: 18/255, green: 26/255, blue: 38/255, alpha: 1)
        let offsetY:CGFloat = scrollView.contentOffset.y
        if offsetY > 50{
            let alpha = min(0.98,1 - (114 - offsetY)/64)
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
            
        
        }else{
        
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
        }
        
    }
    
    
    
    func addFriendHttp(isfollow:String){
        do{
            var response:NSURLResponse?
            let urlString:String = "\(ip)/app.friend.\(isfollow)"
            var url:NSURL!
            url = NSURL(string:urlString)
            let request = NSMutableURLRequest(URL:url)
            let body = "account=\(identifierValue)&targetID=\(name)"
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
            case "500":
                print("关注成功")
                /////此处头像url设置为空，因为friendsList并没有使用到portrait参数，不会影响其他内容
                let fri = Friends(id: name, name: name, portrait: "")
                friendsList.append(fri)
                friends.append(name)
                
                userDefault.setObject(friends, forKey: "\(identifierValue)")
                
                ///////////
                
                //实例对象转换成NSData
                let modelData:NSData = NSKeyedArchiver.archivedDataWithRootObject(friendsList)
                //存储NSData对象
                userDefault.setObject(modelData, forKey: "\(identifierValue)friendsList")

            case "510":
                print("关注失败")
            case "520":
                print("取消关注成功")
                
                let userData = userDefault.objectForKey("\(identifierValue)friendsList") as! NSData
                let user = NSKeyedUnarchiver.unarchiveObjectWithData(userData) as! Array<Friends>
                for i in 0...user.count-1{
                    if friendsList[i].id == name{
                        friendsList.removeAtIndex(i)
                        //实例对象转换成NSData
                        let modelData:NSData = NSKeyedArchiver.archivedDataWithRootObject(friendsList)
                        //存储NSData对象
                        userDefault.setObject(modelData, forKey: "\(identifierValue)friendsList")
                    }
                
                }
            case "530":
                print("取消关注失败")
            default:
                return
            }
            
        }catch{
            print("网络问题")
          
            
        }
        
        
    }
    
    func getPersonalTimeline(){
        let urlString:String = "\(ip)/app.timeline.get?account=\(name)"
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
                        let timelines = jsonResult.objectForKey("timelines") as! [NSDictionary]
                        for i in timelines{
                            
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
                            var isThumbUp = false
                            var thumbUpUsers = Array<Friends>()
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
                                thumbUpUsers.append(thumbUpUser)
                            }
                            let commentsNumber = i.objectForKey("commentCount") as! Int
                            
                            let dynamicModel = DynamicModel(userPortraitUrl: userPortraitUrl, userName: userName, dynamic: dynamic, thumbUpNumber: thumbUpNumber, isThumbUp: isThumbUp, joinNumber: 0, isJoin: false, commentsNumber: commentsNumber, thumbUpUser: thumbUpUsers,timeShow: timeShow,dynamicId: dynamicId)
                            
                            personalDynamic.append(dynamicModel)
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
