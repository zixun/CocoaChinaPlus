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
    
    private var dataSource : [CCArticleModel] = []
    private var currentIndex : Int = 0
    private var type : CCArticleType!
    
    required init(navigatorURL URL: NSURL, query: Dictionary<String, String>) {
        var query2 = query
        query2["forceHighlight"] = "1"
        super.init(navigatorURL: URL, query: query2)
        
        self.type = query["type"] == "0" ? .All : .Collection
        self.dataSource = CCArticleService.queryArticles(type, index: currentIndex)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.append(self.dataSource)
        
        self.tableView.addPullToRefreshWithActionHandler({[unowned self] () -> Void in
                MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                self.currentIndex = 0
                self.dataSource = CCArticleService.queryArticles(self.type, index:self.currentIndex)
                self.tableView.reload(self.dataSource)
                self.tableView.pullToRefreshView.stopAnimating()
                self.tableView.infiniteScrollingView.stopAnimating()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
        
        self.tableView.addInfiniteScrollingWithActionHandler({[unowned self] () -> Void in
                self.currentIndex++
                let model = CCArticleService.queryArticles(self.type, index: self.currentIndex)
                self.tableView.append(model)
                self.tableView.infiniteScrollingView.stopAnimating()
        })
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }

    
}