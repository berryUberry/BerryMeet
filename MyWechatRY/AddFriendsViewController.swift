//
//  AddFriendsViewController.swift
//  MyWechatRY
//
//  Created by 王凯 on 16/5/12.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit

class AddFriendsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    var isFind = false
    var isFirst = true
    var addFriends = Array<Friends>()
    let identifierValue = String(userDefault.objectForKey("identifier")!)
    var flag:Int!
    
    
    var timer:NSTimer!
    var time:Int = 0
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var uNameLabel: UILabel!
    

    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var searchTableView: UITableView!
    
    
    @IBOutlet weak var waitView: UIView!
    
    @IBOutlet weak var waitIndicatotView: UIActivityIndicatorView!
    
    @IBOutlet weak var remindView: UIView!
    
    @IBOutlet weak var remindLabel: UILabel!
    
    
    @IBAction func search(sender: AnyObject) {
        
        self.navigationController?.navigationBar.hidden = true
        self.searchView.hidden = false
       
        self.navigationController?.navigationBar.barStyle = .Default
        
        searchTextField.becomeFirstResponder()
        self.searchTableView.reloadData()
        
        
        
    }

    @IBAction func back(sender: AnyObject) {
        
        print("ttt")
        isFirst = true
        isFind = false
        searchTextField.resignFirstResponder()
        self.navigationController?.navigationBar.hidden = false
        self.searchView.hidden = true
        searchTextField.text = nil
        self.navigationController?.navigationBar.barStyle = .Black
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        searchTextField.returnKeyType = .Search
        searchTextField.keyboardType = .Default
        searchTextField.autocapitalizationType = .None
        
        let identifierValue = String(userDefault.objectForKey("identifier")!)
        self.uNameLabel.text = "My Name:  \(identifierValue)"
        self.searchView.hidden = true
        self.waitView.hidden = true
        
        self.remindView.hidden = true
        
    }
    
    
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFind == false{
            print("000")
            
            if isFirst{
                
                return 0
                
            }else{
                
                return 1
            
            }
        
        }else{
            
            return addFriends.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if isFind == false{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("addFriendsCell") as! AddFriendsCell
            cell.nameLabel.text = "用户不存在"
            cell.userInteractionEnabled = false
            cell.addFriendsButton.hidden = true
            return cell
            
            
        }else{
        
            
            let cell = tableView.dequeueReusableCellWithIdentifier("addFriendsCell") as! AddFriendsCell
            cell.nameLabel.text = addFriends[indexPath.row].id
            
            cell.userInteractionEnabled = true
            cell.addFriendsButton.hidden = false
            
//            let userPortraitFlag = userDefault.objectForKey("portrait")
            let userPortraitFlag = addFriends[indexPath.row].portrait
            if userPortraitFlag == portrait{
                
                
                cell.portraitImage.image = UIImage(named: "xixi")
            }else{
                
                
//                let userPortraitData:NSData = userDefault.objectForKey("portrait") as! NSData
//
//                let userPortrait = UIImage(data: userPortraitData)
//                cell.portraitImage.image = userPortrait
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//                    let imageURL = NSURL(string: self.addFriends[indexPath.row].portrait)
//                    let imageData = NSData(contentsOfURL: imageURL!)
//                    
//                    let smallImage = UIImageJPEGRepresentation(UIImage(data: imageData!)!, 0.3)
//                    cell.portraitImage.image = UIImage(data: smallImage!)
//                    print("3")
//                    
//                    
//                }
                let imageURL = NSURL(string: self.addFriends[indexPath.row].portrait)
                let imageData = NSData(contentsOfURL: imageURL!)
                
                let smallImage = UIImageJPEGRepresentation(UIImage(data: imageData!)!, 0.3)
                cell.portraitImage.image = UIImage(data: smallImage!)
                print("3")
                
            }
            
            for i in friendsList{
                if i.id == addFriends[indexPath.row].id{
                    cell.addFriendsButton.layer.hidden = true
                }
            
            }
            
            cell.addFriendsButton.tag = indexPath.row
            cell.addFriendsButton.addTarget(self, action: #selector(AddFriendsViewController.addToFriendsList(_:)), forControlEvents: .TouchUpInside)
            
            
            return cell
        }
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let conversationViewController = ConversationViewController()
        conversationViewController.targetId = addFriends[indexPath.row].id
        //conversationViewController.userName = addFriends[indexPath.row].name
        conversationViewController.conversationType = .ConversationType_PRIVATE
        conversationViewController.title = addFriends[indexPath.row].name
        
        
        self.navigationController?.pushViewController(conversationViewController, animated: true)
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
        isFirst = true
        isFind = false
        searchTextField.resignFirstResponder()
        
        self.searchView.hidden = true
        searchTextField.text = nil
        self.navigationController?.navigationBar.barStyle = .Black
        
        
        
    }
    
    func connectAddFriends(){
        do{
            isFirst = false
            
            var response:NSURLResponse?
            let urlString:String = "\(ip)/app.search.account"
            var url:NSURL!
            url = NSURL(string:urlString)
            let request = NSMutableURLRequest(URL:url)
            let body = "account=\(identifierValue)&searchString=\(searchTextField.text!)"
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
            case "400":
                print("搜索成功")
                isFind = true
            
                
                let findNameArray = dic.objectForKey("users") as! NSArray
                print(findNameArray)
                for i in findNameArray{
                    let dateTime = NSDate()
                    let timeInterval = dateTime.timeIntervalSince1970
                    print(Int(timeInterval))
                    
                    let name = i.objectForKey("_id") as! String
                    print(name)
                    
                    let isDefaultAvatar = i.objectForKey("isDefaultAvatar") as! Bool
                    if isDefaultAvatar == false{
                        var avatarURL = i.objectForKey("avatarURL") as! String
                        avatarURL = "\(avatarURLHeader)\(avatarURL)?v=\(Int(timeInterval))"
                        let friend = Friends(id: name, name: name, portrait: avatarURL)
                        addFriends.append(friend)
                    
                    }else{
                    
                        let friend = Friends(id: name, name: name, portrait: portrait)
                        addFriends.append(friend)
                        print(addFriends)
                    }
                    
                    
                    
                   
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.waitView.hidden = true
                    self.waitIndicatotView.stopAnimating()
                    self.searchTableView.reloadData()
                })
                
               
                
                
            case "410":
                print("查找用户不存在")
                isFind = false
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.waitView.hidden = true
                    self.waitIndicatotView.stopAnimating()
                    self.remindView.hidden = false
                    self.remindLabel.text = "查找用户不存在"
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:  #selector(LoginViewController.prompt), userInfo: nil, repeats: true)
                    
                    
                    self.searchTableView.reloadData()
                })
                
            default:
                return
            }
            

        
        }catch{
            print("网络问题")
            dispatch_async(dispatch_get_main_queue(), {
                self.waitView.hidden = true
                self.waitIndicatotView.stopAnimating()
                self.remindView.hidden = false
                self.remindLabel.text = "网络问题"
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:  #selector(LoginViewController.prompt), userInfo: nil, repeats: true)
            })
        
        }
        
    
    
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func addToFriendsList(btn:UIButton){
        
        
    
        self.waitView.hidden = false
        self.waitIndicatotView.startAnimating()
        flag = btn.tag
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.addFriendHttp()
        }
        
    }
    
    
    
    
    func addFriendHttp(){
    
    
    
        do{
            
            
            var response:NSURLResponse?
            let urlString:String = "\(ip)/app.friend.follow"
            var url:NSURL!
            url = NSURL(string:urlString)
            let request = NSMutableURLRequest(URL:url)
            let body = "account=\(identifierValue)&targetID=\(addFriends[flag].id)"
            print(identifierValue)
            print(addFriends[flag].id)
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
                
                friendsList.append(addFriends[flag])
                friends.append(addFriends[flag].id)
                print("\(friends)yyyyyyyyyyyy")
                userDefault.setObject(friends, forKey: "\(identifierValue)")
                
                ///////////
                
                
                
                //实例对象转换成NSData
                let modelData:NSData = NSKeyedArchiver.archivedDataWithRootObject(friendsList)
                //存储NSData对象
                userDefault.setObject(modelData, forKey: "\(identifierValue)friendsList")
                
                
                
                
                
                
                
//                userDefault.setObject(friendsList, forKey: "\(identifierValue)friendsList")
//                let a = userDefault.objectForKey("\(identifierValue)friendsList")
//                print("herehereherehere")
//                print(a)
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.waitView.hidden = true
                    self.waitIndicatotView.stopAnimating()
                    self.searchTableView.reloadData()
                })
                
                
                
                
            case "510":
                print("关注失败")
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.waitView.hidden = true
                    self.waitIndicatotView.stopAnimating()
                    self.remindView.hidden = false
                    self.remindLabel.text = "关注失败！"
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:  #selector(LoginViewController.prompt), userInfo: nil, repeats: true)
                    
                    
                    //self.searchTableView.reloadData()
                })
                
            default:
                return
            }
            
            
            
        }catch{
            print("网络问题")
            dispatch_async(dispatch_get_main_queue(), {
                self.waitView.hidden = true
                self.waitIndicatotView.stopAnimating()
                self.remindView.hidden = false
                self.remindLabel.text = "网络问题"
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:  #selector(LoginViewController.prompt), userInfo: nil, repeats: true)
            })
            
        }
    
    
    
    
    
    
    
    }
    
    
    
    
    
    ////键盘收回
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        print("uiuiuiuiui")
        
        
        self.waitView.hidden = false
        self.waitIndicatotView.startAnimating()
        
        
       
        
        
        
        self.addFriends.removeAll()
        
        
        //self.searchTableView.reloadData()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.connectAddFriends()
        }
        
        
        
        
        
        
        
        
        
        
        return true
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        view.endEditing(true)
    }
    
    
    
    
    
    func prompt(){
        print("asdsaaaaaaaa")
        print("asdsddddddssddddd\(time)")
        if time == 1{
            
            
            self.remindView.hidden = true
            self.timer.invalidate()
            
            time = 0
        }
        time += 1
        
    }
    
    
    
    
    
    
    
    
    
}
