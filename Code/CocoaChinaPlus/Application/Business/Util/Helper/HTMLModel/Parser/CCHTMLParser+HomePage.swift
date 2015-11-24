//
//  CCHTMLParser+HomePage.swift
//  CocoaChinaPlus
//
//  Created by user on 15/10/30.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import Ji
import Kingfisher

extension CCHTMLParser {
    
    func parseHome(result: (model:CCPHomeModel) ->Void) {
        let baseURL:String = "http://www.cocoachina.com"
        
        CCRequest(.GET, baseURL).responseJi { [weak self] (ji, error) -> Void in
            //TODO: ERROR处理
            
            if let sself = self {
                var options = sself.parseOptions(ji!)
                let first = CCPOptionModel(href: "", title: "最新")
                options.insert(first, atIndex: options.startIndex)
                
                //banner轮播信息
                let banners = sself.parseBanner(ji!)
                //最新文章
                let page =  sself.parseNewest(ji!)
                
                let model = CCPHomeModel(options: options, banners: banners, page: page)
                result(model: model)
            }
        }
    }
    
    private func parseNewest(ji: Ji) -> [CCArticleModel] {
        var models = [CCArticleModel]()
        
        guard let nodes = ji.xPath("//div[@class='forum-c']/ul/li/a") else {
            return models
        }
        
        
        for node in nodes {
            let href = node["href"]!
            
            var inner = node.xPath("p[@class='img']/img").first!
            let imageURL = inner["src"]!
            
            inner = node.xPath("div/h4").first!
            let title = inner.content!
            
            inner = node.xPath("div/span").first!
            let postTime = inner.content!
            
            let model = CCArticleModel()
            model.linkURL = href
            model.title = title
            model.postTime = postTime
            model.imageURL = imageURL
            
            models.append(model)
        }
        return models
    }
    
    private func parseBanner(ji:Ji) -> [CCArticleModel] {
        guard let nodes = ji.xPath("//ul[@class='role-main']/li/a") else {
            return [CCArticleModel]()
        }
        
        var banners = [CCArticleModel]()
        
        for node in nodes {
            let linkURL = node["href"]!
            let imageURL = node.firstChildWithName("img")!["src"]!
            let title = node.firstChildWithName("img")!["title"]!
            
            let model = CCArticleModel()
            model.linkURL = linkURL
            model.title = title
            model.imageURL = imageURL
            
            banners.append(model)
        }
        return banners
    }
    
    private func parseOptions(ji:Ji) ->[CCPOptionModel] {
        guard let nodes = ji.xPath("//div[@class='m-board']/div/h3/a") else {
            return [CCPOptionModel]()
        }
        
        var options = [CCPOptionModel]()
        for node:JiNode in nodes {
            let model = CCPOptionModel(href:node["href"]! , title: node.content!)
            
            if model.title.lowercaseString.containsString("android") == false {
                //因为app store 审核不能有android的任何信息
                options.append(model)
            }
        }
        
        return options
    }
}