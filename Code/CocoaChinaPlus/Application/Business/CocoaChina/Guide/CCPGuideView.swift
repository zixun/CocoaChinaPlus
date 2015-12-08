//
//  CCPGuideView.swift
//  GuideViewTest
//
//  Created by 邓锋 on 15/11/24.
//  Copyright © 2015年 邓锋. All rights reserved.
//

import UIKit

let LocalVersionKey = "LocalVersionKey"
let LocalFirstLaunchKey = "LocalFirstLaunchKey"

// MARK: - 成员属性 && 初始化
public class CCPGuideView: UIView{
 /// 返回背景图
    public typealias BackgroundImage = Void -> UIImage
    public var sbackgroundImage : BackgroundImage?
 /// 返回每一页需显示的内容图
    public typealias ContentImages = Void -> Array<UIImage>
    public var contentImages : ContentImages?
 /// 返回每一页需显示的内容图的大小  默认全屏 注意，这里按照图片的比例
    public typealias ContentSize = Void ->CGSize
    public var contentSize : ContentSize?
 /// 返回每一页需显示的标题
    public typealias Titles = Void -> Array<String>
    public var titles : Titles?
 /// 返回完成按钮
    public typealias DoneButton = Void -> UIButton
    public var doneButton : DoneButton?
 /// 返回完成按钮在纵坐标上的位置比例
    public typealias DoneButtonYLocation = Void ->CGFloat
    public var doneButtonYLocation : DoneButtonYLocation?
    
 /// window
    private lazy var w : UIWindow = {
        let w = UIWindow(frame:UIScreen.mainScreen().bounds)
        w.windowLevel = UIWindowLevelNormal
        w.rootViewController = UIViewController()
        w.backgroundColor = UIColor.redColor()
        w.hidden = false
        return w
    }()
    
    private lazy var cc_backgroundImage : UIImage? = {
        return self.sbackgroundImage?()
    }()
    
    private lazy var cc_contentImages : Array<UIImage> = {
        
        
        return self.contentImages?() ?? [UIImage(named: "guide1", inBundle: NSBundle(forClass:CCPGuideView.self), compatibleWithTraitCollection: nil)!,UIImage(named: "guide2", inBundle: NSBundle(forClass:CCPGuideView.self), compatibleWithTraitCollection: nil)!,UIImage(named: "guide3", inBundle: NSBundle(forClass:CCPGuideView.self), compatibleWithTraitCollection: nil)!,UIImage(named: "guide4", inBundle: NSBundle(forClass:CCPGuideView.self), compatibleWithTraitCollection: nil)!]
    }()
    private lazy var cc_contentSize : CGSize = {
        return self.contentSize?() ?? self.frame.size
    }()
    private lazy var cc_titles : Array<String> = {
        return self.titles?() ?? ["第一页","第二页","第三页","第四页"]
    }()
    
    private lazy var cc_doneButton : UIButton = {
        if self.doneButton?() != nil{
            let button : UIButton = (self.doneButton?())!
            if CGPointEqualToPoint(button.frame.origin,CGPointZero){
                button.frame = CGRectMake(self.frame.size.width * 0.1, self.frame.size.height * self.cc_doneButtonYLocation, self.frame.size.width * 0.8, 50);
            }
            button.addTarget(self, action: "onFinishedIntroButtonPressed", forControlEvents: .TouchUpInside)
            return button;
        
        }else{
            let button : UIButton = UIButton(frame:CGRectMake(self.frame.size.width * 0.1, self.frame.size.height * self.cc_doneButtonYLocation, self.frame.size.width * 0.8, 50))
            button.setImage(UIImage(named: "button_start", inBundle: NSBundle(forClass:CCPGuideView.self), compatibleWithTraitCollection: nil), forState:.Normal)
            button.addTarget(self, action:"onFinishedIntroButtonPressed", forControlEvents: .TouchUpInside)
            return button
        }
    }()
    
    private lazy var cc_doneButtonYLocation : CGFloat = {
        return self.doneButtonYLocation?() ?? 0.9
    }()
    
    private lazy var pageControl : UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = self.cc_contentImages.count
        //pc.pageIndicatorTintColor = UIColor.blueColor()
        return pc
    }()
    
    private lazy var scrollView : UIScrollView = {
        let sv : UIScrollView = UIScrollView(frame:self.frame)
        sv.delegate = self
        sv.pagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blackColor()
    }
    deinit{
        print("GuideView 释放")
    }
}

// MARK: - 私有方法
extension CCPGuideView{
    /**
     检查版本
     
     - returns: return value description
     */
    private func checkVersionAndFirstLaunch() ->Bool{
        return isFristLaunch() && compareVersion()
    }
    private func isFristLaunch()->Bool{
        let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey(LocalFirstLaunchKey)
        if !firstLaunch{
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: LocalFirstLaunchKey)
            return false
        }
        return true
    }
    
    private func compareVersion() ->Bool{
        if let dic = NSBundle.mainBundle().infoDictionary{
            if let str : String = dic["CFBundleShortVersionString"] as? String {
                let localStr = NSUserDefaults.standardUserDefaults().stringForKey(LocalVersionKey)
                if str != localStr{
                    NSUserDefaults.standardUserDefaults().setValue(str, forKey: LocalVersionKey)
                    return false
                }
                return true
            }
            return true
        }
        
        return true
    }
    
    private func setUp(){
        //添加背景图
        if self.cc_backgroundImage != nil{
            let backgroundImageView = UIImageView(frame:self.frame)
            backgroundImageView.image = self.cc_backgroundImage
            self.addSubview(backgroundImageView)
        }
        //添加scrollView
        self.addSubview(self.scrollView)
        
        //添加contentView
        for var index = 0; index < self.cc_contentImages.count;++index{
            let originWidth = self.frame.size.width
            let originHeight = self.frame.size.height
            let view = UIView(frame:CGRectMake(originWidth * CGFloat(index), 0, originWidth, originHeight))
            
            //内容
            let imageview = UIImageView(frame:CGRectMake(0, 0, self.cc_contentSize.width, self.cc_contentSize.height))
            let point = CGPointMake(view.frame.size.width - self.frame.width / 2, self.frame.height / 2)
            imageview.center = point
            imageview.contentMode = .ScaleAspectFill
            imageview.image = self.cc_contentImages[index]
            view.addSubview(imageview)
            
            //标题
            if self.cc_titles.count > 0{
                let titleLabel = UILabel(frame:CGRectMake(0, self.frame.size.height * 0.05, self.frame.size.width * 0.8, 60))
                titleLabel.center = CGPointMake(self.center.x, self.frame.size.height * 0.1)
                titleLabel.text = self.cc_titles.count > index ? self.cc_titles[index] : nil
                titleLabel.font = UIFont(name: "HelveticaNeue", size: 30.0)
                titleLabel.textColor = UIColor.whiteColor()
                titleLabel.textAlignment = .Center
                titleLabel.numberOfLines = 0
                view.addSubview(titleLabel)
            }
            self.scrollView.addSubview(view)
        }
        
        //添加完成按钮
        self.addSubview(self.cc_doneButton)
        self.pageControl.frame = CGRectMake(0, CGRectGetMinY(self.cc_doneButton.frame) - 20, self.frame.width, 20)
        self.addSubview(self.pageControl)
        
        let scrollPoint = CGPointMake(0, 0)
        print(self.scrollView.contentSize)
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width * CGFloat(self.cc_contentImages.count), self.frame.size.height)
        self.scrollView.setContentOffset(scrollPoint, animated: true)
    }
    
}
// MARK: - 对外提供的方法
public extension CCPGuideView{
    
    public func showGuideView(){
        //检查版本号 和 是否首次启动
        if checkVersionAndFirstLaunch() {
            return
        }
        //显示
        self.setUp()
        w.addSubview(self)
    }
    
}

// MARK: - UIScrollViewDelegate
extension CCPGuideView:UIScrollViewDelegate{
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth = CGRectGetWidth(self.bounds)
        let pageFraction = self.scrollView.contentOffset.x / pageWidth
        self.pageControl.currentPage = Int(pageFraction)
        
    }
}

// MARK: - Button Action
extension CCPGuideView {
    func onFinishedIntroButtonPressed(){
        w.removeFromSuperview()
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.w.alpha = 0
            }) { (B:Bool) -> Void in
                for v in self.w.subviews{
                    v.removeFromSuperview()
                }
                self.w.removeFromSuperview()
        }
    }
}



