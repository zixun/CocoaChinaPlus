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

#define ANIMATION_IMAGEVIEW_SIZE 25 // 小喇叭图片尺寸
#define ANIMATION_IMAGEVIEW_SPEED 1 // 小喇叭动画播放速度


#define ANIMATION_TIME_IMAGEVIEW_PADDING 5 // 时间与动画间距


#define ANIMATION_TIME_LABEL_WIDHT 30 // 时间宽度
#define ANIMATION_TIME_LABEL_HEIGHT 15 // 时间高度
#define ANIMATION_TIME_LABEL_FONT_SIZE 14 // 时间字体

// 发送
#define SENDER_ANIMATION_IMAGEVIEW_IMAGE_DEFAULT @"chat_sender_audio_playing_full" // 小喇叭默认图片
#define SENDER_ANIMATION_IMAGEVIEW_IMAGE_01 @"chat_sender_audio_playing_000" // 小喇叭动画第一帧
#define SENDER_ANIMATION_IMAGEVIEW_IMAGE_02 @"chat_sender_audio_playing_001" // 小喇叭动画第二帧
#define SENDER_ANIMATION_IMAGEVIEW_IMAGE_03 @"chat_sender_audio_playing_002" // 小喇叭动画第三帧
#define SENDER_ANIMATION_IMAGEVIEW_IMAGE_04 @"chat_sender_audio_playing_003" // 小喇叭动画第四帧

 
// 接收
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_DEFAULT @"chat_receiver_audio_playing_full" // 小喇叭默认图片
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_01 @"chat_receiver_audio_playing000" // 小喇叭动画第一帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_02 @"chat_receiver_audio_playing001" // 小喇叭动画第二帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_03 @"chat_receiver_audio_playing002" // 小喇叭动画第三帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_04 @"chat_receiver_audio_playing003" // 小喇叭动画第四帧

extern NSString *const kRouterEventAudioBubbleTapEventName;

@interface EMChatAudioBubbleView : EMChatBaseBubbleView
{
    UIImageView *_animationImageView; // 动画的ImageView
    UILabel *_timeLabel; // 时间label
}

-(void)startAudioAnimation;
-(void)stopAudioAnimation;

@end
