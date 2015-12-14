//
//  ZXTableViewController.swift
//  CocoaChinaPlus
//
//  Created by user on 15/11/5.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import RxSwift

class CCArticleTableViewController: ZXBaseViewController {

    //RxSwift资源回收包
    private let disposeBag = DisposeBag()
    
    //文章列表
    var tableView : CCArticleTableView!
    
    //加载下一页触发器
    let loadNextPageTrigger = PublishSubject<Void>()
    
    private let adBanner = CCADBanner()
    private var adView:UIView?
    
    /// 广告位位置枚举
    private var adPosition:CCADBannerPosition?
    
    
    
    required init(navigatorURL URL: NSURL, query: Dictionary<String, String>) {
        super.init(navigatorURL: URL, query: query)
        
        //tableview 配置
        let forceHighlight = query["forceHighlight"] == "1" ? true : false
        self.tableView = CCArticleTableView(forceHighlight: forceHighlight)
        
        //广告配置
        let adposStr = query["adpos"]
        if (adposStr != nil && Int(adposStr!) != nil) {
            self.adPosition = CCADBannerPosition(rawValue: Int(adposStr!)!)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.adPosition != nil) {
            self.adBanner
                .rx_adModelObservable(self.adPosition!)
                .subscribeNext({ [weak self] (adModel:CCADModel) -> Void in
                    guard let sself = self else {
                        return
                    }
                    
                    if sself.adView != nil {
                        sself.adView!.removeFromSuperview()
                        sself.adView = nil
                    }
                    sself.adView = adModel.adView
                    sself.view.addSubview(sself.adView!)
                    
                    
                    adModel
                        .displayObservable
                        .subscribeNext({[unowned sself] (success) -> Void in
                            if success {
                                sself.adView!.hidden = false
                                
                                var rect = sself.view.bounds
                                rect.size.height -= 50
                                sself.tableView.frame = rect
                            }else {
                                sself.adView!.hidden = true
                                sself.tableView.frame = sself.view.bounds
                            }
                            })
                        .addDisposableTo(sself.disposeBag)
                    })
                .addDisposableTo(self.disposeBag)
        }
        
        self.tableView.frame = self.view.bounds
        self.view.addSubview(self.tableView)
        
        //上拉加载
        self.tableView.addInfiniteScrollingWithActionHandler { [weak self] () -> Void in
            guard let sself = self else {
                return
            }
            sself.loadNextPageTrigger.on(.Next())
        }
        self.tableView.infiniteScrollingView.activityIndicatorViewStyle = .White
        
        //tableview行点击Observable
        self.tableView.selectSubject
            .subscribeNext {[weak self] (model) -> Void in
                guard let sself = self else {
                    return
                }
                
                sself.dismissViewControllerAnimated(true, completion: nil)
                var param = Dictionary<String,String>()
                param["identity"] = model.identity
                ZXOpenURL("go/ccp/article", param:param)
            }
            .addDisposableTo(disposeBag)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.adView?.anchorAndFillEdge(.Bottom, xPad: 0, yPad: 0, otherSize:48)
    }
    
}
