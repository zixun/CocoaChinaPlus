//
//  CCADBanner.h
//  CCAD
//
//  Created by user on 16/1/14.
//  Copyright © 2016年 陈奕龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CCADBannerViewType) {
    CCADBannerViewTypeArticle,
    CCADBannerViewTypeSearch,
    CCADBannerViewTypeChat,
};

typedef void (^CCADBannerViewCompletionBlock)(BOOL successed,NSDictionary* errorInfo);

@interface CCADBanner : UIView

- (instancetype)initWithType:(CCADBannerViewType)type
          rootViewController:(UIViewController *)rootViewController
             completionBlock:(CCADBannerViewCompletionBlock)completionBlock;

@end
