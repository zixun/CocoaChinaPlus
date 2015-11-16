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
#import "EMMessage.h"
#import "ChatDemoUIDefine.h"

@interface ChatSendHelper : NSObject

/**
 *  发送文字消息（包括系统表情）
 *
 *  @param str               发送的文字
 *  @param username          接收方
 *  @param isChatGroup       是否是群聊
 *  @param requireEncryption 是否加密
 *  @param ext               扩展信息
 *  @return 封装的消息体
 */
+(EMMessage *)sendTextMessageWithString:(NSString *)str
                             toUsername:(NSString *)username
                            isChatGroup:(BOOL)isChatGroup
                      requireEncryption:(BOOL)requireEncryption
                                    ext:(NSDictionary *)ext;

/**
 *  发送文字消息（包括系统表情）
 *
 *  @param str               发送的文字
 *  @param username          接收方
 *  @param messageType       消息类型
 *  @param requireEncryption 是否加密
 *  @param ext               扩展信息
 *  @return 封装的消息体
 */
+(EMMessage *)sendTextMessageWithString:(NSString *)str
                             toUsername:(NSString *)username
                            messageType:(EMMessageType)type
                      requireEncryption:(BOOL)requireEncryption
                                    ext:(NSDictionary *)ext;

/**
 *  发送图片消息
 *
 *  @param image             发送的图片
 *  @param username          接收方
 *  @param isChatGroup       是否是群聊
 *  @param requireEncryption 是否加密
 *  @param ext               扩展信息
 *  @return 封装的消息体
 */
+(EMMessage *)sendImageMessageWithImage:(UIImage *)image
                             toUsername:(NSString *)username
                            isChatGroup:(BOOL)isChatGroup
                      requireEncryption:(BOOL)requireEncryption
                                    ext:(NSDictionary *)ext;

/**
 *  发送图片消息
 *
 *  @param image             发送的图片
 *  @param username          接收方
 *  @param messageType       消息类型
 *  @param requireEncryption 是否加密
 *  @param ext               扩展信息
 *  @return 封装的消息体
 */
+(EMMessage *)sendImageMessageWithImage:(UIImage *)image
                             toUsername:(NSString *)username
                            messageType:(EMMessageType)type
                      requireEncryption:(BOOL)requireEncryption
                                    ext:(NSDictionary *)ext;

/**
 *  发送音频消息
 *
 *  @param voice             发送的音频
 *  @param username          接收方
 *  @param isChatGroup       是否是群聊
 *  @param requireEncryption 是否加密
 *  @param ext               扩展信息
 *  @return 封装的消息体
 */
+(EMMessage *)sendVoice:(EMChatVoice *)voice
             toUsername:(NSString *)username
            isChatGroup:(BOOL)isChatGroup
      requireEncryption:(BOOL)requireEncryption
                    ext:(NSDictionary *)ext;

/**
 *  发送音频消息
 *
 *  @param voice             发送的音频
 *  @param username          接收方
 *  @param messageType       消息类型
 *  @param requireEncryption 是否加密
 *  @param ext               扩展信息
 *  @return 封装的消息体
 */
+(EMMessage *)sendVoice:(EMChatVoice *)voice
             toUsername:(NSString *)username
            messageType:(EMMessageType)type
      requireEncryption:(BOOL)requireEncryption
                    ext:(NSDictionary *)ext;
/**
 *  发送位置消息（定位）
 *
 *  @param latitude          经度
 *  @param longitude         纬度
 *  @param address           位置描述信息
 *  @param username          接收方
 *  @param isChatGroup       是否是群聊
 *  @param requireEncryption 是否加密
 *  @param ext               扩展信息
 *  @return 封装的消息体
 */
+(EMMessage *)sendLocationLatitude:(double)latitude
                         longitude:(double)longitude
                           address:(NSString *)address
                        toUsername:(NSString *)username
                        isChatGroup:(BOOL)isChatGroup
                 requireEncryption:(BOOL)requireEncryption
                               ext:(NSDictionary *)ext;

/**
 *  发送位置消息（定位）
 *
 *  @param latitude          经度
 *  @param longitude         纬度
 *  @param address           位置描述信息
 *  @param username          接收方
 *  @param messageType       消息类型
 *  @param requireEncryption 是否加密
 *  @param ext               扩展信息
 *  @return 封装的消息体
 */
+(EMMessage *)sendLocationLatitude:(double)latitude
                         longitude:(double)longitude
                           address:(NSString *)address
                        toUsername:(NSString *)username
                       messageType:(EMMessageType)type
                 requireEncryption:(BOOL)requireEncryption
                               ext:(NSDictionary *)ext;

/**
 *  发送视频文件消息
 *
 *  @param video             发送的视频
 *  @param username          接收方
 *  @param isChatGroup       是否是群聊
 *  @param requireEncryption 是否加密
 *  @param ext               扩展信息
 *  @return 封装的消息体
 */
+(EMMessage *)sendVideo:(EMChatVideo *)video
             toUsername:(NSString *)username
            isChatGroup:(BOOL)isChatGroup
      requireEncryption:(BOOL)requireEncryption
                    ext:(NSDictionary *)ext;

/**
 *  发送视频文件消息
 *
 *  @param video             发送的视频
 *  @param username          接收方
 *  @param messageType       消息类型
 *  @param requireEncryption 是否加密
 *  @param ext               扩展信息
 *  @return 封装的消息体
 */
+(EMMessage *)sendVideo:(EMChatVideo *)video
             toUsername:(NSString *)username
            messageType:(EMMessageType)type
      requireEncryption:(BOOL)requireEncryption
                    ext:(NSDictionary *)ext;
@end
