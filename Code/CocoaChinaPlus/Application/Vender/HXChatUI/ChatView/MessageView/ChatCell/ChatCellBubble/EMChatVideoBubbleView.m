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

#import "EMChatVideoBubbleView.h"

NSString *const kRouterEventChatCellVideoTapEventName = @"kRouterEventChatCellVideoTapEventName";

@interface EMChatVideoBubbleView ()

@property (strong, nonatomic)UIButton *videoPlayButton;

@end

@implementation EMChatVideoBubbleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.videoPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backgroundImage = [UIImage imageNamed:@"chat_video_play.png"];
        [self.videoPlayButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [self.videoPlayButton addTarget:self action:@selector(playVideoAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.videoPlayButton];
    }
    return self;
}

//- (void)bubbleViewPressed:(id)sender
//{
//    //图片点击事件, 啥都不做
//}

- (void)playVideoAction:(id)sender{
    [self routerEventWithName:kRouterEventChatCellVideoTapEventName userInfo:@{KMESSAGEKEY:self.model}];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = 50.0f;
    CGFloat height = 50.0f;
    CGFloat x = self.frame.size.width/2 - width/2;
    CGFloat y = self.frame.size.height/2 - height/2;
    [self.videoPlayButton setFrame:CGRectMake(x, y, width, height)];
}

@end
