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

// MARK: ZXBaseViewController
class CCPHomeViewController: ZXBaseViewController {
    
    //RxSwift资源回收包
    fileprivate let disposeBag = DisposeBag()
    
    //视图
    lazy var pagingView: ZXPagingView = {
        let newPagingView = ZXPagingView(frame: self.view.bounds)
        newPagingView.pagingDelegate = self
        newPagingView.register(CCPHomePage.self, forCellWithReuseIdentifier: "cocoachina")
        newPagingView.isHidden = true
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init(navigatorURL URL: URL?, query: Dictionary<String, String>) {
        super.init(navigatorURL: URL, query: query)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置引导页面
        if !Defaults[.isGuideShowed] {
            let guideVC = ZXGuideViewController()
            guideVC.delegate = self
            self.presentViewController(guideVC)
        }
        
        //設置視圖
        self.view.addSubview(self.pagingView)
        self.navigationItem.titleView = self.optionView
        
        //設置搜尋按鈕
        self.navigationItem.rightBarButtonItemFixedSpace(item: self.searchButton())
        
        //擷取資料
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView("首页")

        self.pagingView.frame = self.view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.optionView.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView("首页")
        
        self.optionView.isHidden = true
    }
    
}

// MARK: Private Instance Method
extension CCPHomeViewController {
    
    //讀取資料內容
    fileprivate func loadData() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        CCHTMLModelHandler.sharedHandler.handleHomePage().bindNext { [weak self] (homeModel:CCPHomeModel) in
            if let sself = self {
                sself.tableArray = CCPTableArray(homeModel: homeModel)
                sself.pagingView.isHidden = false
                sself.pagingView.reloadData()
                sself.optionView.reloadData()
                MBProgressHUD.hideAllHUDs(for: sself.view, animated: true)
            }
        }.addDisposableTo(self.disposeBag)
    }
    
    //搜尋按鈕
    fileprivate func searchButton() -> UIBarButtonItem {
        let searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        searchButton.setImage(R.image.nav_search(), for: UIControlState())
        searchButton.rx.tap.bindNext { _ in
            ZXPresentURL("go/ccp/search?adpos=1")
        }.addDisposableTo(self.disposeBag)
        return UIBarButtonItem(customView: searchButton)
    }
    
}

// MARK: ZXOptionViewDelegate
extension CCPHomeViewController: ZXOptionViewDelegate {
    
    func numberOfOptionsInOptionView(_ optionView: ZXOptionView) -> Int {
        return self.tableArray?.tableViews.count ?? 0
    }
    
    func optionView(_ optionView: ZXOptionView, itemSizeAtIndex index: Int) -> CGSize {
        return CGSize(width: 80, height: ZXNavBarSize().height)
    }
    
    func optionView(_ optionView: ZXOptionView, cellConfiguration cellPoint: ZXOptionViewCellPoint) {
        guard let tableArray = self.tableArray else {
            return
        }
        let cell = cellPoint.pointee
        cell.textLabel.text = tableArray.homeModel.options[cell.index].title
    }
    
    func optionView(_ optionView: ZXOptionView, didSelectOptionAtIndex index: Int) {
        self.pagingView.currentIndex = index
        guard let tableArray = self.tableArray else {
            return
        }
        tableArray.reloadDataAtIndex(index)
    }
    
}

// MARK: ZXPagingViewDelegate
extension CCPHomeViewController: ZXPagingViewDelegate {
    
    func numberOfItemsInPagingView(_ pagingView: ZXPagingView) -> Int {
        return self.tableArray?.tableViews.count ?? 0
    }
    
    func pagingView(_ pagingView: ZXPagingView, cellForPageAtIndex index: Int) -> ZXPage {
        let cell = pagingView.dequeueReusablePageWithReuseIdentifier("cocoachina", forIndex: index) as! CCPHomePage
        
        if let tableArray = self.tableArray {
            cell.setDisplayView(tableArray.tableViews[index])
        }
        
        return cell
    }
    
    func pagingView(_ pagingView: ZXPagingView, movingFloatIndex floatIndex: Float) {
        if self.optionView.type == .tap {
            return
        }
        self.optionView.floatIndex = floatIndex
    }
    
    
    func pagingView(_ pagingView: ZXPagingView, didMoveToPageAtIndex index: Int) {
        self.tableArray?.reloadDataAtIndexIfEmpty(index)
        self.optionView.type = .slider
    }
    
    
    func pagingView(_ pagingView: ZXPagingView, willMoveToPageAtIndex index: Int) {
    }
    
}

// MARK: ZXGuideViewControllerDelegate
extension CCPHomeViewController: ZXGuideViewControllerDelegate {
    
    func numberOfPagesInGuideView(guideView: ZXGuideViewController) -> NSInteger {
        return 4
    }
    
    func guideView(guideView: ZXGuideViewController, cellForPageAtIndex index: NSInteger) -> UIView {
        let frame = guideView.view.frame
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.black
        return view;
    }
    
    func guideView(guideView: ZXGuideViewController, imageAtIndex index: NSInteger) -> UIImageView {
        
        var frame = CGRect.zero
        frame.size = CGSize(width: 473 / 2, height: 969 / 2);
        let center = self.guideView(guideView, pointCenterAtIndex: index)
        frame.origin = CGPoint(x: center.x - frame.size.width / 2, y: center.y - frame.size.height / 2);
        
        var image = R.image.guide_page_4()
        switch (index) {
        case 0:
            image = R.image.guide_page_1()
        case 1:
            image = R.image.guide_page_2()
        case 2:
            image = R.image.guide_page_3()
        case 3:
            image = R.image.guide_page_4()
        default:
            break
        }
        let imageView = UIImageView(image: image)
        imageView.frame = frame
        return imageView
    }
    
    func guideView(guideView: ZXGuideViewController, labelAtIndex index: NSInteger) -> UILabel {
        var str = ""
        switch (index) {
        case 0:
            str = "文章分类,方便阅读"
        case 1:
            str = "纯黑设计,极客最爱"
        case 2:
            str = "代码高亮,尊重技术"
        case 3:
            str = "一键分享,保留精彩"
        default:
            break;
        }
        
        var rect = self.guideView(guideView: guideView, imageAtIndex: index).frame
        rect.origin.x = 0
        rect.origin.y += rect.size.height
        rect.size.width = guideView.view.bounds.size.width
        rect.size.height = 40
        
        let label = UILabel(frame: rect)
        label.text = str
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        label.font = UIFont(name: "ChalkboardSE-Regular", size: 25)
        return label
    }
    
    func guideView(_ guideView: ZXGuideViewController, pointCenterAtIndex index: NSInteger) -> CGPoint {
        var point = CGPoint(x: ZXScreenWidth() / 2, y: ZXScreenHeight() / 2);
        switch (index) {
        case 0...3:
            point = CGPoint(x: point.x, y: point.y - 50);
        default:
            break;
        }
        return point
    }
    
    func didClickEnterButtonInGuideView(guideView: ZXGuideViewController) {
        Defaults[.isGuideShowed] = true
    }
    
}


