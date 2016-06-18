//
//  AppDelegate.swift
//  MyWechatRY
//
//  Created by 王凯 on 16/4/24.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit

//var identifier:String?
//var token:String?
let portrait:String = "http://b.hiphotos.baidu.com/image/h%3D200/sign=0afb9ebc4c36acaf46e091fc4cd88d03/bd3eb13533fa828b670a4066fa1f4134970a5a0e.jpg"
let avatarURLHeader = "http://o7b20it1b.bkt.clouddn.com/"
let ip:String = "http://42.96.155.17:3000/mobile"
var userDefault = NSUserDefaults.standardUserDefaults()


var friendsList = Array<Friends>()
var friends = Array<String>()
var friendFlag = true



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,RCIMUserInfoDataSource,RCIMReceiveMessageDelegate{

    var window: UIWindow?
    
    var badgeFlag:Bool = true
    let notification = UILocalNotification()
    let application = UIApplication.sharedApplication()
    
    func getUserInfoWithUserId(userId: String!, completion: ((RCUserInfo!) -> Void)!) {
        
        let userInfo = RCUserInfo()
        userInfo.userId = userId
        userInfo.portraitUri = portrait
        userInfo.name = userId
        print(userId)
//        switch userId {
//        case "lynn":
//            userInfo.name = "lynn"
//            userInfo.portraitUri = "http://photo.weibo.com/5187664653/wbphotos/large/mid/3972106305560269/pid/005F4Uyxgw1f3l9dt75hrj30m80gognc"
//        case "monzy":
//            userInfo.name = "monzy"
//            userInfo.portraitUri = "http://ww4.sinaimg.cn/large/5df89726gw1epjarhzqwkj24m032w1lb.jpg"
//        case "pt":
//            userInfo.name = "pt"
//            userInfo.portraitUri = "http://ww4.sinaimg.cn/large/5df89726gw1epjarhzqwkj24m032w1lb.jpg"
//        case "berry":
//            userInfo.name = "berryberry"
//            userInfo.portraitUri = "http://ww4.sinaimg.cn/large/5df89726gw1epjarhzqwkj24m032w1lb.jpg"
//        default:
//            print("无此用户")
//        }
    
        return completion(userInfo)
    }

   
  
   
    
    func connectServer(completion:() -> Void){
        
        let identifierValue = String(userDefault.objectForKey("identifier")!)
        let tokenValue = String(userDefault.objectForKey("token")!)
        RCIM.sharedRCIM().initWithAppKey("pwe86ga5em5h6")
        RCIM.sharedRCIM().connectWithToken(tokenValue, success: { (_) in
            
            
            let currentUser = RCUserInfo(userId: identifierValue, name: identifierValue, portrait: portrait)
            
            
           
            RCIMClient.sharedRCIMClient().currentUserInfo = currentUser
      
            dispatch_async(dispatch_get_main_queue(), {
                completion()
            })
            
            
            }, error: { (_) in
                print("连接失败")
        }) {
            print("Token不正确")
        }
        

    }
    

    
    func onRCIMReceiveMessage(message: RCMessage!, left: Int32) {
        print("shit")
    }

    func onRCIMCustomLocalNotification(message: RCMessage!, withSenderName senderName: String!) -> Bool {
        
        print("shabi")
        notification.timeZone = NSTimeZone.localTimeZone()
        notification.alertTitle = "BerryChat"
        notification.repeatInterval = NSCalendarUnit.Day
        
        print(senderName)
//        let content = NSString.init(data: message.content.encode(), encoding: NSUTF8StringEncoding)! as String
        let contentDictionary = try! NSJSONSerialization.JSONObjectWithData(message.content.encode(), options: .AllowFragments) as! NSDictionary
        let content = contentDictionary.objectForKey("content")!
        print("sdddddd\(content)sdsdf")
        notification.alertBody = "\(senderName):  \(content)"
        
        if badgeFlag == true{
            notification.applicationIconBadgeNumber = 0
            badgeFlag = false
        
        }
        
        notification.applicationIconBadgeNumber += 1
        print(notification.applicationIconBadgeNumber)
        application.presentLocalNotificationNow(notification)
        
        
        return true
    }
    
    
    
    func onRCIMCustomAlertSound(message: RCMessage!) -> Bool {
        print("fuc")
        return false
    }

    
    
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UITabBar.appearance().tintColor = UIColor(red: 85/255, green: 149/255, blue: 122/255, alpha: 1)
        
        
        RCIM.sharedRCIM().userInfoDataSource = self
        
        RCIM.sharedRCIM().receiveMessageDelegate = self
        
        if userDefault.objectForKey("identifier") != nil{
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("tabbarController") as! UITabBarController
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()

        }
            
        
        
        
        //本地推送
        
        if (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8{
        
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Badge, categories: nil))
//            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert, categories: nil))
//            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Sound, categories: nil))
        }
        
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        badgeFlag = true
        application.cancelAllLocalNotifications()
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

