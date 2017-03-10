//
//  CCHTMLModelHandler.swift
//  CocoaChinaPlus
//
//  Created by user on 15/10/30.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import RxSwift

class CCHTMLModelHandler: NSObject {
    
    static let sharedHandler:CCHTMLModelHandler = CCHTMLModelHandler()
    
    let disposeBag = DisposeBag()
    
    fileprivate let parser = CCHTMLParser()
}


// MARK: - 首页
extension CCHTMLModelHandler {
    
    func handleHomePage() ->PublishSubject<CCPHomeModel> {
        let psubject = PublishSubject<CCPHomeModel>()
        
        self.parser.parseHome { (model) -> Void in
            psubject.on(.next(model))
        }
        return psubject
    }
}

// MARK: - 搜索页
extension CCHTMLModelHandler {
    
    func handleSearchPage(_ query:String, loadNextPageTrigger trigger:PublishSubject<Void>) -> PublishSubject<[CCArticleModel]> {
        
        struct Holder {
            static var nextURL = ""
        }
        
        let psubject = PublishSubject<[CCArticleModel]>()
        trigger.bindNext {[weak self] _ in
            guard let sself = self else {
                return
            }
            
            guard Holder.nextURL.characters.count > 0  else {
                return psubject.on(.next([CCArticleModel]()))
            }
            
            sself.parser.parseSearch(Holder.nextURL, result: { (model, nextURL) -> Void in
                psubject.on(.next(model))
                Holder.nextURL = nextURL != nil ? nextURL! : ""
            })
        }.addDisposableTo(self.disposeBag)
        
        
        let url = self.searchFullURL(query)
        self.parser.parseSearch(url) { (model, nextURL) -> Void in
            psubject.on(.next(model))
            Holder.nextURL = nextURL != nil ? nextURL! : ""
        }
        
        return psubject
    }
    
    /**
     根据关键字生成搜索页面URL
     
     - parameter keyword: 关键字
     
     - returns: 搜索页面URL
     */
    fileprivate func searchFullURL(_ keyword:String) -> String {
        return "http://www.cocoachina.com/cms/plus/search.php?kwtype=0&keyword=\(self.URLEscape(keyword))&searchtype=titlekeyword"
    }
    
    fileprivate func URLEscape(_ pathSegment: String) -> String {
        var seg = pathSegment
        seg = seg.trimmingCharacters(in: CharacterSet.whitespaces)
        seg = seg.replacingOccurrences(of: " ", with: "+")
        return seg
    }
    
}

// MARK: - 类目页
extension CCHTMLModelHandler {
    
    func handleOptionPage(_ urlString:String, loadNextPageTrigger trigger:PublishSubject<Void>) ->PublishSubject<[CCArticleModel]> {
        struct Holder {
            static var nextURLDic = [String : String]()
        }
        
        let psubject = PublishSubject<[CCArticleModel]>()
        
        trigger.bindNext { [weak self] _  in
            guard let sself = self else {
                return
            }
            
            guard let url = Holder.nextURLDic[urlString] else {
                return psubject.on(.next([CCArticleModel]()))
            }
            
            guard url.characters.count > 0  else {
                return psubject.on(.next([CCArticleModel]()))
            }
            
            sself.parser.parsePage(Holder.nextURLDic[urlString]!, result: { (model, nextURL) -> Void in
                psubject.on(.next(model))
                Holder.nextURLDic[urlString] = nextURL != nil ? nextURL! : ""
            })
        }.addDisposableTo(self.disposeBag)
        
        self.parser.parsePage(urlString) { (model, nextURL) -> Void in
            psubject.on(.next(model))
            Holder.nextURLDic[urlString] = nextURL != nil ? nextURL! : ""
        }
        
        return psubject
    }
}

