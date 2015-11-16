//
//  ZXPath.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/9/27.
//  Copyright © 2015年 zixun. All rights reserved.
//
import Foundation

//ZXPath用来简化对app目录的检索，
//改写自Facebook大神jverkoey的Objective-C项目Nimbus 中的NIPaths
//(https://github.com/jverkoey/nimbus/blob/master/src/core/src/NIPaths.m)
//因语法关系有略微不同 并且增加了ApplicationSupportDirectory的检索

/**
* Create a path with the given bundle and the relative path appended.
*
* @param bundle        The bundle to append relativePath to. If nil, [NSBundle mainBundle]
*                           will be used.
* @param relativePath  The relative path to append to the bundle's path.
*
* @returns The bundle path concatenated with the given relative path.
*/
public func ZXPathForBundleResource(bundle: NSBundle?, relativePath: String) -> String {
    let resourcePath = (bundle == nil ? NSBundle.mainBundle() : bundle)!.resourcePath! as NSString
    return resourcePath.stringByAppendingPathComponent(relativePath)
}

/**
* Create a path with the documents directory and the relative path appended.
*
* @returns The documents path concatenated with the given relative path.
*/
public func ZXPathForDocumentsResource(relativePath: String) -> String {
    return (documentsPath as NSString).stringByAppendingPathComponent(relativePath)
}

/**
* Create a path with the Library directory and the relative path appended.
*
* @returns The Library path concatenated with the given relative path.
*/
public func ZXPathForLibraryResource(relativePath: String) -> String {
     return (libraryPath as NSString).stringByAppendingPathComponent(relativePath)
}

/**
* Create a path with the caches directory and the relative path appended.
*
* @returns The caches path concatenated with the given relative path.
*/
public func ZXPathForCachesResource(relativePath: String) -> String {
    return (cachesPath as NSString).stringByAppendingPathComponent(relativePath)
}


/**
* Create a path with the ApplicationSupport directory and the relative path appended.
*
* @returns The caches path concatenated with the given relative path.
*/
public func ZXPathForApplicationSupportResource(relativePath: String) -> String {
    return (applicationSupportPath as NSString).stringByAppendingPathComponent(relativePath)
}

 /// 将document目录作为常量保存起来，提高访问性能
private let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
    .UserDomainMask,
    true).first!

 /// 将library目录作为常量保存起来，提高访问性能
private let libraryPath = NSSearchPathForDirectoriesInDomains(.LibraryDirectory,
    .UserDomainMask,
    true).first!

 /// 将caches目录作为常量保存起来，提高访问性能
private let cachesPath = NSSearchPathForDirectoriesInDomains(.CachesDirectory,
    .UserDomainMask,
    true).first!

 /// 将applicationSupport目录作为常量保存起来，提高访问性能
private let applicationSupportPath = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory,
    .UserDomainMask,
    true).first!
