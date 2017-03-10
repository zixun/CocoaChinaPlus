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
import Neon
import Kingfisher
import Log4G

class CCPTableArray: NSObject {

    //RxSwift资源回收包
    fileprivate let disposeBag = DisposeBag()
    
    //加载下一页触发器
    fileprivate var loadNextPageTriggers = [PublishSubject<Void>]()
    
    fileprivate(set) var tableViews = [CCArticleTableView]()
    
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
            
            table.addPullToRefresh(actionHandler: { () -> Void in
                self.reloadDataOfTable(table)
            })
            
            tableViews.append(table)
            
            if i == 0 {
                table.append(homeModel.page)
                
                let view = ZXCircleView()
                view.circleDelegate = self
                view.anchorToEdge(Edge.top, padding: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * 0.8)
                view.reloadData()
                self.tableViews[0].tableHeaderView = view
            } else {
                table.addInfiniteScrolling(actionHandler: { [weak self] () -> Void in
                    guard let sself = self else {
                        return
                    }
                    
                    sself.loadNextPageTriggers[table.tag].on(.next())
                })
                table.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
            }
            
            table.selectSubject.bindNext({ (article:CCArticleModel) in
                ZXOpenURL("go/ccp/article?identity=\(article.identity!)")
            }).addDisposableTo(self.disposeBag)
        }
    }
    
    func reloadDataAtIndexIfEmpty(_ index: Int) {
        guard self.tableViews[index].isEmpty() == true else {
            return
        }
        self.reloadDataOfTable(self.tableViews[index])
    }
    
    func reloadDataAtIndex(_ index: Int) {
        self.reloadDataOfTable(self.tableViews[index])
    }
    
    fileprivate func reloadDataOfTable(_ table: CCArticleTableView) {
        MBProgressHUD.showAdded(to: table, animated: true)
        let index = table.tag
        let urlString = self.urlStringAtIndex(index)
        
        if index > 0 {
            table.clean()
            
            CCHTMLModelHandler.sharedHandler.handleOptionPage(urlString, loadNextPageTrigger: self.loadNextPageTriggers[table.tag]).bindNext({ (models:Array<CCArticleModel>) in
                table.pullToRefreshView.stopAnimating()
                table.append(models)
                table.infiniteScrollingView.stopAnimating()
                MBProgressHUD.hide(for: table, animated: true)
            }).addDisposableTo(self.disposeBag)
        } else {
            
            CCHTMLModelHandler.sharedHandler.handleHomePage().bindNext({ (homeModel:CCPHomeModel) in
                table.reload(homeModel.page)
                
                table.pullToRefreshView.stopAnimating()
                MBProgressHUD.hide(for: table, animated: true)
                
                let view = table.tableHeaderView as! ZXCircleView
                view.reloadData()
            }).addDisposableTo(self.disposeBag)
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
    fileprivate func urlStringAtIndex(_ index: Int) -> String {
        return self.homeModel.options[index].urlString
    }
    
}

//MARK: 
extension CCPTableArray: ZXCircleViewDelegate {
    
    func numberOfItemsInCircleView(circleView: ZXCircleView) -> Int {
        return self.homeModel.banners.count
    }
    
    func circleView(circleView:ZXCircleView, configureCell cellRef:ZXCircleViewCellRef) {
        let cell = cellRef.pointee
        
        func modelFrom(_ cell: ZXCircleViewCell) -> CCArticleModel? {
            guard let cellIndex = cell.index else {
                return nil
            }
            return self.homeModel.banners[cellIndex]
        }
        
        guard
            let model = modelFrom(cell),
            let urlString = model.imageURL,
            let url = URL(string: urlString)
            else {
                Log4G.error("資料缺失")
                return
        }
        
        cell.imageView.kf.setImage(with: url)
        cell.titleLabel.text = model.title
    }
    
    func circleView(circleView:ZXCircleView, didSelectedCellAtIndex index:Int) {
        
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
