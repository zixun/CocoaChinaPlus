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

#import "MessageModel.h"
#import "EMChatBaseBubbleView.h"

#import "UIResponder+Router.h"

#define HEAD_SIZE 40 // 头像大小
#define HEAD_PADDING 5 // 头像到cell的内间距和头像到bubble的间距
#define CELLPADDING 8 // Cell之间间距

#define NAME_LABEL_WIDTH 180 // nameLabel最大宽度
#define NAME_LABEL_HEIGHT 20 // nameLabel 高度
#define NAME_LABEL_PADDING 5 // nameLabel间距
#define NAME_LABEL_FONT_SIZE 14 // 字体

extern NSString *const kRouterEventChatHeadImageTapEventName;

@interface EMChatViewBaseCell : UITableViewCell
{
    UIImageView *_headImageView;
    UILabel *_nameLabel;
    EMChatBaseBubbleView *_bubbleView;
    
    CGFloat _nameLabelHeight;
    MessageModel *_messageModel;
}

@property (nonatomic, strong) MessageModel *messageModel;

@property (nonatomic, strong) UIImageView *headImageView;       //头像
@property (nonatomic, strong) UILabel *nameLabel;               //姓名（暂时不支持显示）
@property (nonatomic, strong) EMChatBaseBubbleView *bubbleView;   //内容区域

- (id)initWithMessageModel:(MessageModel *)model reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setupSubviewsForMessageModel:(MessageModel *)model;

+ (NSString *)cellIdentifierForMessageModel:(MessageModel *)model;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(MessageModel *)model;

@end
