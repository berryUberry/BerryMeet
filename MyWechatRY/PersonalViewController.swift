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
    let a = DynamicModel.init(userPortraitUrl: "http://ww1.sinaimg.cn/crop.0.0.1080.1080.1024/006411vBjw8esguzhdwj7j30u00u0dhf.jpg", userName: "Berry", dynamic: "sdfdsddhsdhdhdhdhdshkadhfjksdahfasdhjkfhasdfhsdajkfhaskjdfhaskdfhkasdflhasdkfkhasdjkfhsjadkfhjdsafhajsdkfhjaskdfhjkasdfhjasdhfeuiywuieyrfiuqweyriqweryqwejiwjefjkfhjsdgfasgdfhfjashfdhsadfhkfiuqwyeruiyerweqyiryqweuryeuwqirhjsdhfashfjkasdhfiuwyruiehfjsahfksadfjkashfyweuryhuewfhsjadfkjhdakfhsdjfhaskdfhsajdkfhakdsjfhklasdfhkjaslfdhjakdfhjkasdfhjsdkfhjkasdhfkjasdfasdhfjksdhfjsdhfjskahdfkjahsdlfjashdfahsdfjkhadfjkladhfadhfjksdhfkjsadhfjaksdfhdfiuwhefiuqhweufhuqwefhweuifheuwihfuwehfweufhuwehfuqwehfuwhqefdsjkfhaklsfjdsafhlkadjhfkhsdfhkjskdfhksdhfjskhdfkjshdfjksdhfjkasdjfhsakjdfhjksadhfjkashdfjkashfjsd", thumbUpNumber: 0,isThumbUp:false, joinNumber:0,isJoin:false, commentsNumber: 99)
    let b = DynamicModel.init(userPortraitUrl: "http://ww1.sinaimg.cn/crop.0.0.1080.1080.1024/006411vBjw8esguzhdwj7j30u00u0dhf.jpg", userName: "Berry", dynamic: "sdlkfjkalsjdflajksdkfjaskldf", thumbUpNumber: 0,isThumbUp: false, joinNumber: 0, isJoin: false,commentsNumber: 0)
    let c = DynamicModel.init(userPortraitUrl: "http://ww1.sinaimg.cn/crop.0.0.1080.1080.1024/006411vBjw8esguzhdwj7j30u00u0dhf.jpg", userName: "Berry", dynamic: "asdf", thumbUpNumber: 0, isThumbUp: false,joinNumber: 0, isJoin: false,commentsNumber: 0)
    /////////////
    
    var DyHeight = Array<CGFloat>()
    var name:String!
    let identifierValue = String(userDefault.objectForKey("identifier")!)
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    
    
    
    
    
    
    
    
    @IBAction func addFriend(sender: AnyObject) {
        
        
        
        
        
        
        
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
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.delegate = nil
        self.navigationController?.navigationBar.lt_reset()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personalDynamic.append(a)
        personalDynamic.append(b)
        personalDynamic.append(c)
        
        nameLabel.text = name
        chatButton.layer.cornerRadius = 10
        addButton.layer.cornerRadius = 10
        
        for i in personalDynamic{
        
            let maxLabelSize: CGSize = CGSizeMake(self.view.frame.width - 54, CGFloat(9999))
            let contentNSString = i.dynamic as NSString
            let expectedLabelSize = contentNSString.boundingRectWithSize(maxLabelSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16.0)], context: nil)
            DyHeight.append(expectedLabelSize.size.height+140)
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
        
        ce.userPortrait.image = UIImage(named:"xixi.jpg")
        ce.userName.setTitle(personalDynamic[indexPath.row].userName, forState: .Normal)
        ce.dynamicContent.text = personalDynamic[indexPath.row].dynamic
        ce.dynamicContent.sizeThatFits(CGSizeMake(self.view.frame.width - 54, 9999))
        ce.dynamicContent.font = UIFont.systemFontOfSize(16.0)
        ce.dynamicContent.numberOfLines = 0
        
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
    
    
    
        
    
    
}
