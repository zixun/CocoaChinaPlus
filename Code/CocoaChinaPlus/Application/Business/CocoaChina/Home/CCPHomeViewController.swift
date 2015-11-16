//
//  CCPHomeViewController.swift
//  CocoaChinaPlus
//
//  Created by 子循 on 15/7/15.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import MBProgressHUD
import RxSwift
import ZXKit

class CCPHomeViewController: ZXBaseViewController {
    
    //RxSwift资源回收包
    private let disposeBag = DisposeBag()
    
    //视图
    var pagingView: ZXPagingView!
    var optionView: ZXOptionView!
    
    //数据
    var tableArray:CCPTableArray?
    
    required init(navigatorURL URL: NSURL, query: Dictionary<String, String>) {
        super.init(navigatorURL: URL, query: query)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置引导页面
        if Defaults[.isGuideShowed] == false {
            let guideVC = ZXGuideViewController()
            guideVC.delegate = self
            self.presentViewController(guideVC, animated: true, completion: nil)
        }
        
        
        pagingView = ZXPagingView(frame: self.view.bounds)
        pagingView.pagingDelegate = self
        pagingView.registerClass(CCPHomePage.self, forCellWithReuseIdentifier: "cocoachina")
        pagingView.hidden = true
        self.view.addSubview(pagingView)
        
        var rect = ZXNav().navigationBar.bounds
        rect.size.height = rect.size.height - 1.0
        
        optionView = ZXOptionView(frame: rect)
        optionView.optionDelegate = self
        optionView.reloadData()
        self.navigationItem.titleView = optionView
        
        
        
        let searchButton = UIButton(frame: CGRectMake(0, 0, 44, 44))
        searchButton.setImage(UIImage.Asset.NavSearch.image, forState: .Normal)
        searchButton
            .rx_tap
            .subscribeNext { _ in
                ZXPresentURL("go/ccp/search?adpos=2")
            }
            .addDisposableTo(self.disposeBag)
        
        let shareItem = UIBarButtonItem(customView: searchButton)
        self.navigationItem.rightBarButtonItemFixedSpace(shareItem)
        
        self.loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView("首页")

        self.pagingView.frame = self.view.bounds
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.optionView.hidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView("首页")
        
        self.optionView.hidden = true
    }
    
    private func loadData() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        CCHTMLModelHandler.sharedHandler
            .handleHomePage()
            .subscribeNext { [weak self] (homeModel:CCPHomeModel) -> Void in
            
                if let sself = self {
                    
                    sself.tableArray = CCPTableArray(homeModel: homeModel)
                    sself.pagingView.hidden = false
                    sself.pagingView.reloadData()
                    sself.optionView.reloadData()
                    MBProgressHUD.hideAllHUDsForView(sself.view, animated: true)
                }
                
        }.addDisposableTo(disposeBag)
    }
}


extension CCPHomeViewController: ZXOptionViewDelegate {
    
    func numberOfOptionsInOptionView(optionView:ZXOptionView) -> Int {
        if self.tableArray == nil {
            return 0
        }
        return self.tableArray!.tableViews.count
    }
    
    func optionView(optionView:ZXOptionView, itemSizeAtIndex index:Int) ->CGSize {
        return CGSizeMake(80, ZXNavBarSize().height)
    }
    
    func optionView(optionView:ZXOptionView, cellConfiguration cellPoint:ZXOptionViewCellPoint) {
        let cell:ZXOptionViewCell = cellPoint.memory
        cell.textLabel.text = self.tableArray!.homeModel.options[cell.index].title
    }
    
    func optionView(optionView:ZXOptionView, didSelectOptionAtIndex index:Int) {
        self.pagingView.currentIndex = index
        guard self.tableArray != nil else {
            return
        }
        
        self.tableArray!.reloadDataAtIndex(index)
    }
    
}

extension CCPHomeViewController: ZXPagingViewDelegate {
    
    func numberOfItemsInPagingView(pagingView:ZXPagingView) -> Int {
        if self.tableArray == nil {
            return 0
        }
        return self.tableArray!.tableViews.count
    }
    
    func pagingView(pagingView:ZXPagingView, cellForPageAtIndex index: Int) -> ZXPage {
        let cell = pagingView.dequeueReusablePageWithReuseIdentifier("cocoachina", forIndex: index) as! CCPHomePage
        
        if (self.tableArray != nil) {
            cell.setDisplayVieww(self.tableArray!.tableViews[index])
        }
        
        return cell
    }
    
    func pagingView(pagingView:ZXPagingView,movingFloatIndex floatIndex:Float) {
        if self.optionView.type == .Tap {
            return
        }
        self.optionView.floatIndex = floatIndex
    }
    
    
    func pagingView(pagingView:ZXPagingView, didMoveToPageAtIndex index:Int) {
        self.tableArray?.reloadDataAtIndexIfEmpty(index)
        self.optionView.type = .Slider
    }
    
    
    func pagingView(pagingView: ZXPagingView, willMoveToPageAtIndex index: Int) {
       
    }
}

extension CCPHomeViewController: ZXGuideViewControllerDelegate {
    
    
    func numberOfPagesInGuideView(guideView:ZXGuideViewController) -> NSInteger {
        return 4
    }
    
    func guideView(guideView:ZXGuideViewController, cellForPageAtIndex index:NSInteger) ->UIView {
        let frame:CGRect = guideView.view.frame
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.blackColor()
        return view;
    }
    
    func guideView(guideView:ZXGuideViewController, imageAtIndex index:NSInteger) ->UIImageView {
        
        var frame = CGRectZero
        
        frame.size = CGSizeMake(473 / 2, 969 / 2);
        let center: CGPoint = self.guideView(guideView, pointCenterAtIndex: index)
        frame.origin = CGPointMake(center.x - frame.size.width / 2, center.y - frame.size.height / 2);
        
        var image:UIImage
        switch (index) {
        case 0:
            image = UIImage.Asset.GuidePage1.image
            break;
        case 1:
            image = UIImage.Asset.GuidePage2.image
            break;
        case 2:
            image = UIImage.Asset.GuidePage3.image
            break;
        case 3:
            image = UIImage.Asset.GuidePage4.image
            break;
        default:
            image = UIImage.Asset.GuidePage4.image
            break;
        }
        let imageView = UIImageView(image: image)
        imageView.frame=frame
        return imageView
    }
    
    func guideView(guideView:ZXGuideViewController, labelAtIndex index:NSInteger) ->UILabel {
        var str : String = ""
        switch (index) {
        case 0:
            str="文章分类,方便阅读"
            break;
        case 1:
            str="纯黑设计,极客最爱"
            break;
        case 2:
            str="代码高亮,尊重技术"
            break;
        case 3:
            str="一键分享,保留精彩"
            break;
        default:
            break;
        }
        
        var rect = self.guideView(guideView, imageAtIndex: index).frame
        rect.origin.y += rect.size.height
        rect.size.height = 40
        rect.origin.x = 0
        rect.size.width = guideView.view.bounds.size.width
        
        let label = UILabel(frame: rect)
        label.text=str
        label.textAlignment = NSTextAlignment.Center
        label.textColor=UIColor.whiteColor()
        label.font=UIFont(name: "ChalkboardSE-Regular", size: 25)
        return label
    }
    
    func guideView(guideView:ZXGuideViewController, pointCenterAtIndex index:NSInteger) ->CGPoint {
        var point = CGPointMake(ZXScreenWidth() / 2, ZXScreenHight() / 2);
        switch (index) {
        case 0:
            point = CGPointMake(point.x, point.y - 50);
            break;
        case 1:
            point = CGPointMake(point.x, point.y - 50);
            break;
        case 2:
            point = CGPointMake(point.x, point.y - 50);
            break;
        case 3:
            point = CGPointMake(point.x, point.y - 50);
            break;
        default:
            break;
        }
        return point
    }
    
    func didClickEnterButtonInGuideView(guideView:ZXGuideViewController) {
        Defaults[.isGuideShowed] = true
    }
}


