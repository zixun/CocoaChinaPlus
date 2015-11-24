//
//  CCPTableArray.swift
//  CocoaChinaPlus
//
//  Created by 子循 on 15/7/20.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import SVPullToRefresh
import MBProgressHUD
import RxSwift
import ZXKit
import Neon

class CCPTableArray: NSObject {

    //RxSwift资源回收包
    private let disposeBag = DisposeBag()
    
    //加载下一页触发器
    private var loadNextPageTriggers = [PublishSubject<Void>]()
    
    private(set) var tableViews = [CCArticleTableView]()
    
    //private
    var homeModel: CCPHomeModel
    
    init(homeModel: CCPHomeModel) {
        self.homeModel = homeModel
        super.init()
        
        let count = self.homeModel.options.count
        for i in 0..<count {
            let loadNextPageTrigger = PublishSubject<Void>()
            self.loadNextPageTriggers.append(loadNextPageTrigger)
            
            //table
            let table = CCArticleTableView()
            table.tag = i
            
            table.addPullToRefreshWithActionHandler({ () -> Void in
                self.reloadDataOfTable(table)
            })
            
            tableViews.append(table)
            
            if i == 0 {
                table.append(homeModel.page)
                
                let view = ZXCircleView()
                view.circleDelegate = self
                view.anchorToEdge(Edge.Top, padding: 0, width: ZXScreenWidth(), height: ZXScreenWidth() * 0.8)
                view.reloadData()
                self.tableViews[0].tableHeaderView = view
            } else {
                table.addInfiniteScrollingWithActionHandler({ [weak self] () -> Void in
                    guard let sself = self else {
                        return
                    }
                    
                    sself.loadNextPageTriggers[table.tag].on(.Next())
                })
                table.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
            }
            
            table.selectSubject.subscribeNext({ (article) -> Void in
                ZXOpenURL("go/ccp/article?identity=\(article.identity)")
            }).addDisposableTo(disposeBag)
        }
    }
    
    func reloadDataAtIndexIfEmpty(index: Int) {
        guard self.tableViews[index].isEmpty() == true else {
            return
        }
        self.reloadDataOfTable(self.tableViews[index])
    }
    
    func reloadDataAtIndex(index: Int) {
        self.reloadDataOfTable(self.tableViews[index])
    }
    
    private func reloadDataOfTable(table: CCArticleTableView) {
        MBProgressHUD.showHUDAddedTo(table, animated: true)
        let index = table.tag
        let urlString = self.urlStringAtIndex(index)
        
        if index > 0 {
            table.clean()
            
            CCHTMLModelHandler.sharedHandler.handleOptionPage(urlString, loadNextPageTrigger: self.loadNextPageTriggers[table.tag]).subscribeNext({ (models) -> Void in
                table.pullToRefreshView.stopAnimating()
                table.append(models)
                table.infiniteScrollingView.stopAnimating()
                MBProgressHUD.hideHUDForView(table, animated: true)
                
            }).addDisposableTo(disposeBag)
            
        } else {
            
            CCHTMLModelHandler.sharedHandler.handleHomePage().subscribeNext({ (homeModel) -> Void in
                table.reload(homeModel.page)
                
                table.pullToRefreshView.stopAnimating()
                MBProgressHUD.hideHUDForView(table, animated: true)
                
                let view = table.tableHeaderView as! ZXCircleView
                view.reloadData()
            }).addDisposableTo(disposeBag)
            
        }
    }
    
}

//MARK: Private API
extension CCPTableArray {
    /**
    指定下标的dataSource数据获取URL
    
    :param: index dataSource的下标
    
    :returns: 数据获取的URL
    */
    private func urlStringAtIndex(index: Int) -> String {
        return self.homeModel.options[index].urlString
    }
    
}

//MARK: 
extension CCPTableArray: ZXCircleViewDelegate {
    
    func numberOfItemsInCircleView(circleView: ZXCircleView) -> Int {
        return self.homeModel.banners.count
    }
    
    func circleView(circleView: ZXCircleView, configureCell cellRef: ZXCircleViewCellRef) {
        let cell = cellRef.memory
        
        func modelFrom(cell: ZXCircleViewCell) -> CCArticleModel? {
            guard let cellIndex = cell.index else {
                return nil
            }
            return self.homeModel.banners[cellIndex]
        }
        
        guard
            let model = modelFrom(cell),
            let urlString = model.imageURL,
            let url = NSURL(string: urlString)
            else {
                print("資料缺失")
                return
        }
        
        cell.imageView.kf_setImageWithURL(url)
        cell.titleLabel.text = model.title
    }
    
    func circleView(circleView: ZXCircleView, didSelectedCellAtIndex index: Int) {
        
        //model
        let model = self.homeModel.banners[index]
        if !CCArticleService.isArticleExsitById(model.identity) {
            CCArticleService.insertArtice(model)
        }
        
        //url navigation
        var param = Dictionary<String, String>()
        param["identity"] = model.identity
        ZXOpenURL("go/ccp/article", param: param)
    }
    
}