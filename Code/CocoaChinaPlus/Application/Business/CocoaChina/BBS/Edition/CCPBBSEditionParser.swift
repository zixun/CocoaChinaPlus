//
//  CCPBBSEditionParser.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/8/17.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import Log4G

// MARK: CCPBBSEditionParser
class CCPBBSEditionParser {
    
    //解析版面文章
    class func parserEdition(_ urlString: String, result: @escaping (_ model: CCPBBSEditionModel) -> Void) {
        
        _ = CCRequest(.get, urlString).responseJi { (ji, error) -> Void in
            guard let list = ji?.xPath("//li[@class='articlelist clearfix']") else {
                return
            }
            
            var posts = [CCPBBSEditionPostModel]()
            for article in list {
                guard
                    let titleElement = article.xPath(".//p[@class='title']/a").first,
                    let authorElement = article.xPath(".//p[@class='bbs_author']").first,
                    let timeElement = article.xPath(".//p[@class='bbs_author']/span").first,
                    var author = authorElement.rawContent
                    else {
                        Log4G.warning("//获取H5元素失敗")
                        continue
                }
                
                //作者
                
                author = author.stringByDeletingScopeString("<span>", end: "</span>")
                author = author.stringByDeletingOccurrencesOfString("<span></span></p>")
                author = author.stringByDeletingOccurrencesOfString("<p class=\"bbs_author\">")
                
                //標題
                let title = titleElement.content ?? ""
                
                //時間
                let time = timeElement.content ?? ""
                
                //連結
                let link = titleElement["href"] ?? ""
                
                //建立 CCPBBSEditionPostModel
                let post = CCPBBSEditionPostModel(title: title, author: author, time: time, link: link)
                posts.append(post)
            }
            let edition = CCPBBSEditionModel()
            edition.posts = posts
            
            //第一页有pagenow,接下去的没有
            // FIXME: 這邊我覺得有點危險?
            if let pagenowNode = ji?.xPath("//div[@id='pagenow']")?.first {
                edition.pagenext = Int(pagenowNode.content!)! + 1
            } else {
                //没有就拿url中的+1
                let url = URL(string: urlString)!
                
                edition.pagenext = Int(url.paramValue(key: "page")!)! + 1
            }
            
            //回調
            result(edition)
        }
    }
    
}

// MARK: CCPBBSEditionModel
class CCPBBSEditionModel {
    
    var posts = [CCPBBSEditionPostModel]()
    var pagenext = 1
    
    convenience init(posts: [CCPBBSEditionPostModel], pagenext: Int) {
        self.init()
        self.posts = posts
        self.pagenext = pagenext
    }
    
    func append(_ model: CCPBBSEditionModel) -> Void {
        self.posts += model.posts
        self.pagenext = model.pagenext
    }
    
}

// MARK: CCPBBSEditionPostModel
//這邊保留 NSObject, 因為會影響 Array 的 indexOf Method 的使用
class CCPBBSEditionPostModel: NSObject {
    
    var title = ""
    var author = ""
    var time = ""
    var link = ""
    
    convenience init(title: String, author: String, time: String, link: String) {
        self.init()
        self.title = title
        self.author = author
        self.time = time
        self.link = "http://www.cocoachina.com/bbs/3g/" + link
    }
    
}
