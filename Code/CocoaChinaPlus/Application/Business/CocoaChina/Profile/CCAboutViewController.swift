//
//  CCAboutViewController.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/10/3.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit

class CCAboutViewController: ZXBaseViewController {

    private var scrollView:UIScrollView!
    
    required init(navigatorURL URL: NSURL, query: Dictionary<String, String>) {
        super.init(navigatorURL: URL, query: query)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.scrollView = UIScrollView(frame: self.view.bounds)
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
        
        let imageview = UIImageView(image: UIImage.Asset.About.image)
        imageview.frame = self.scrollView.bounds
        imageview.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        self.scrollView.addSubview(imageview)
    }
}

extension CCAboutViewController : UIScrollViewDelegate {
    
}
