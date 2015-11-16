//
//  SwiftFucker.m
//  CocoaChinaPlus
//
//  Created by zixun on 15/9/30.
//  Copyright © 2015年 zixun. All rights reserved.
//

#import "SwiftFucker.h"
#import "EaseMob.h"

@implementation SwiftFucker

+ (void)fuckSetIsAutoLoginEnabled {
    //Swift中chatManager是readonly，会让他的属性IsAutoLoginEnabled也变成readonly
    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
}

@end
