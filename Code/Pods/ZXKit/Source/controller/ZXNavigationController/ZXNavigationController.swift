//
//  ZXNavigationController.swift
//  CocoaChinaPlus
//
//  Created by 子循 on 15/8/4.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit

public class ZXNavigationController: UINavigationController {

    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        
        // 获取系统自带滑动手势的target对象
        let target = self.interactivePopGestureRecognizer!.delegate;
        
        // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
        let pan = UIPanGestureRecognizer(target: target, action: Selector("handleNavigationTransition:"))
        
        // 设置手势代理，拦截手势触发
        pan.delegate = self;
        
        // 给导航控制器的view添加全屏滑动手势
        self.view.addGestureRecognizer(pan);
        
        // 禁止使用系统自带的滑动手势
        self.interactivePopGestureRecognizer!.enabled = false;
        
        let image = UIImage.image(ZXColor(0x272626), size: CGSizeMake(ZXScreenWidth(), 0.5))
        let imageView = UIImageView(image: image)
        self.navigationBar.addSubview(imageView)
        var rect = self.navigationBar.bounds
        rect.origin.y = rect.origin.y + rect.size.height - 0.5
        rect.size.height = 0.5
        imageView.frame = rect
    }
    
    override public func pushViewController(viewController: UIViewController, animated: Bool) {
        
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: UIGestureRecognizerDelegate
extension ZXNavigationController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        let translation: CGPoint = (gestureRecognizer as! UIPanGestureRecognizer).translationInView(self.view.superview)
        if (translation.x < 0) {
            return false;//往右滑返回，往左滑不做操作
        }
        
        if (self.viewControllers.count <= 1) {
            return false
        }
        return true
    }
}

extension UIViewController {
    
    public func presentViewController(viewControllerToPresent: UIViewController) {
        self.presentViewController(viewControllerToPresent, animated: true, completion: nil)
    }
    
    public func presentViewController(viewControllerToPresent: UIViewController,withNavigation:Bool, animated flag: Bool, completion: (() -> Void)?) {
        if withNavigation == false {
            self.presentViewController(viewControllerToPresent, animated: flag, completion: completion)
        }else {
            let nav = ZXNavigationController(rootViewController: viewControllerToPresent)
            self.presentViewController(nav, animated: flag, completion: completion)
        }
    }
}

