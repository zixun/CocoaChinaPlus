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

#import "FacialView.h"

@protocol DXFaceDelegate <FacialViewDelegate>

@required
- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete;
- (void)sendFace;

@end


@interface DXFaceView : UIView <FacialViewDelegate>

@property (nonatomic, assign) id<DXFaceDelegate> delegate;

- (BOOL)stringIsFace:(NSString *)string;

@end
