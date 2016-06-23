//
//  PublishViewController.swift
//  MyWechatRY
//
//  Created by 王凯 on 16/5/31.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit

class PublishViewController: UIViewController,UITextViewDelegate {

    let identifierValue = String(userDefault.objectForKey("identifier")!)
    let password = String(userDefault.objectForKey("password")!)
    var timer:NSTimer!
    var time:Int = 0
    
    
    @IBOutlet weak var waitView: UIView!
    
    @IBOutlet weak var waitIndicator: UIActivityIndicatorView!
    @IBOutlet weak var promptView: UIView!
    
    @IBOutlet weak var promptLabel: UILabel!
    
    
    
    @IBOutlet weak var addButton: UIButton!
    

    @IBOutlet weak var textContent: UITextView!
    
    @IBOutlet weak var informationLabel: UILabel!

    @IBOutlet weak var publishButton: UIButton!
    
    @IBAction func publishTheme(sender: AnyObject) {
        
        let optionMenu = UIAlertController(title: nil, message: "选择主题", preferredStyle: .ActionSheet)
        
        
        let onlineAction = UIAlertAction(title: "线上", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.addButton.setTitle("线上", forState: .Normal)
            if self.textContent.text != ""{
                self.publishButton.hidden = false
            }
        })
        let partyAction = UIAlertAction(title: "聚会", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.addButton.setTitle("聚会", forState: .Normal)
            if self.textContent.text != ""{
                self.publishButton.hidden = false
            }
        })
        
        
        let travelAction = UIAlertAction(title: "旅行", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.addButton.setTitle("旅行", forState: .Normal)
            if self.textContent.text != ""{
                self.publishButton.hidden = false
            }
        })
        
        let otherAction = UIAlertAction(title: "其他", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.addButton.setTitle("其他", forState: .Normal)
            if self.textContent.text != ""{
                self.publishButton.hidden = false
            }
        })
        
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        optionMenu.addAction(onlineAction)
        optionMenu.addAction(partyAction)
        optionMenu.addAction(travelAction)
        optionMenu.addAction(otherAction)
        optionMenu.addAction(cancelAction)
        
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        textContent.delegate = self
        publishButton.hidden = true
        informationLabel.enabled = false
        view.bringSubviewToFront(informationLabel)
        
        publishButton.addTarget(self, action: #selector(PublishViewController.publish), forControlEvents: .TouchUpInside)
        
        self.view.bringSubviewToFront(waitView)
        self.view.bringSubviewToFront(promptView)
        waitView.layer.hidden = true
        promptView.layer.hidden = true
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func textViewDidChange(textView: UITextView) {
        if textView.text != "" && addButton.titleLabel?.text != "添加" {
            publishButton.hidden = false
            informationLabel.hidden = true
        }else if textView.text == ""{
            informationLabel.hidden = false
            publishButton.hidden = true
            
        }else{
        
            publishButton.hidden = true
            informationLabel.hidden = true
            
        }
        
        
    }
    
    func publish(){
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.waitView.layer.hidden = false
                self.waitIndicator.startAnimating()
                
                
            })
            
            self.publishTimelineHttp()
        }

    }
    
    func publishTimelineHttp(){
    
        do{
            
            var response:NSURLResponse?
            let urlString:String = "\(ip)/app.timeline.post"
            var url:NSURL!
            url = NSURL(string:urlString)
            let request = NSMutableURLRequest(URL:url)
            
            let type:Int!
            switch addButton.titleLabel!.text! {
            case "线上":
                type = 0
            case "聚会":
                type = 1
            case "旅行":
                type = 2
            case "其他":
                type = 3
            default:
                return
            }
            
            let body = "account=\(identifierValue)&password=\(password)&text=\(textContent.text!)&type=\(type)"
            //编码POST数据
            let postData = body.dataUsingEncoding(NSUTF8StringEncoding)
            //保用 POST 提交
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            
            
            let data:NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
            let dict:AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            let dic = dict as! NSDictionary
            print(dic)
            let status = dic.objectForKey("success") as! String
            switch status {
            case "600":
                print("动态发送成功")
                dispatch_async(dispatch_get_main_queue(), {
                    self.waitView.layer.hidden = true
                    self.waitIndicator.stopAnimating()
                    self.promptView.layer.hidden = false
                    self.promptLabel.text = "动态发送成功"
                    self.promptLabel.numberOfLines = 2
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:  #selector(PublishViewController.prompt), userInfo: nil, repeats: true)
                    self.addButton.setTitle("添加", forState: .Normal)
                    self.textContent.text = ""
                })
                
            case "610":
                print("动态发送失败")
                dispatch_async(dispatch_get_main_queue(), {
                    self.waitView.layer.hidden = true
                    self.waitIndicator.stopAnimating()
                    self.promptView.layer.hidden = false
                    self.promptLabel.text = "动态发送失败"
                    self.promptLabel.numberOfLines = 2
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:  #selector(PublishViewController.prompt), userInfo: nil, repeats: true)
                })
            default:
                return
            }
            
        }catch{
            print("error")
            
        }

    
    
    
    
    
    
    }
    
    
    
    
    
    
    
    
    
    
    
    
    ////键盘收回
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        view.endEditing(true)
    }
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    
    func prompt(){
        
        if time == 1{
            
            
            dispatch_async(dispatch_get_main_queue()) {
                self.promptView.layer.hidden = true
                self.timer.invalidate()
            }
            time = 0
        }
        time += 1
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
