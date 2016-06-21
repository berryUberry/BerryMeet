//
//  LoginViewController.swift
//  MyWechatRY
//
//  Created by 王凯 on 16/5/6.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController,UITextFieldDelegate {
    
    
    var response:NSURLResponse?
    
    var flag = 0
    var isLogin:Bool = true
    var mainView:UIView!
    var scrollView:UIScrollView!
    var infoButton:UIButton!
    var loginRegistButton:UIButton!
    var titleImageView:UIImageView!
    
    var changeView:UIView!
    var changeButton:UIButton!
    
    var accountTextField:UITextField!
    var passwordTextField:UITextField!
    
    var phoneTextField:UITextField!
    var passwordTextField2:UITextField!
    var nameTextField:UITextField!
    
    var timer:NSTimer!
    var time:Int = 0
    @IBOutlet weak var waitView: UIView!
    @IBOutlet weak var waitText: UILabel!
    @IBOutlet weak var waitButton: UIButton!
    @IBOutlet weak var waitIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var promptView: UIView!
    @IBOutlet weak var promptLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        if isLogin == false{
            change()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //accountUsers = Account()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillDisappear(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
        
        
        print(self.view.frame.height)
        print(self.view.frame.width)
        
        mainView = UIView(frame: CGRectMake(0,0,self.view.frame.width,self.view.frame.height))
        
        infoButton = UIButton(frame: CGRectMake(self.view.frame.width/4,self.view.frame.height * (1 - 240/667),self.view.frame.width/2,self.view.frame.height/25))
        
        infoButton.backgroundColor = UIColor.whiteColor()
        infoButton.setTitle("无法登陆？", forState: .Normal)
        infoButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        
        
        loginRegistButton = UIButton(frame: CGRectMake(self.view.frame.width/30,infoButton.frame.minY - 10 - (infoButton.frame.height * (3/2)),self.view.frame.width * (28/30),infoButton.frame.height * (3/2)))
        loginRegistButton.backgroundColor = UIColor(red: 5/255, green: 4/255, blue: 123/255, alpha: 0.8)
        loginRegistButton.setTitle("登录", forState: .Normal)
        loginRegistButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginRegistButton.layer.cornerRadius = 5
        
        changeView = UIView(frame: CGRectMake(self.view.frame.width/4,self.view.frame.height * (1 - 240/667),self.view.frame.width/2,self.view.frame.height/25))
        changeView.backgroundColor = UIColor.whiteColor()
        changeButton = UIButton(frame: CGRectMake(0,0,self.changeView.frame.width,self.changeView.frame.height))
        changeButton.setTitle("没有Berry账号？ 去注册", forState: .Normal)
        changeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        changeButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        changeButton.addTarget(self, action: #selector(LoginViewController.change), forControlEvents: .TouchUpInside)
        titleImageView = UIImageView(frame: CGRectMake(self.view.frame.width/2 - (1/2 * (185/64 * self.view.frame.height/8)), self.view.frame.height/20,185/64 * self.view.frame.height/8, self.view.frame.height/8))
        titleImageView.image = UIImage(named: "berry")
        
        //scroll view
        
        scrollView = UIScrollView(frame: CGRectMake(0,titleImageView.frame.height + 5,self.view.frame.width,loginRegistButton.frame.minY - titleImageView.frame.height - 5))
        
        scrollView.contentSize = CGSizeMake(2 * self.view.frame.width,loginRegistButton.frame.minY - titleImageView.frame.height - 5)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.scrollEnabled = false
        
        //Login UI
        
        
        let lineView1 = UIView(frame: CGRectMake(self.view.frame.width/30,scrollView.frame.height - 5,loginRegistButton.frame.width * (2/3),1))
        lineView1.backgroundColor = UIColor.blackColor()
        lineView1.alpha = 0.3
        
        let confirmationTextField = UITextField(frame: CGRectMake(self.view.frame.width/30,scrollView.frame.height - 5 - (loginRegistButton.frame.height),loginRegistButton.frame.width * (2/3),loginRegistButton.frame.height))
        confirmationTextField.placeholder = "验证码 (本功能还未开通)"
        confirmationTextField.borderStyle = .None
        confirmationTextField.clearButtonMode = .Always
        confirmationTextField.enabled = false
        
        let lineView2 = UIView(frame: CGRectMake(self.view.frame.width/30,confirmationTextField.frame.minY - 5,loginRegistButton.frame.width,1))
        lineView2.backgroundColor = UIColor.blackColor()
        lineView2.alpha = 0.3
        
        passwordTextField = UITextField(frame: CGRectMake(self.view.frame.width/30,confirmationTextField.frame.minY - 5 - confirmationTextField.frame.height,loginRegistButton.frame.width,confirmationTextField.frame.height))
        passwordTextField.placeholder = "密码"
        passwordTextField.borderStyle = .None
        passwordTextField.secureTextEntry = true
        passwordTextField.clearButtonMode = .Always
        
        let lineView3 = UIView(frame: CGRectMake(self.view.frame.width/30,passwordTextField.frame.minY - 5,passwordTextField.frame.width,1))
        lineView3.backgroundColor = UIColor.blackColor()
        lineView3.alpha = 0.3
        
        accountTextField = UITextField(frame: CGRectMake(self.view.frame.width/30,passwordTextField.frame.minY - 5 - passwordTextField.frame.height,passwordTextField.frame.width,passwordTextField.frame.height))
        accountTextField.placeholder = "账号名称(英文字母)"
        accountTextField.borderStyle = .None
        accountTextField.clearButtonMode = .Always
        accountTextField.autocapitalizationType = .None
        
        
        
        
        
        //regist UI
        
        
        let lineView11 = UIView(frame: CGRectMake(self.view.frame.width/30 + self.view.frame.width,scrollView.frame.height - 5,loginRegistButton.frame.width * (2/3),1))
        lineView11.backgroundColor = UIColor.blackColor()
        lineView11.alpha = 0.3
        
        let confirmationTextField2 = UITextField(frame: CGRectMake(self.view.frame.width/30 + self.view.frame.width,scrollView.frame.height - 5 - (loginRegistButton.frame.height),loginRegistButton.frame.width * (2/3),loginRegistButton.frame.height))
        confirmationTextField2.placeholder = "验证码 (本功能还未开通)"
        confirmationTextField2.borderStyle = .None
        confirmationTextField2.clearButtonMode = .Always
        confirmationTextField2.enabled = false
        
        let lineView12 = UIView(frame: CGRectMake(self.view.frame.width/30 + self.view.frame.width,confirmationTextField.frame.minY - 5,loginRegistButton.frame.width,1))
        lineView12.backgroundColor = UIColor.blackColor()
        lineView12.alpha = 0.3
        
        passwordTextField2 = UITextField(frame: CGRectMake(self.view.frame.width/30 + self.view.frame.width,confirmationTextField.frame.minY - 5 - confirmationTextField.frame.height,loginRegistButton.frame.width,confirmationTextField.frame.height))
        passwordTextField2.placeholder = "密码"
        passwordTextField2.borderStyle = .None
        passwordTextField2.secureTextEntry = true
        passwordTextField2.clearButtonMode = .Always
        
        
        let lineView13 = UIView(frame: CGRectMake(self.view.frame.width/30 + self.view.frame.width,passwordTextField.frame.minY - 5,passwordTextField.frame.width,1))
        lineView13.backgroundColor = UIColor.blackColor()
        lineView13.alpha = 0.3
        
        phoneTextField = UITextField(frame: CGRectMake(self.view.frame.width/30 + self.view.frame.width,passwordTextField.frame.minY - 5 - passwordTextField.frame.height,passwordTextField.frame.width,passwordTextField.frame.height))
        phoneTextField.placeholder = "手机号(本功能还未开通)"
        phoneTextField.borderStyle = .None
        phoneTextField.clearButtonMode = .Always
        phoneTextField.keyboardType = .NumberPad
        phoneTextField.enabled = false
        
        let lineView14 = UIView(frame: CGRectMake(self.view.frame.width/30 + self.view.frame.width,phoneTextField.frame.minY - 5,phoneTextField.frame.width,1))
        lineView14.backgroundColor = UIColor.blackColor()
        lineView14.alpha = 0.3
        
        nameTextField = UITextField(frame: CGRectMake(self.view.frame.width/30 + self.view.frame.width,phoneTextField.frame.minY - 5 - phoneTextField.frame.height,phoneTextField.frame.width,phoneTextField.frame.height))
        nameTextField.placeholder = "账号名称(英文字母)"
        nameTextField.borderStyle = .None
        nameTextField.clearButtonMode = .Always
        nameTextField.autocapitalizationType = .None
        
        
        
        
        view.addSubview(mainView)
        view.addSubview(changeView)
        view.bringSubviewToFront(changeView)
        mainView.addSubview(scrollView)
        
        
        mainView.addSubview(infoButton)
        mainView.addSubview(loginRegistButton)
        mainView.addSubview(titleImageView)
        changeView.addSubview(changeButton)
        
        
        scrollView.addSubview(confirmationTextField)
        scrollView.addSubview(confirmationTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(accountTextField)
        
        
        scrollView.addSubview(lineView1)
        scrollView.addSubview(lineView2)
        scrollView.addSubview(lineView3)
        
        scrollView.addSubview(confirmationTextField2)
        scrollView.addSubview(passwordTextField2)
        scrollView.addSubview(phoneTextField)
        scrollView.addSubview(nameTextField)
        
        
        scrollView.addSubview(lineView11)
        scrollView.addSubview(lineView12)
        scrollView.addSubview(lineView13)
        scrollView.addSubview(lineView14)
        
        
        //        print(nameTextField.frame)
        //        print(accountTextField.frame)
        //        print(changeView.frame)
        
        
        loginRegistButton.addTarget(self, action: #selector(LoginViewController.toList), forControlEvents: .TouchUpInside)
        
        self.view.bringSubviewToFront(waitButton)
        self.view.bringSubviewToFront(waitView)
        self.view.bringSubviewToFront(promptView)
        waitView.layer.hidden = true
        waitButton.layer.hidden = true
        promptView.layer.hidden = true
        
        
        
    }
    func change(){
        if flag == 0{
            flag = 1
            infoButton.setTitle("点击注册按钮代表你已经阅读并同意了协议", forState: .Normal)
            infoButton.titleLabel?.numberOfLines = 2
            infoButton.hidden = true
            changeButton.setTitle("已有Berry账号？ 去登录", forState: .Normal)
            loginRegistButton.setTitle("注册", forState: .Normal)
        }else{
            flag = 0
            infoButton.setTitle("无法登陆？", forState: .Normal)
            infoButton.titleLabel?.numberOfLines = 1
            changeButton.setTitle("没有Berry账号？ 去注册", forState: .Normal)
            loginRegistButton.setTitle("登录", forState: .Normal)
        }
        
        var frame = scrollView.frame
        frame.origin.x = self.view.frame.width * CGFloat(flag)
        
        scrollView.scrollRectToVisible(frame, animated: true)
        
        
        
    }
    
    func keyboardWillAppear(notification: NSNotification) {
        
        // 获取键盘信息
        let keyboardinfo = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]
        
        let keyboardheight:CGFloat = (keyboardinfo?.CGRectValue.size.height)!
        
        print("键盘弹起")
        
        print(keyboardheight)
        
        infoButton.hidden = false
        
        self.mainView.frame.origin.y = -self.titleImageView.frame.maxY + 15
        self.changeView.frame.origin.y = self.view.frame.height - keyboardheight/2
    }
    
    func keyboardWillDisappear(notification:NSNotification){
        
        infoButton.hidden = true
        self.mainView.frame.origin.y = 0
        self.changeView.frame.origin.y = self.view.frame.height * (1 - 240/667)
        print("键盘落下")
    }
    
    ////键盘收回
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        

        view.endEditing(true)
    }
    
    func toList(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            dispatch_async(dispatch_get_main_queue(), {
               
                self.accountTextField.resignFirstResponder()
                self.passwordTextField.resignFirstResponder()
                self.passwordTextField2.resignFirstResponder()
                self.nameTextField.resignFirstResponder()
                
                self.waitView.layer.hidden = false
                self.waitButton.layer.hidden = false
                self.waitIndicator.startAnimating()
                
                
            })
            
            self.connectHttp()
        }
        
    }
    
    
    func connectHttp(){
        do{
            if self.loginRegistButton.titleLabel?.text == "登录"{
                print("denglu")
                
                let urlString:String = "\(ip)/app.login?"
                var url:NSURL!
                url = NSURL(string:urlString)
                let request = NSMutableURLRequest(URL:url)
                let body = "account=\(accountTextField.text!)&password=\(passwordTextField.text!)"
                //编码POST数据
                let postData = body.dataUsingEncoding(NSASCIIStringEncoding)
                //保用 POST 提交
                request.HTTPMethod = "POST"
                request.HTTPBody = postData
                
                
                let data:NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
                let dict:AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                let dic = dict as! NSDictionary
                
                
                let status = dic.objectForKey("status") as! String
                print(dic)
                
                
                switch status {
                case "200":
                    print("登录成功")
                    
                    let userInfo = dic.objectForKey("userInfo") as! NSDictionary
                    
                    let userIsDefaultAvatar = userInfo.objectForKey("isDefaultAvatar") as! Bool
                    
                    if userIsDefaultAvatar == true{
                        userDefault.setObject("", forKey: "portrait")
                    }else{
                        let dateTime = NSDate()
                        let timeInterval = dateTime.timeIntervalSince1970
                        print(Int(timeInterval))
                        let headImage = userInfo.objectForKey("avatarURL") as! String
                        let headImageURL = "\(avatarURLHeader)\(headImage)?v=\(Int(timeInterval))"
                        userDefault.setObject(headImageURL, forKey: "portrait")

                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                            let imageURL = NSURL(string: headImageURL)
                            let imageData = NSData(contentsOfURL: imageURL!)
                            let smallImage = UIImageJPEGRepresentation(UIImage(data: imageData!)!, 0.1)
                            
                            userDefault.setObject(smallImage, forKey: "\(self.accountTextField.text!)Head")
                            
                        }
            
                    }
                    let follow_infos = userInfo.objectForKey("follow_infos") as! Array<NSDictionary>
                    
                    for i in follow_infos{

//                        let portrait = i.objectForKey("avatarURL") as! String
//                        let friends = Friends(id: name, name: name, portrait: portrait)
//                        friendsList.append(friends)
                        
                        
                        let name = i.objectForKey("_id") as! String
                        
                        let isDefaultAvatar = i.objectForKey("isDefaultAvatar") as! Bool
                        if isDefaultAvatar == false{
                            let dateTime = NSDate()
                            let timeInterval = dateTime.timeIntervalSince1970
                            var avatarURL = i.objectForKey("avatarURL") as! String
                            avatarURL = "\(avatarURLHeader)\(avatarURL)?v=\(Int(timeInterval))"
                            let friend = Friends(id: name, name: name, portrait: avatarURL)
                            friendsList.append(friend)
                            
                            
                            
                            
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                                let imageURL = NSURL(string: avatarURL)
                                let imageData = NSData(contentsOfURL: imageURL!)
                                let smallImage = UIImageJPEGRepresentation(UIImage(data: imageData!)!, 0.1)
                                
                                userDefault.setObject(smallImage, forKey: "\(name)Head")
                                
                            }
                            
                            
                            
                        }else{
                            
                            let friend = Friends(id: name, name: name, portrait: portrait)
                            friendsList.append(friend)
                        }

                        
                        
                    }
                    friendFlag = false
                    //实例对象转换成NSData
                    let modelData:NSData = NSKeyedArchiver.archivedDataWithRootObject(friendsList)
                    //存储NSData对象
                    userDefault.setObject(modelData, forKey: "\(accountTextField.text!)friendsList")
                    
                    
                    
                    //get token
                    
                    let urlString:String = "\(ip)/app.rongcloud.token?"
                    var url:NSURL!
                    url = NSURL(string:urlString)
                    let request = NSMutableURLRequest(URL:url)
                    let body = "account=\(accountTextField.text!)"
                    //编码POST数据
                    let postData = body.dataUsingEncoding(NSASCIIStringEncoding)
                    //保用 POST 提交
                    request.HTTPMethod = "POST"
                    request.HTTPBody = postData
                    
                    
                    let data:NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
                    let dict:AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                    let dic = dict as! NSDictionary
                    
                    
                    let status = dic.objectForKey("status") as! String
                    
                    switch status {
                    case "100":
                        
                        let token = (dic.objectForKey("rcToken") as! String)
                        userDefault.setObject(token, forKey: "token")
                        
                        userDefault.setObject(self.accountTextField.text!, forKey: "identifier")
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.waitView.layer.hidden = true
                            self.waitButton.layer.hidden = true
                            self.waitIndicator.stopAnimating()
                            self.performSegueWithIdentifier("toFriendList", sender: self)
                            
                        })
                        
                        print("token获取成功")
                        
                    case "110":
                        print("token获取失败")
                        friendsList.removeAll()
                        dispatch_async(dispatch_get_main_queue(), {
                            self.waitView.layer.hidden = true
                            self.waitButton.layer.hidden = true
                            self.waitIndicator.stopAnimating()
                            self.promptView.layer.hidden = false
                            self.promptLabel.text = "token获取失败"
                            self.promptLabel.numberOfLines = 2
                            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:  #selector(LoginViewController.prompt), userInfo: nil, repeats: true)
                        })
                        
                    default:
                        friendsList.removeAll()
                        dispatch_async(dispatch_get_main_queue(), {
                            self.waitView.layer.hidden = true
                            self.waitButton.layer.hidden = true
                            self.waitIndicator.stopAnimating()
                            self.promptView.layer.hidden = false
                            self.promptLabel.text = "请重新登录"
                            self.promptLabel.numberOfLines = 2
                            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:  #selector(LoginViewController.prompt), userInfo: nil, repeats: true)
                        })
                        return
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                case "210":
                    print("账号不存在或密码不正确")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.waitView.layer.hidden = true
                        self.waitButton.layer.hidden = true
                        self.waitIndicator.stopAnimating()
                        self.promptView.layer.hidden = false
                        self.promptLabel.text = "账号不存在或密码不正确"
                        self.promptLabel.numberOfLines = 2
                        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:  #selector(LoginViewController.prompt), userInfo: nil, repeats: true)
                    })
                    
                    
                    
                default:
                    dispatch_async(dispatch_get_main_queue(), {
                        self.waitView.layer.hidden = true
                        self.waitButton.layer.hidden = true
                        self.waitIndicator.stopAnimating()
                        self.promptView.layer.hidden = false
                        self.promptLabel.text = "请重新登录"
                        self.promptLabel.numberOfLines = 2
                        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:  #selector(LoginViewController.prompt), userInfo: nil, repeats: true)
                    })
                    return
                }
                
                
       
            
            }
            else{
                print("zhuce")
   
                let urlString:String = "\(ip)/app.register?"
                var url:NSURL!
                url = NSURL(string:urlString)
                let request = NSMutableURLRequest(URL:url)
                let body = "account=\(nameTextField.text!)&password=\(passwordTextField2.text!)"
                //编码POST数据
                let postData = body.dataUsingEncoding(NSASCIIStringEncoding)
                //保用 POST 提交
                request.HTTPMethod = "POST"
                request.HTTPBody = postData
                
                
                let data:NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
                let dict:AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                let dic = dict as! NSDictionary
                let status = dic.objectForKey("status") as! String
                
                
                switch status {
                case "370":
                    print("手机号已被注册")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.waitView.layer.hidden = true
                        self.waitButton.layer.hidden = true
                        self.waitIndicator.stopAnimating()
                        
                        self.promptView.layer.hidden = false
                        self.promptLabel.text = "账号已被注册"
                        self.nameTextField.text = nil
                        self.passwordTextField2.text = nil
                        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:  #selector(LoginViewController.prompt), userInfo: nil, repeats: true)
                    })
                    
                    
                case "340":
                    print("注册成功")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.waitView.layer.hidden = true
                        self.waitButton.layer.hidden = true
                        self.waitIndicator.stopAnimating()
                        
                        self.promptView.layer.hidden = false
                        self.promptLabel.text = "注册成功"
                        self.nameTextField.text = nil
                        self.passwordTextField2.text = nil
                        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:  #selector(LoginViewController.prompt), userInfo: nil, repeats: true)
                    })
                case "350":
                    print("注册失败")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.waitView.layer.hidden = true
                        self.waitButton.layer.hidden = true
                        self.waitIndicator.stopAnimating()
                        
                        self.promptView.layer.hidden = false
                        self.promptLabel.text = "注册失败"
                        self.nameTextField.text = nil
                        self.passwordTextField2.text = nil
                        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:  #selector(LoginViewController.prompt), userInfo: nil, repeats: true)
                    })
                default:
                    print(status)
                    return
                }

                
           }
        
        }catch{
            print("网络问题")
            dispatch_async(dispatch_get_main_queue(), {
                self.waitView.layer.hidden = true
                self.waitButton.layer.hidden = true
                self.waitIndicator.stopAnimating()
                
                self.promptView.layer.hidden = false
                self.promptLabel.text = "网络问题"
                self.nameTextField.text = nil
                self.passwordTextField2.text = nil
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:  #selector(LoginViewController.prompt), userInfo: nil, repeats: true)
            })

        }
    
    
    }
    
    
    
    
    func prompt(){
        print("asdsaaaaaaaa")
        print("asdsddddddssddddd\(time)")
        if time == 1{
        
        
        dispatch_async(dispatch_get_main_queue()) {
            self.promptView.layer.hidden = true
            self.timer.invalidate()
        }
            time = 0
        }
        time += 1
    
    }
    
}
