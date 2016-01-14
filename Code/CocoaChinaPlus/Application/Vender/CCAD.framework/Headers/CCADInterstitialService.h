//
//  CCADInterstitialManager.h
//  CCAD
//
//  Created by user on 16/1/13.
//  Copyright © 2016年 陈奕龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CCADInterstitialService : NSObject

+(void)startServiceWithRootViewController:(UIViewController *)rootViewController;

+ (void)showIfReady;
@end
