/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>
#import "EMChatBaseBubbleView.h"

#define LOCATION_IMAGE @"chat_location_preview" // 显示的地图图片
#define LOCATION_IMAGEVIEW_SIZE 95 // 地图图片大小

#define LOCATION_ADDRESS_LABEL_FONT_SIZE  10 // 位置字体大小
#define LOCATION_ADDRESS_LABEL_PADDING 2 // 位置文字与外边间距
#define LOCATION_ADDRESS_LABEL_BGVIEW_HEIGHT 25 // 位置文字显示外框的高度

extern NSString *const kRouterEventLocationBubbleTapEventName;

@interface EMChatLocationBubbleView : EMChatBaseBubbleView

@end
