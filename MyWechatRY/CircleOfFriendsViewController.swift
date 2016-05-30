//
//  CircleOfFriendsViewController.swift
//  MyWechatRY
//
//  Created by 王凯 on 16/5/9.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit

class CircleOfFriendsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{

    var circleModels:[CircleOfFriendModel] = []
    
    var orginalImgs = Array<UIImage>()
    var originalImage:UIImage!
    var largeImage:UIImageView!
    var backButton:UIButton!
    var flagImageFrame:CGRect!
    var tag:Int!
    
    @IBOutlet weak var addCircleView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var circleImage: UIImageView!
    @IBOutlet weak var transparentButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let identifierValue = String(userDefault.objectForKey("identifier")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCircleView.hidden = true
        transparentButton.hidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func addCircle(sender: AnyObject) {
        
        
        let pick:UIImagePickerController = UIImagePickerController()
        pick.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            print("canmera")
        }
        
        self.presentViewController(pick, animated: true, completion: nil)
        
        
    
    }
    
    @IBAction func publish(sender: AnyObject) {
       
        
        
        let model:CircleOfFriendModel = CircleOfFriendModel(name: identifierValue, text: textField.text!, image: circleImage.image!, portraitUri: portrait)
        
        circleModels.append(model)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
            self.textField.text = nil
            self.addCircleView.hidden = true
            self.transparentButton.hidden = true
            self.tabBarController?.tabBar.hidden = false
        }
        
    
        
    }
    
    @IBAction func cancel(sender: AnyObject) {
        
        textField.text = nil
        addCircleView.hidden = true
        transparentButton.hidden = true
        self.tabBarController?.tabBar.hidden = false
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return circleModels.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("circleCell") as! CircleOfFriends
        
        if circleModels.count != 0{
        
            let userPortraitFlag = userDefault.objectForKey("portrait")
            if userPortraitFlag == nil{
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    let imageURL = NSURL(string: portrait)
                    let imageData = NSData(contentsOfURL: imageURL!)
                    let smallImage = UIImageJPEGRepresentation(UIImage(data: imageData!)!, 0.3)
                    cell.portraitUri.image = UIImage(data: smallImage!)
                    
                    
                    userDefault.setObject(smallImage, forKey: "portrait")
                    print("2")
                }
            }else{
                let userPortraitData:NSData = userDefault.objectForKey("portrait") as! NSData
                let userPortrait = UIImage(data: userPortraitData)
                cell.portraitUri.image = userPortrait
                
            }
            
            cell.userName.text = identifierValue
            cell.circleText.text = circleModels[circleModels.count - 1 - indexPath.row].text
            cell.circleImage.image = circleModels[circleModels.count - 1 - indexPath.row].image
            
            
            cell.selectionStyle = .None
            
            cell.circleImageButton.addTarget(self, action: #selector(CircleOfFriendsViewController.cheakImage(_:)), forControlEvents: .TouchUpInside)
            cell.circleImageButton.tag = circleModels.count - 1 - indexPath.row
            
        }
        
        
        return cell
    }
    
    
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let gotInfo = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        originalImage = gotInfo
        orginalImgs.append(originalImage)
        let smallImage = UIImageJPEGRepresentation(gotInfo, 0.3)
        circleImage.image = UIImage(data: smallImage!)
        
        addCircleView.hidden = false
        transparentButton.hidden = false
        self.tabBarController?.tabBar.hidden = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print(scrollView.contentOffset)
    }
    
    func cheakImage(btn:UIButton){
    
        tag = btn.tag
        print(tag)
        //flagImageFrame = tableView.rectForRowAtIndexPath(NSIndexPath(index: btn.tag))
        let rectIntableView = tableView.rectForRowAtIndexPath(NSIndexPath(forRow: tag, inSection: 1))
        print(rectIntableView)
        flagImageFrame = tableView.convertRect(rectIntableView, toView: tableView.superview)

        
        print(flagImageFrame)
        
        
        transparentButton.hidden = false
        largeImage = UIImageView(frame: CGRectMake(0,0,self.view.frame.width, self.view.frame.height))
        largeImage.image = orginalImgs[btn.tag]
        self.view.addSubview(largeImage)
        self.view.bringSubviewToFront(largeImage)
        
        backButton = UIButton(frame: CGRectMake(0,0,self.view.frame.width,self.view.frame.height))
        backButton.backgroundColor = UIColor.clearColor()
        backButton.addTarget(self, action: #selector(CircleOfFriendsViewController.dismissImage), forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton)
        self.view.bringSubviewToFront(backButton)
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = true
    
    }
    
    
    func dismissImage(){
        
        
        self.backButton.removeFromSuperview()
        transparentButton.hidden = true
        self.tabBarController?.tabBar.hidden = false
        self.navigationController?.navigationBar.hidden = false
        UIView.animateWithDuration(0.5, animations: {
            self.largeImage.frame = self.flagImageFrame
            
            print(self.largeImage.frame)
            }) { (true) in
                self.largeImage.removeFromSuperview()
        }
        
        
        
    }
    

    ///键盘收回
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        view.endEditing(true)
    }

    
    
}
