//
//  HelloVIewController.swift
//  MyWechatRY
//
//  Created by 王凯 on 16/5/6.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit

class HelloVIewController: UIViewController,UIScrollViewDelegate {
    var flag:Bool!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var registButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    var medel:PageControlModel!
    var count:Int!
    @IBOutlet weak var pageControl: UIPageControl!
    var scrollView:UIScrollView!
    var trueMedel = ["zhihu1","zhihu2"]
    var imageNumber:CGFloat = 0
    var addImage:UIImageView!
    var addImage2:UIImageView!
    
    @IBAction func toLoginup(sender: AnyObject) {
        if sender as! NSObject == loginButton{
            flag = true
            
        }else{
            flag = false
        }
        self.performSegueWithIdentifier("toLoginRegist", sender: sender)
        
    }
    
    

    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        scrollView = UIScrollView(frame: CGRectMake(0,0,self.view.bounds.width,self.view.bounds.height))
        medel = PageControlModel(images: trueMedel)
        count = trueMedel.count
        scrollView.contentSize = CGSizeMake(self.view.bounds.width * CGFloat(count), self.view.bounds.height)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.delegate = self
        
        
        scrollView.pagingEnabled = true
        view.addSubview(scrollView)
        for i in medel.images{
            
            let image_X:CGFloat = self.view.bounds.width * imageNumber
            let image:UIImageView = UIImageView(image: UIImage(named: i))
            image.frame = CGRectMake(image_X, 0, self.view.bounds.width, self.view.bounds.height)
            imageNumber += 1
            //print(image.frame)
            scrollView.addSubview(image)
        }
        
        pageControl.backgroundColor = UIColor.clearColor()
        pageControl.currentPage = 0
        pageControl.numberOfPages = count
        pageControl.addTarget(self, action: #selector(HelloVIewController.pageChanged), forControlEvents: .ValueChanged)
        
        
        addImage = UIImageView(frame: CGRectMake(140, 335, 1, 1))
        addImage.image = UIImage(named: "1")
        scrollView.addSubview(addImage)
        
        addImage2 = UIImageView(frame: CGRectMake(self.view.frame.width + 45, 550, 1, 1))
        addImage2.image = UIImage(named: "2")
        scrollView.addSubview(addImage2)
        
        
        view.bringSubviewToFront(pageControl)
        view.bringSubviewToFront(loginView)
        
        //addImage.layer.setAffineTransform(CGAffineTransformMakeScale(0.01, 0.01))
        UIView.animateWithDuration(0.3, delay: 0.5, options: .CurveLinear, animations: {
            //addImage.layer.setAffineTransform(CGAffineTransformMakeScale(1.6, 1.6))
            self.addImage.frame = CGRectMake(50, 250, 112, 112)
        }) { (true) in
            self.addImage.frame = CGRectMake(66, 266, 91, 91)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageNumber = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = pageNumber
        
    }
    
    
    func pageChanged(sender:UIPageControl){
        
        var frame = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0
        
        scrollView.scrollRectToVisible(frame, animated: true)
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let nextView = segue.destinationViewController as! LoginViewController
        if flag == true{
            nextView.isLogin = true
        }else{
            nextView.isLogin = false
        }
        
        
    }
    
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //print("a")
        //print(scrollView.contentOffset)
        if scrollView.contentOffset == CGPointMake(self.view.frame.width, 0){
            print("hi")
            
            
            
            UIView.animateWithDuration(0.3, delay: 0.5, options: .CurveLinear, animations: {
                self.addImage2.frame = CGRectMake(self.view.frame.width , 470, 80, 80)
                }, completion: { (true) in
                    self.addImage2.frame = CGRectMake(self.view.frame.width + 10, 490, 60, 60)
            })
            
            
            dispatch_async(dispatch_get_main_queue(), {
                self.addImage.frame = CGRectMake(140, 335, 1, 1)
                
            })
            
        }else if scrollView.contentOffset == CGPointMake(0, 0){
            
            
            UIView.animateWithDuration(0.3, delay: 0.5, options: .CurveLinear, animations: {
                
                self.addImage.frame = CGRectMake(50, 250, 112, 112)
                }, completion: { (true) in
                    self.addImage.frame = CGRectMake(66, 266, 91, 91)
            })
            
            
            addImage2.frame =  CGRectMake(self.view.frame.width + 45, 550, 1, 1)
            
        }
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("aaa")
    }

    
    
    
}
