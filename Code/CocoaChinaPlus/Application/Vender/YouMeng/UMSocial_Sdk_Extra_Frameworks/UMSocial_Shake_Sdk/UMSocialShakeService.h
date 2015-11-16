//
//  UMSocialShakeService.h
//  SocialSDK
//
//  Created by yeahugo on 13-11-15.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocial.h"

/**
 响应摇一摇动作后的配置类型，是否显示截屏，是否显示分享编辑框，是否发出音效等等。
 
 */
typedef enum {
    UMSocialShakeConfigNone                    = 0,               //摇一摇之后不显示任何效果和发出声音
    UMSocialShakeConfigShowScreenShot          = 1 << 0,          //显示截屏图片
    UMSocialShakeConfigShowShareEdit           = 1 << 1,          //显示分享编辑框
    UMSocialShakeConfigSound                   = 1 << 2,          //发出摇一摇音效
    UMSocialShakeConfigSupportOrientation      = 1 << 3,          //设置是否支持旋转屏幕，默认支持
    UMSocialShakeConfigDefault                 = UMSocialShakeConfigShowScreenShot | UMSocialShakeConfigShowShareEdit
    | UMSocialShakeConfigSound | UMSocialShakeConfigSupportOrientation                                   //默认显示截屏图片、显示分享编辑框，支持旋转，发出摇一摇音效
} UMSocialShakeConfig;

@class UMSocialData;

@class UMSocialResponseEntity;

@class UMSocialScreenShoter;

/**
 响应摇一摇动作的代理方法
 
 */
@protocol UMSocialShakeDelegate <NSObject>

@optional

/**
 摇一摇分享完成后获得的回调方法
 
 @param response 分享结果对象
 
 */
-(void)didFinishShareInShakeView:(UMSocialResponseEntity *)response;

/**
 点击分享按钮或者关闭页面的按钮后的回调方法
 
 */
-(void)didCloseShakeView;

/**
 摇一摇后得到的回调方法
 
 @return 摇一摇分享的配置，可以设置是否弹出编辑框，是否显示截图，是否有声音，见'UMSocialShakeConfig'的定义
 */
-(UMSocialShakeConfig)didShakeWithShakeConfig;

@end

/**
 设置监听摇一摇动作的类
 
 */
@interface UMSocialShakeService : NSObject <UIAccelerometerDelegate>

/**
 设置响应摇一摇事件，并且弹出分享页面
 
 @param snsTypes 要分享的平台类型名，例如@[UMShareToSina,UMShareToTencent,UMShareToWechatSession]
 @param shareText 分享内嵌文字
 @param screenShoter 摇一摇分享用到的截屏对象
 @param controller  出现分享界面所在的ViewController
 @param delegate 实现摇一摇后，或者分享完成后的回调对象，如果不处理这些事件，可以设置为nil
 */
+(void)setShakeToShareWithTypes:(NSArray *)snsTypes
                      shareText:(NSString *)shareText
                   screenShoter:(UMSocialScreenShoter *)screenShoter
               inViewController:(UIViewController *)controller
                       delegate:(id<UMSocialShakeDelegate>)delegate;

/**
 设置响应摇一摇事件的阈值,数值越低越灵敏
 
 @param threshold 摇一摇的阈值,默认是0.8
 
 */
+(void)setShakeThreshold:(float)threshold;

/*
 解除注册响应摇一摇事件
 
 */
+(void)unShakeToSns;


/**
 设置你的播放器或者游戏，获取到的截图图片
 
 */
+(void)setScreenShotImage:(UIImage *)shareImage;
@end




