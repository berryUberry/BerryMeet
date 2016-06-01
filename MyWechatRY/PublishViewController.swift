//
//  PublishViewController.swift
//  MyWechatRY
//
//  Created by 王凯 on 16/5/31.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit

class PublishViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var addButton: UIButton!
    

    @IBOutlet weak var textContent: UITextView!
    
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var publishButton: UIBarButtonItem!
    
    @IBAction func publishTheme(sender: AnyObject) {
        
        let optionMenu = UIAlertController(title: nil, message: "选择主题", preferredStyle: .ActionSheet)
        
        
        let onlineAction = UIAlertAction(title: "线上", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.addButton.setTitle("线上", forState: .Normal)
            if self.textContent.text != ""{
                self.publishButton.enabled = true
            }
        })
        let partyAction = UIAlertAction(title: "聚会", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.addButton.setTitle("聚会", forState: .Normal)
            if self.textContent.text != ""{
                self.publishButton.enabled = true
            }
        })
        
        
        let travelAction = UIAlertAction(title: "旅行", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.addButton.setTitle("旅行", forState: .Normal)
            if self.textContent.text != ""{
                self.publishButton.enabled = true
            }
        })
        
        let otherAction = UIAlertAction(title: "其他", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.addButton.setTitle("其他", forState: .Normal)
            if self.textContent.text != ""{
                self.publishButton.enabled = true
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
        publishButton.enabled = false
        informationLabel.enabled = false
        view.bringSubviewToFront(informationLabel)
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
            publishButton.enabled = true
            informationLabel.hidden = true
        }else if textView.text == ""{
            informationLabel.hidden = false
            publishButton.enabled = false
            
        }else{
        
            publishButton.enabled = false
            informationLabel.hidden = true
            
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
