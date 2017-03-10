//
//  CCHTMLParser+SearchPage.swift
//  CocoaChinaPlus
//
//  Created by user on 15/10/30.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import Ji

//搜索主Path
let CCXPath_Search_MainNode = "//div[@class='leftSide float-l']/div"
let CCXPath_Search_LinkNode = "div[@class='clearfix newstitle']/a"
let CCXPath_Search_DivNode = "div[@class='clearfix zx_manage']/div[@class='float-l']"
let CCXPath_Search_PostTimeNode = "span[@class='post-time']"
let CCXPath_Search_ViewedNode = "span"

extension CCHTMLParser {
    
    func parseSearch(_ url:String,result: @escaping (_ model:[CCArticleModel],_ nextURL:String?) ->Void) {
        
        CCRequest(.get, url, cheat: false).responseJi {[weak self] (ji, error) -> Void in
            
            guard let sself = self else {
                return
            }
            
            
            guard error == nil && ji != nil else {
                return
            }
            
            let items = sself.parserSearchItems(ji!)
            let nextURL_ = sself.parserNextURL(ji!)
            
            result(items, nextURL_)
        }
    }
    
    fileprivate func parserSearchItems(_ ji:Ji) -> [CCArticleModel] {
        
        guard let divNodes = ji.xPath(CCXPath_Search_MainNode) else {
            return  [CCArticleModel]()
        }
        
        let contentNode = divNodes[1]
        
        let listNode = contentNode.xPath("ul/li")
        
        var models = [CCArticleModel]()
        for node in listNode {
            let model = CCArticleModel()
            
            //设置链接和title
            if let aNode = node.xPath(CCXPath_Search_LinkNode).first {
                model.linkURL = "http://www.cocoachina.com" + ((aNode["href"] != nil) ? aNode["href"]! : "")
                model.title = aNode.content
            }
            
            if let aNode = node.xPath(CCXPath_Search_DivNode).first {
                //设置发表时间
                if let postTimeNode = aNode.xPath(CCXPath_Search_PostTimeNode).first {
                    model.postTime = postTimeNode.content
                }
                //设置阅读次数
                if let viewedNode = aNode.xPath(CCXPath_Search_ViewedNode).last {
                    model.viewed = viewedNode.content
                }
            }
            models.append(model)
        }
        return models
    }
    
    fileprivate func parserNextURL(_ ji:Ji) -> String? {
        guard let contentNodes = ji.xPath("//td/a") else {
            return nil
        }
        
        for contentNode in contentNodes {
            if contentNode.content == "下一页" {
                var urlStr = contentNode["href"]
                urlStr = "http://www.cocoachina.com" + ((urlStr != nil ) ? urlStr! : "")
                return urlStr
            }
        }
        
        return nil
        
    }
    
}
