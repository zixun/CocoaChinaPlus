//
//  CCHTMLParser+OptionPage.swift
//  CocoaChinaPlus
//
//  Created by user on 15/10/31.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import Ji

extension CCHTMLParser {
    
    func parsePage(urlString:String,result:(model:[CCArticleModel],nextURL:String?)->Void) {
        weak var weakSelf = self
        
        CCRequest(.GET, urlString).responseJi { (ji, error) -> Void in
            
            let nextPageURL = weakSelf!.parseNextPageURL(ji!, currentURL: urlString)
            let article = weakSelf!.parseArticle(ji!)
            result(model: article, nextURL: nextPageURL)
        }
    }
    
    
    
    private func parseNextPageURL(ji:Ji,currentURL:String) -> String? {
        guard let nodes = ji.xPath("//div[@id='page']/a") else {
            return nil
        }
        
        var find = false
        var urlString:String?
        for node in nodes {
            //如果上一次循环已经发现当前页面，说明这一次循环就是下一页
            if find {
                
                //如果是末页，说明这是最后一页，没有下一页
                if node.content != "末页" {
                    urlString = node["href"]
                }
                break
            }
            
            //判断是否当前页
            if node["class"] == "thisclass" {
                find = true
            }
        }
        
        guard urlString != nil else {
            return nil
        }
        
        return self.optionPathOfURL(currentURL) + urlString!
    }
    
    
    private func optionPathOfURL(urlString:String) -> String {
        let str = urlString as NSString
        
        var count = 0
        for var i = 0; i < str.length; i++ {
            let temp = str.substringWithRange(NSMakeRange(i, 1))
            if temp == "/" {
                count++
                
                if count >= 4 {
                    return str.substringWithRange(NSMakeRange(0,i+1))
                }
                
            }
        }
        
        return urlString
    }
    
    
    private func parseArticle(ji: Ji) -> [CCArticleModel] {
        guard let nodes = ji.xPath("//div[@class='clearfix']") else {
            return [CCArticleModel]()
        }
        
        var models = [CCArticleModel]()
        
        for node in nodes {
            let model = CCArticleModel()
            
            var inner = node.xPath(".//a[@class='pic float-l']").first!
            
            let href = "http://www.cocoachina.com" + inner["href"]!
            let title = inner["title"]!
            
            inner = inner.xPath(".//img").first!
            let imageURL = inner["src"]!
            
            let addtion = node.xPath("//div[@class='clearfix zx_manage']/div[@class='float-l']/span")
            
            let postTime = addtion[0].content!
            let viewed = addtion[1].content!
            
            
            model.linkURL = href
            model.title = title
            model.postTime = postTime
            model.viewed = viewed
            model.imageURL = imageURL
            
            models.append(model)
        }
        return models
    }
    
}