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

@interface ConvertToCommonEmoticonsHelper : NSObject
+ (NSString *)convertToCommonEmoticons:(NSString *)text;
+ (NSString *)convertToSystemEmoticons:(NSString *)text;
@end
