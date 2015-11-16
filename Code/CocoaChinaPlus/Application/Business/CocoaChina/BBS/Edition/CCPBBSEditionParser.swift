//
//  CCPBBSEditionParser.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/8/17.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import ZXKit

class CCPBBSEditionParser: NSObject {
    
    static let sharedParser: CCPBBSEditionParser = {
        return CCPBBSEditionParser()
    }()
    
    func parserEdition(urlString:String,result:(model: CCPBBSEditionModel) -> Void) {
        
        CCRequest(.GET, urlString).responseJi { (ji, error) -> Void in
            guard let list = ji?.xPath("//li[@class='articlelist clearfix']") else {
                return
            }
            
            var posts = [CCPBBSEditionPostModel]()
            for var i = 0; i < list.count; i++ {
                let article = list[i]
                
                //获取H5元素
                let titleElement = article.xPath(".//p[@class='title']/a").first
                let authorElement = article.xPath(".//p[@class='bbs_author']").first
                let timeElement = article.xPath(".//p[@class='bbs_author']/span").first
                
                
                var author : NSString = (authorElement?.rawContent!)! as NSString
                author = author.stringByDeletingScopeString("<span>", end: "</span>")
                author = author.stringByDeletingOccurrencesOfString("<span></span></p>")
                author = author.stringByDeletingOccurrencesOfString("<p class=\"bbs_author\">")
                //获取元素值
                let title = judge(titleElement?.content)
//                let author = judge(authorElement?.children[0].content)
                let time = judge(timeElement?.content)
                let link = judge(titleElement?["href"])
                
                
                let post = CCPBBSEditionPostModel(title: title, author: author as String, time: time, link: link)
                posts.append(post)
            }
            let edition = CCPBBSEditionModel()
            edition.posts = posts
            
            //第一页有pagenow,接下去的没有
            if let pagenowNode = ji?.xPath("//div[@id='pagenow']")?.first {
                edition.pagenext = Int(pagenowNode.content!)! + 1
            }else {
                //没有就拿url中的+1
                let url = NSURL(string: urlString)!
                edition.pagenext = Int(url.paramValue("page")!)! + 1
            }
            
            result(model:edition)
        }
    }
}

class CCPBBSEditionModel {
    var posts:[CCPBBSEditionPostModel] = []
    var pagenext = 1
    
    convenience init(posts:[CCPBBSEditionPostModel], pagenext:Int) {
        self.init()
        self.posts = posts
        self.pagenext = pagenext
    }
    
    func append(model:CCPBBSEditionModel) -> Void {
        self.posts += model.posts
        self.pagenext = model.pagenext
    }
}

class CCPBBSEditionPostModel: NSObject {
    var title: String = ""
    var author: String = ""
    var time: String = ""
    var link: String = ""
    
    convenience init(title:String, author:String, time:String, link:String) {
        self.init()
        self.title = title
        self.author = author
        self.time = time
        self.link = "http://www.cocoachina.com/bbs/3g/" + link
    }
    
    
}