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

#import <Foundation/Foundation.h>

#import "MWPhotoBrowser.h"
#import "MessageModel.h"

typedef void (^FinishBlock)(BOOL success);
typedef void (^PlayBlock)(BOOL playing, MessageModel *messageModel);

@class EMChatFireBubbleView;
@interface MessageReadManager : NSObject<MWPhotoBrowserDelegate>

@property (strong, nonatomic) MWPhotoBrowser *photoBrowser;
@property (strong, nonatomic) FinishBlock finishBlock;

@property (strong, nonatomic) MessageModel *audioMessageModel;

+ (id)defaultManager;

//default
- (void)showBrowserWithImages:(NSArray *)imageArray;

/**
 *  准备播放语音文件
 *
 *  @param messageModel     要播放的语音文件
 *  @param updateCompletion 需要更新model所在的Cell
 *
 *  @return 若返回NO，则不需要调用播放方法
 *
 */
- (BOOL)prepareMessageAudioModel:(MessageModel *)messageModel
              updateViewCompletion:(void (^)(MessageModel *prevAudioModel, MessageModel *currentAudioModel))updateCompletion;

- (MessageModel *)stopMessageAudioModel;

@end
