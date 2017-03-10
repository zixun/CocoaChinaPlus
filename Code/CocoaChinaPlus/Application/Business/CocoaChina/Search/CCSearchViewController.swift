//
//  CCAboutViewController.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/10/3.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class CCSearchViewController: CCArticleTableViewController {
    //搜索条
    fileprivate var searchfiled:UISearchBar!
    //取消按钮
    fileprivate var cancelButton:UIButton!
    //RxSwift资源回收包
    fileprivate let disposeBag = DisposeBag()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(navigatorURL URL: URL?, query: Dictionary<String, String>) {
         super.init(navigatorURL: URL, query: query)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge()
        
        self.cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        self.cancelButton.setImage(R.image.nav_cancel(), for: UIControlState())
        self.navigationItem.rightBarButtonItemFixedSpace(item: UIBarButtonItem(customView: cancelButton))
        
        self.searchfiled = UISearchBar()
        self.searchfiled.placeholder = "关键字必需大于2个字符哦"
        self.navigationItem.titleView = self.searchfiled
        
        
        self.subscribes()
    }
    
    fileprivate func subscribes() {
        
        //取消按钮点击Observable
        self.cancelButton.rx.tap.bindNext { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }.addDisposableTo(self.disposeBag)
        
        //tableView滚动偏移量Observable
        self.tableView.rx.contentOffset.bindNext {[unowned self] (p:CGPoint) in
            if self.searchfiled.isFirstResponder {
                _ = self.searchfiled.resignFirstResponder()
            }
        }.addDisposableTo(self.disposeBag)
        
        //搜索框搜索按钮点击Observable
        self.searchfiled.rx.searchButtonClicked.map({ [unowned self] _ -> PublishSubject<[CCArticleModel]> in
            self.tableView.clean()
            return CCHTMLModelHandler.sharedHandler.handleSearchPage(self.searchfiled.text!, loadNextPageTrigger: self.loadNextPageTrigger)
        }).switchLatest().bindNext({ [unowned self] (models:Array<CCArticleModel>) in
            self.tableView.append(models)
            self.tableView.infiniteScrollingView.stopAnimating()
        }).addDisposableTo(self.disposeBag)
    }
}


