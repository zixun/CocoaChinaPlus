//
//  UIImage+.swift
//  CocoaChinaPlus
//
//  Created by zixun on 17/1/25.
//  Copyright © 2017年 zixun. All rights reserved.
//

import Foundation

// MARK: - circle image
public extension UIImage {
    
    public func circleImage() -> UIImage{
        UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()!
        //圆的边框宽度为2，颜色为红色
        
        context.setLineWidth(0);
        
        context.setStrokeColor(UIColor.clear.cgColor);
        
        let rect = CGRect(x:0, y:0, width:self.size.width, height:self.size.height)
        
        context.addEllipse(in: rect);
        
        context.clip();
        
        //在圆区域内画出image原图
        self.draw(in: rect)
        
        context.addEllipse(in: rect);
        
        context.strokePath();
        
        //生成新的image
        let newimg = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newimg
    }
}
