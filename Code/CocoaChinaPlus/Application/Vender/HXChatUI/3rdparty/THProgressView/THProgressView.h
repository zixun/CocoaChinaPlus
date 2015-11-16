//
//  THProgressView.h
//
//  Created by Tiago Henriques on 10/22/13.
//  Copyright (c) 2013 Tiago Henriques. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THProgressView : UIView

@property (nonatomic, strong) UIColor* progressTintColor;
@property (nonatomic, strong) UIColor* borderTintColor;
@property (nonatomic) CGFloat progress;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end