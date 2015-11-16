//
//  UIImage+Drawing.swift
//  CocoaChinaPlus
//
//  Created by user on 15/11/9.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import UIKit

// MARK: - draw image
public extension UIImage {
    
    /**
     用CGContextRef代码生成一个UIImage图片对象
     
     - parameter size:         图片大小
     - parameter drawingBlock: 绘画block
     
     - returns: 生成的图片
     */
    public class func image(size: CGSize, drawingBlock:(CGContextRef,CGRect) -> Void) -> UIImage? {
        guard CGSizeEqualToSize(size, CGSizeZero) == false else {
            return nil
        }
        
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextClearRect(context, rect)
        
        drawingBlock(context,rect)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
    
    /**
     生成一个单一颜色的UIImage图片对象
     
     - parameter color:  颜色
     - parameter size:  大小
     
     - returns: 生成的图片对象
     */
    public class func image(color:UIColor, size:CGSize) ->UIImage? {
        
        guard CGSizeEqualToSize(size, CGSizeZero) == false else {
            return nil
        }
        
        let target = UIImage.image(size, drawingBlock: { (context, rect) -> Void in
            CGContextSetFillColorWithColor(context, color.CGColor);
            CGContextFillRect(context, rect);
        })
        return target
    }
}