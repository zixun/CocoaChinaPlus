//
//  CCArticleTableView.swift
//  CocoaChinaPlus
//
//  Created by user on 15/10/28.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MBProgressHUD
import AppBaseKit


class CCArticleTableView: UITableView,UITableViewDelegate, UITableViewDataSource {

    /// cell是否一直高亮
    var forceHighlight:Bool = false
    
    //Cell选中Observable
    var selectSubject = PublishSubject<CCArticleModel>()
    
    //RxSwift资源回收包
    fileprivate let disposeBag = DisposeBag()
    //文章数组
    fileprivate var articles = [CCArticleModel]()

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.backgroundColor = UIColor(hex: 0x000000, alpha: 0.8)
        self.separatorStyle  = .none
        
        self.delegate = self
        self.dataSource = self
    }
    
    convenience init(forceHighlight:Bool) {
        self.init(frame:CGRect.zero,style:.plain)
        self.forceHighlight = forceHighlight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     添加一组文章model到tableview，并reload
     
     - parameter models: 一组文章model
     */
    func append(_ models:[CCArticleModel]) {
        if models.count == 0 {
            if self.articles.count == 0 {
                MBProgressHUD.showText("没找到...")
            }else {
                MBProgressHUD.showText("没有了...")
            }
        }
        
        for m in models {
            self.articles.append(m)
        }
        
        self.reloadData()
    }
    
    /**
     清空数据
     */
    func clean() {
        self.articles.removeAll()
    }
    
    /**
     重新加载
     */
    func reload(_ models:[CCArticleModel]) {
        self.clean()
        self.append(models)
    }
    
    /**
     tableview是否没有数据
     */
    func isEmpty() -> Bool {
        return self.articles.count == 0 ? true : false
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CCArticleTableViewCell") as? CCArticleTableViewCell
        if cell == nil {
            cell = CCArticleTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "CCArticleTableViewCell")
        }
        
        cell?.configure(self.articles[indexPath.row], forceHighlight: self.forceHighlight)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.deselectRow(at: indexPath, animated: true)
        
        let article = self.articles[indexPath.row]
        
        if !CCArticleService.isArticleExsitById(article.identity) {
            _ = CCArticleService.insertArtice(article)
        }
        
        let cell = self.cellForRow(at: indexPath) as! CCArticleTableViewCell
        cell.highlightCell(false)
        
        self.selectSubject.on(.next(article))
    }
}
