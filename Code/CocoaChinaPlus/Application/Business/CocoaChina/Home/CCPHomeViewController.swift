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

// MARK: ZXBaseViewController
class CCPHomeViewController: ZXBaseViewController {
    
    //RxSwift资源回收包
    private let disposeBag = DisposeBag()
    
    //视图
    lazy var pagingView: ZXPagingView = {
        let newPagingView = ZXPagingView(frame: self.view.bounds)
        newPagingView.pagingDelegate = self
        newPagingView.registerClass(CCPHomePage.self, forCellWithReuseIdentifier: "cocoachina")
        newPagingView.hidden = true
        return newPagingView
    }()
    
    lazy var optionView: ZXOptionView = {
        var rect = ZXNav().navigationBar.bounds
        rect.size.height -= 1.0
        
        let newOptionView = ZXOptionView(frame: rect)
        newOptionView.optionDelegate = self
        newOptionView.reloadData()
        return newOptionView
    }()
    
    //数据
    var tableArray: CCPTableArray?
    
    //初始方法
    required init(navigatorURL URL: NSURL, query: Dictionary<String, String>) {
        super.init(navigatorURL: URL, query: query)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 设置引导页面
        let ccp = CCPGuideView(frame:UIScreen.mainScreen().bounds)
        ccp.contentImages = {
            return [UIImage.Asset.GuidePage1.image,UIImage.Asset.GuidePage2.image,UIImage.Asset.GuidePage3.image,UIImage.Asset.GuidePage4.image]
        }
        ccp.titles = {
            return ["文章分类,方便阅读","纯黑设计,极客最爱","代码高亮,尊重技术","一键分享,保留精彩"]
        }
        ccp.contentSize = {
            return CGSizeMake(250, 250)
        }
        ccp.showGuideView()
        
        //設置視圖
        self.view.addSubview(self.pagingView)
        self.navigationItem.titleView = self.optionView
        
        //設置搜尋按鈕
        self.navigationItem.rightBarButtonItemFixedSpace(self.searchButton())
        
        //擷取資料
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
    
}

// MARK: Private Instance Method
extension CCPHomeViewController {
    
    //讀取資料內容
    private func loadData() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        CCHTMLModelHandler.sharedHandler
            .handleHomePage()
            .subscribeNext { [weak self] (homeModel: CCPHomeModel) -> Void in
                
                if let sself = self {
                    sself.tableArray = CCPTableArray(homeModel: homeModel)
                    sself.pagingView.hidden = false
                    sself.pagingView.reloadData()
                    sself.optionView.reloadData()
                    MBProgressHUD.hideAllHUDsForView(sself.view, animated: true)
                }
                
            }.addDisposableTo(disposeBag)
    }
    
    //搜尋按鈕
    private func searchButton() -> UIBarButtonItem {
        let searchButton = UIButton(frame: CGRectMake(0, 0, 44, 44))
        searchButton.setImage(UIImage.Asset.NavSearch.image, forState: .Normal)
        searchButton
            .rx_tap
            .subscribeNext { _ in
                ZXPresentURL("go/ccp/search?adpos=2")
            }
            .addDisposableTo(self.disposeBag)
        
        return UIBarButtonItem(customView: searchButton)
    }
    
}

// MARK: ZXOptionViewDelegate
extension CCPHomeViewController: ZXOptionViewDelegate {
    
    func numberOfOptionsInOptionView(optionView: ZXOptionView) -> Int {
        return self.tableArray?.tableViews.count ?? 0
    }
    
    func optionView(optionView: ZXOptionView, itemSizeAtIndex index: Int) -> CGSize {
        return CGSizeMake(80, ZXNavBarSize().height)
    }
    
    func optionView(optionView: ZXOptionView, cellConfiguration cellPoint: ZXOptionViewCellPoint) {
        guard let tableArray = self.tableArray else {
            return
        }
        let cell = cellPoint.memory
        cell.textLabel.text = tableArray.homeModel.options[cell.index].title
    }
    
    func optionView(optionView: ZXOptionView, didSelectOptionAtIndex index: Int) {
        self.pagingView.currentIndex = index
        guard let tableArray = self.tableArray else {
            return
        }
        tableArray.reloadDataAtIndex(index)
    }
    
}

// MARK: ZXPagingViewDelegate
extension CCPHomeViewController: ZXPagingViewDelegate {
    
    func numberOfItemsInPagingView(pagingView: ZXPagingView) -> Int {
        return self.tableArray?.tableViews.count ?? 0
    }
    
    func pagingView(pagingView: ZXPagingView, cellForPageAtIndex index: Int) -> ZXPage {
        let cell = pagingView.dequeueReusablePageWithReuseIdentifier("cocoachina", forIndex: index) as! CCPHomePage
        
        if let tableArray = self.tableArray {
            cell.setDisplayView(tableArray.tableViews[index])
        }
        
        return cell
    }
    
    func pagingView(pagingView: ZXPagingView, movingFloatIndex floatIndex: Float) {
        if self.optionView.type == .Tap {
            return
        }
        self.optionView.floatIndex = floatIndex
    }
    
    
    func pagingView(pagingView: ZXPagingView, didMoveToPageAtIndex index: Int) {
        self.tableArray?.reloadDataAtIndexIfEmpty(index)
        self.optionView.type = .Slider
    }
    
    
    func pagingView(pagingView: ZXPagingView, willMoveToPageAtIndex index: Int) {
    }
    
}



