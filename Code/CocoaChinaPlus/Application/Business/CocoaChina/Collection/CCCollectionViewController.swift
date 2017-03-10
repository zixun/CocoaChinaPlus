//
//  CCCollectionViewController.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/9/21.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import MBProgressHUD

class CCCollectionViewController: CCArticleTableViewController {
    
    fileprivate var dataSource : [CCArticleModel] = []
    fileprivate var currentIndex : Int = 0
    fileprivate var type : CCArticleType!
    
    required init(navigatorURL URL: URL?, query: Dictionary<String, String>) {
        var query2 = query
        query2["forceHighlight"] = "1"
        super.init(navigatorURL: URL, query: query2)
        
        self.type = query["type"] == "0" ? .all : .collection
        self.dataSource = CCArticleService.queryArticles(type, index: currentIndex)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.append(self.dataSource)
        
        self.tableView.addPullToRefresh(actionHandler: {[unowned self] () -> Void in
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.currentIndex = 0
                self.dataSource = CCArticleService.queryArticles(self.type, index:self.currentIndex)
                self.tableView.reload(self.dataSource)
                self.tableView.pullToRefreshView.stopAnimating()
                self.tableView.infiniteScrollingView.stopAnimating()
                MBProgressHUD.hide(for: self.view, animated: true)
        })
        
        self.tableView.addInfiniteScrolling(actionHandler: {[unowned self] () -> Void in
                self.currentIndex += 1
                let model = CCArticleService.queryArticles(self.type, index: self.currentIndex)
                self.tableView.append(model)
                self.tableView.infiniteScrollingView.stopAnimating()
        })
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }

    
}
