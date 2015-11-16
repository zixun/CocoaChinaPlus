//
//  ZXColor.swift
//  CocoaChinaPlus
//
//  Created by user on 15/11/9.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import UIKit

public func ZXColor(rgb:Int) -> UIColor {
    return ZXColor(rgb, alpha: 1.0)
}

public func ZXColor(rgb:Int,alpha:CGFloat) ->UIColor {
    let red: CGFloat = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
    let green: CGFloat = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
    let blue: CGFloat = CGFloat((rgb & 0x0000FF)) / 255.0
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
}


public func ZXColor(startColor:UIColor,endColor:UIColor,fraction:CGFloat) -> UIColor {
    var startR: CGFloat = 0, startG: CGFloat = 0, startB: CGFloat = 0, startA: CGFloat = 0
    startColor.getRed(&startR, green: &startG, blue: &startB, alpha: &startA)
    
    var endR: CGFloat = 0, endG: CGFloat = 0, endB: CGFloat = 0, endA: CGFloat = 0
    endColor.getRed(&endR, green: &endG, blue: &endB, alpha: &endA)
    
    let resultA = startA + (endA - startA) * fraction
    let resultR = startR + (endR - startR) * fraction
    let resultG = startG + (endG - startG) * fraction
    let resultB = startB + (endB - startB) * fraction
    
    return UIColor(red: resultR, green: resultG, blue: resultB, alpha: resultA)
}