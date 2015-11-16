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

#import "ChatSendHelper.h"
#import "ConvertToCommonEmoticonsHelper.h"

#import "EMCommandMessageBody.h"

@interface ChatImageOptions : NSObject<IChatImageOptions>

@property (assign, nonatomic) CGFloat compressionQuality;

@end

@implementation ChatImageOptions

@end

@implementation ChatSendHelper

+(EMMessage *)sendTextMessageWithString:(NSString *)str
                             toUsername:(NSString *)username
                            isChatGroup:(BOOL)isChatGroup
                      requireEncryption:(BOOL)requireEncryption
                                    ext:(NSDictionary *)ext
{
    EMMessageType type = isChatGroup ? eMessageTypeGroupChat : eMessageTypeChat;
    return [self sendTextMessageWithString:str
                                toUsername:username
                               messageType:type
                         requireEncryption:requireEncryption
                                       ext:ext];
}

+(EMMessage *)sendTextMessageWithString:(NSString *)str
                             toUsername:(NSString *)username
                            messageType:(EMMessageType)type
                      requireEncryption:(BOOL)requireEncryption
                                    ext:(NSDictionary *)ext
{
    // 表情映射。
    NSString *willSendText = [ConvertToCommonEmoticonsHelper convertToCommonEmoticons:str];
    EMChatText *text = [[EMChatText alloc] initWithText:willSendText];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:text];
    return [self sendMessage:username
                 messageBody:body
                 messageType:type
           requireEncryption:requireEncryption
                         ext:ext];
}

+(EMMessage *)sendImageMessageWithImage:(UIImage *)image
                             toUsername:(NSString *)username
                            isChatGroup:(BOOL)isChatGroup
                      requireEncryption:(BOOL)requireEncryption
                                    ext:(NSDictionary *)ext
{
    EMMessageType type = isChatGroup ? eMessageTypeGroupChat : eMessageTypeChat;
    return [self sendImageMessageWithImage:image
                                toUsername:username
                               messageType:type
                         requireEncryption:requireEncryption
                                       ext:ext];
}

+(EMMessage *)sendImageMessageWithImage:(UIImage *)image
                             toUsername:(NSString *)username
                            messageType:(EMMessageType)type
                      requireEncryption:(BOOL)requireEncryption
                                    ext:(NSDictionary *)ext
{
    EMChatImage *chatImage = [[EMChatImage alloc] initWithUIImage:image displayName:@"image"];
    id <IChatImageOptions> options = [[ChatImageOptions alloc] init];
    [options setCompressionQuality:0.6];
    [chatImage setImageOptions:options];
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithImage:chatImage
                                                          thumbnailImage:nil];
    return [self sendMessage:username
                 messageBody:body
                 messageType:type
           requireEncryption:requireEncryption
                         ext:ext];
}

+(EMMessage *)sendVoice:(EMChatVoice *)voice
             toUsername:(NSString *)username
            isChatGroup:(BOOL)isChatGroup
      requireEncryption:(BOOL)requireEncryption
                    ext:(NSDictionary *)ext
{
    EMMessageType type = isChatGroup ? eMessageTypeGroupChat : eMessageTypeChat;
    return [self sendVoice:voice
                toUsername:username
               messageType:type
         requireEncryption:requireEncryption
                       ext:ext];
}

+(EMMessage *)sendVoice:(EMChatVoice *)voice
             toUsername:(NSString *)username
            messageType:(EMMessageType)type
      requireEncryption:(BOOL)requireEncryption
                    ext:(NSDictionary *)ext
{
    EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithChatObject:voice];
    return [self sendMessage:username
                 messageBody:body
                 messageType:type
           requireEncryption:requireEncryption
                         ext:ext];
}

+(EMMessage *)sendVideo:(EMChatVideo *)video
             toUsername:(NSString *)username
            isChatGroup:(BOOL)isChatGroup
      requireEncryption:(BOOL)requireEncryption
                    ext:(NSDictionary *)ext
{
    EMMessageType type = isChatGroup ? eMessageTypeGroupChat : eMessageTypeChat;
    return [self sendVideo:video
                toUsername:username
               messageType:type
         requireEncryption:requireEncryption
                       ext:ext];
}

+(EMMessage *)sendVideo:(EMChatVideo *)video
             toUsername:(NSString *)username
            messageType:(EMMessageType)type
      requireEncryption:(BOOL)requireEncryption
                    ext:(NSDictionary *)ext
{
    EMVideoMessageBody *body = [[EMVideoMessageBody alloc] initWithChatObject:video];
    return [self sendMessage:username
                 messageBody:body
                 messageType:type
           requireEncryption:requireEncryption
                         ext:ext];
}

+(EMMessage *)sendLocationLatitude:(double)latitude
                         longitude:(double)longitude
                           address:(NSString *)address
                        toUsername:(NSString *)username
                       isChatGroup:(BOOL)isChatGroup
                 requireEncryption:(BOOL)requireEncryption
                               ext:(NSDictionary *)ext
{
    EMMessageType type = isChatGroup ? eMessageTypeGroupChat : eMessageTypeChat;
    return [self sendLocationLatitude:latitude
                            longitude:longitude
                              address:address
                           toUsername:username
                          messageType:type
                    requireEncryption:requireEncryption
                                  ext:ext];
}

+(EMMessage *)sendLocationLatitude:(double)latitude
                         longitude:(double)longitude
                           address:(NSString *)address
                        toUsername:(NSString *)username
                       messageType:(EMMessageType)type
                 requireEncryption:(BOOL)requireEncryption
                               ext:(NSDictionary *)ext
{
    EMChatLocation *chatLocation = [[EMChatLocation alloc] initWithLatitude:latitude
                                                                  longitude:longitude
                                                                    address:address];
    EMLocationMessageBody *body = [[EMLocationMessageBody alloc] initWithChatObject:chatLocation];
    return [self sendMessage:username
                 messageBody:body
                 messageType:type
           requireEncryption:requireEncryption
                         ext:ext];
}

// 发送消息
+(EMMessage *)sendMessage:(NSString *)username
              messageBody:(id<IEMMessageBody>)body
              messageType:(EMMessageType)type
        requireEncryption:(BOOL)requireEncryption
                      ext:(NSDictionary *)ext
{
    EMMessage *retureMsg = [[EMMessage alloc] initWithReceiver:username
                                                        bodies:@[body]];
    retureMsg.requireEncryption = requireEncryption;
    retureMsg.messageType = type;
    retureMsg.ext = ext;
    EMMessage *message = [[EaseMob sharedInstance].chatManager
                          asyncSendMessage:retureMsg
                          progress:nil];
    
    return message;
}

@end
