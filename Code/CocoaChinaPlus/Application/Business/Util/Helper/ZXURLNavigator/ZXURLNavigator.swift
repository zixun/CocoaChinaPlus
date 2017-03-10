//
//  ZXNavigator.swift
//  CocoaChinaPlus
//
//  Created by 子循 on 15/6/22.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import UIKit

private let URLMaps: Dictionary<String,ZXBaseViewController.Type> =
   ["go/ccp/article":CCPArticleViewController.self,
    "go/ccp/edition":CCPBBSEditionViewController.self,
    "go/ccp/collection":CCCollectionViewController.self,
    "go/ccp/search":CCSearchViewController.self]

func ZXNavBarSize() ->CGSize {
    return ZXNav().navigationBar.bounds.size
}

//如果URL要带参数，请严格检查参数是否正确
func ZXOpenURL(_ url:String) {
    let param =  ZXURLNavigator.sharedNavigator.paramFromURL(url)
    ZXOpenURL(url, param: param)
}

func ZXOpenURL(_ url:String, param:Dictionary<String,String>) {
    ZXURLNavigator.sharedNavigator.openURL(url, param: param)
}

func ZXPresentURL(_ url:String) {
    let param =  ZXURLNavigator.sharedNavigator.paramFromURL(url)
    ZXURLNavigator.sharedNavigator.presentURL(url, param: param)
    
}

func ZXPresentURL(_ url:String, param:Dictionary<String,String>) {
    
}

func ZXPop() {
   ZXNav().popViewController(animated: true)
}

func ZXNav() -> ZXNavigationController {
    let tabBarController = (UIApplication.shared.delegate as! AppDelegate).tabbarController
    let selet = tabBarController.selectedViewController
    return selet as! ZXNavigationController
}

private class ZXURLNavigator: NSObject {
    
    static let sharedNavigator:ZXURLNavigator = {
        return ZXURLNavigator()
    }()
    
    
    fileprivate func openURL(_ url:String, param:Dictionary<String,String>) {
        guard let clazz = self.controllerFromURL(url) else {
            return
        }
        
        let vc = clazz.init(navigatorURL:  URL(string: url)!, query: param)
        ZXNav().pushViewController(vc, animated: true)
    }
    
    fileprivate func presentURL(_ url:String,param:Dictionary<String,String>) {
        guard let clazz = self.controllerFromURL(url) else {
            return
        }
        let vc = clazz.init(navigatorURL:  URL(string: url)!, query: param)
        ZXNav().presentViewController(vc, withNavigation: true, animated: true, completion: nil)
    }
    
    fileprivate func controllerFromURL(_ url:String) -> ZXBaseViewController.Type? {
        let path = url.components(separatedBy: "?").first!
        let type: ZXBaseViewController.Type? = URLMaps[path]
        return type
    }
    
    fileprivate func paramFromURL(_ url: String) -> [String:String] {
        let components:[String] = url.components(separatedBy: "?")
        guard components.count >= 2 else {
            return [String:String]()
        }
        
        let paramString:String = components[1]
        var dic:[String:String] = [String:String]()
        
        let paramComponents:[String] = paramString.components(separatedBy: "&")
        
        for param: String in paramComponents {
            let entity:[String] = param.components(separatedBy: "=")
            dic[entity[0]] = entity[1]
        }
        
        return dic
    }
}
