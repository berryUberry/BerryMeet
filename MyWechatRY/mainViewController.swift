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
    
    
    
    var tableView1:UITableView!
    var tableView2:UITableView!
    var tableView3:UITableView!
    var tableView4:UITableView!
    
    
    
    override func viewDidLoad() {
        let a = DynamicModel.init(userPortraitUrl: "", userName: "aa", dynamic: "sdfdsddhsdhdhdhdhdshkadhfjksdahfasdhjkfhasdfhsdajkfhaskjdfhaskdfhkasdflhasdkfkhasdjkfhsjadkfhjdsafhajsdkfhjaskdfhjkasdfhjasdhfeuiywuieyrfiuqweyriqweryqwejiwjefjkfhjsdgfasgdfhfjashfdhsadfhkfiuqwyeruiyerweqyiryqweuryeuwqirhjsdhfashfjkasdhfiuwyruiehfjsahfksadfjkashfyweuryhuewfhsjadf", thumbUpNumber: 0, joinNumber:0, commentsNumber: 0)
        let b = DynamicModel.init(userPortraitUrl: "", userName: "bb", dynamic: "sdlkfjkalsjdflajksdkfjaskldf", thumbUpNumber: 0, joinNumber: 0, commentsNumber: 0)
        let c = DynamicModel.init(userPortraitUrl: "", userName: "cc", dynamic: "asdf", thumbUpNumber: 0, joinNumber: 0, commentsNumber: 0)
        dynamicOnline.append(a)
        dynamicOnline.append(b)
        dynamicOnline.append(c)
        let d = DynamicModel.init(userPortraitUrl: "", userName: "dd", dynamic: "sdfdsddhsdhdhdhdhdshkadhfjksdahfasdhjkfhasdfhsdajkfhaskjdfhaskdfhkasdflhasdkfkhasdjkfhsjadkfhjdsafhajsdkfhjaskdfhjkasdfhjasdhfeuiywuieyrfiuqweyriqweryqwejiwjefjkfhjsdgfasgdfhfjashfdhsadfhkfiuqwyeruiyerweqyiryqweuryeuwqirhjsdhfashfjkasdhfiuwyruiehfjsahfksadfjkashfyweuryhuewfhsjadf", thumbUpNumber: 0, joinNumber:0, commentsNumber: 0)
        let e = DynamicModel.init(userPortraitUrl: "", userName: "ee", dynamic: "sdlkfjkalsjdflajksdkfjaskldf", thumbUpNumber: 0, joinNumber: 0, commentsNumber: 0)
        let f = DynamicModel.init(userPortraitUrl: "", userName: "ff", dynamic: "asdf", thumbUpNumber: 0, joinNumber: 0, commentsNumber: 0)
        
        
        dynamicTravel.append(d)
        dynamicTravel.append(e)
        dynamicTravel.append(f)
        
        dynamicCar.append(a)
        dynamicParty.append(b)
        
        
        
        super.viewDidLoad()
        segmentedControl3 = XMSegmentedControl(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)! + 20, width: self.view.frame.width, height: 44), segmentTitle: ["online", "party", "travel","car"], selectedItemHighlightStyle: XMSelectedItemHighlightStyle.TopEdge)
        
        segmentedControl3.backgroundColor = UIColor(red: 22/255, green: 150/255, blue: 122/255, alpha: 1)
        segmentedControl3.highlightColor = UIColor(red: 25/255, green: 180/255, blue: 145/255, alpha: 1)
        segmentedControl3.tint = UIColor.whiteColor()
        segmentedControl3.highlightTint = UIColor.blackColor()
        
        self.view.addSubview(segmentedControl3)
        segmentedControl3.delegate = self
        
        scrollView = UIScrollView(frame: CGRectMake(0,segmentedControl3.frame.maxY,self.view.frame.width,self.view.frame.height - segmentedControl3.frame.maxY))
        scrollView.contentSize = CGSizeMake(self.view.frame.width * 4, self.view.frame.height - segmentedControl3.frame.maxY)
        
        scrollView.delegate = self
        
        tableView1 = UITableView(frame: CGRectMake(0,0,self.view.frame.width,self.view.frame.height))
        tableView2 = UITableView(frame: CGRectMake(self.view.frame.width,0, self.view.frame.width, self.view.frame.height))
        tableView3 = UITableView(frame: CGRectMake(self.view.frame.width*2,0, self.view.frame.width, self.view.frame.height))
        tableView4 = UITableView(frame: CGRectMake(self.view.frame.width*3,0, self.view.frame.width, self.view.frame.height))
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
        
//        let buttonA = UIButton(frame: CGRectMake(100,100,100,100))
//        buttonA.backgroundColor = UIColor.blackColor()
//        let buttonB = UIButton(frame: CGRectMake(100+self.view.frame.width,100,100,100))
//        buttonB.backgroundColor = UIColor.blackColor()
//        let buttonC = UIButton(frame: CGRectMake(100+self.view.frame.width*2,100,100,100))
//        buttonC.backgroundColor = UIColor.blackColor()
//        scrollView.addSubview(buttonA)
//        scrollView.addSubview(buttonB)
//        scrollView.addSubview(buttonC)
        
        
//        tableView1.registerClass(DynamicCell.self, forCellReuseIdentifier: "cell1")
//        tableView2.registerClass(DynamicCell.self, forCellReuseIdentifier: "cell2")
//        tableView3.registerClass(DynamicCell.self, forCellReuseIdentifier: "cell3")
//        tableView4.registerClass(DynamicCell.self, forCellReuseIdentifier: "cell4")
        tableView1.registerNib(UINib(nibName: "DynamicCell",bundle: nil), forCellReuseIdentifier: "cell")
        tableView2.registerNib(UINib(nibName: "DynamicCell",bundle: nil), forCellReuseIdentifier: "cell")
        tableView3.registerNib(UINib(nibName: "DynamicCell",bundle: nil), forCellReuseIdentifier: "cell")
        tableView4.registerNib(UINib(nibName: "DynamicCell",bundle: nil), forCellReuseIdentifier: "cell")
        scrollView.scrollEnabled = false
        self.view.addSubview(scrollView)
        
        for i in dynamicOnline{
            let testLabel = UILabel(frame: CGRectMake(46,46,self.view.frame.width - 54 ,25))
            testLabel.text = i.dynamic
            testLabel.sizeToFit()
            onlineheight.append(testLabel.frame.height+100)
        }
        for i in dynamicParty{
        
            let testLabel = UILabel(frame: CGRectMake(46,46,self.view.frame.width - 54 ,25))
            testLabel.text = i.dynamic
            testLabel.sizeToFit()
            partyheight.append(testLabel.frame.height+100)
        }
        for i in dynamicCar{
        
            let testLabel = UILabel(frame: CGRectMake(46,46,self.view.frame.width - 54 ,25))
            testLabel.text = i.dynamic
            testLabel.sizeToFit()
            carheight.append(testLabel.frame.height+100)
        }
        for i in dynamicTravel{
            let testLabel = UILabel(frame: CGRectMake(46,46,self.view.frame.width - 54 ,25))
            testLabel.text = i.dynamic
            testLabel.sizeToFit()
            travelheight.append(testLabel.frame.height+100)
        
        }
        
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
        
        if tableView == tableView1{
            
            ce.userName.setTitle(dynamicOnline[indexPath.row].userName, forState: .Normal)
            ce.dynamicContent.text = dynamicOnline[indexPath.row].dynamic
            
            
        
            
        }else if tableView == tableView2{
            
            ce.userName.setTitle(dynamicParty[indexPath.row].userName, forState: .Normal)
            ce.dynamicContent.text = dynamicParty[indexPath.row].dynamic
            
            
        }else if tableView == tableView3{
            
            ce.userName.setTitle(dynamicTravel[indexPath.row].userName, forState: .Normal)
            ce.dynamicContent.text = dynamicTravel[indexPath.row].dynamic
            
            
        }else{
            
            
            ce.userName.setTitle(dynamicCar[indexPath.row].userName, forState: .Normal)
            ce.dynamicContent.text = dynamicCar[indexPath.row].dynamic
           
            
        }

    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == tableView1{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! DynamicCell
//            cell.userPortrait = UIImageView(frame: CGRectMake(8, 8, 30, 30))
//            cell.userName = UIButton(frame: CGRectMake(8,8,self.view.frame.width/2,30))
//            cell.dynamicContent = UILabel(frame: CGRectMake(46,46,self.view.frame.width - 54 ,25))
//            cell.dynamicContent.sizeToFit()
            
            //cell.userPortrait.image = UIImage(data: NSData(contentsOfURL: NSURL(fileURLWithPath: dynamicOnline[indexPath.row].userPortraitUrl))!)
//            cell.userName.setTitle(dynamicOnline[indexPath.row].userName, forState: .Normal)
//            cell.dynamicContent.text = dynamicOnline[indexPath.row].dynamic
//            
            
            return cell
            
        }else if tableView == tableView2{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! DynamicCell
//            cell.userPortrait = UIImageView(frame: CGRectMake(8, 8, 30, 30))
//            cell.userName = UIButton(frame: CGRectMake(8,8,self.view.frame.width/2,30))
//            cell.dynamicContent = UILabel(frame: CGRectMake(46,46,self.view.frame.width - 54 ,25))
//            cell.dynamicContent.sizeToFit()
            //cell.userPortrait.image = UIImage(data: NSData(contentsOfURL: NSURL(fileURLWithPath: dynamicParty[indexPath.row].userPortraitUrl))!)
//            cell.userName.setTitle(dynamicParty[indexPath.row].userName, forState: .Normal)
//            cell.dynamicContent.text = dynamicParty[indexPath.row].dynamic
            //partyheight.append(cell.dynamicContent.frame.height)
            return cell
        }else if tableView == tableView3{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! DynamicCell
//            cell.userPortrait = UIImageView(frame: CGRectMake(8, 8, 30, 30))
//            cell.userName = UIButton(frame: CGRectMake(8,8,self.view.frame.width/2,30))
//            cell.dynamicContent = UILabel(frame: CGRectMake(46,46,self.view.frame.width - 54 ,25))
//            cell.dynamicContent.sizeToFit()
            //cell.userPortrait.image = UIImage(data: NSData(contentsOfURL: NSURL(fileURLWithPath: dynamicTravel[indexPath.row].userPortraitUrl))!)
//            cell.userName.setTitle(dynamicTravel[indexPath.row].userName, forState: .Normal)
//            cell.dynamicContent.text = dynamicTravel[indexPath.row].dynamic
            //travelheight.append(cell.dynamicContent.frame.height)
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! DynamicCell
//            cell.userPortrait = UIImageView(frame: CGRectMake(8, 8, 30, 30))
//            cell.userName = UIButton(frame: CGRectMake(8,8,self.view.frame.width/2,30))
//            cell.dynamicContent = UILabel(frame: CGRectMake(46,46,self.view.frame.width - 54 ,25))
//            cell.dynamicContent.sizeToFit()
            //cell.userPortrait.image = UIImage(data: NSData(contentsOfURL: NSURL(fileURLWithPath: dynamicCar[indexPath.row].userPortraitUrl))!)
//            cell.userName.setTitle(dynamicCar[indexPath.row].userName, forState: .Normal)
//            cell.dynamicContent.text = dynamicCar[indexPath.row].dynamic
            //carheight.append(cell.dynamicContent.frame.height)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == tableView1{
            print(indexPath.row)
            print(onlineheight[indexPath.row])
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
    func xmSegmentedControl(xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        print(selectedSegment)
        
        var frame = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(selectedSegment)
        frame.origin.y = segmentedControl3.frame.maxY
        
        scrollView.scrollRectToVisible(frame, animated: true)
    }
}
