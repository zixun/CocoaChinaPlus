//
//  CCADBanner.swift
//  CocoaChinaPlus
//
//  Created by user on 15/11/4.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import RxSwift
import ZXKit

enum CCADBannerPosition:Int {
    //聊天页底部广告
    case ChatBottom = 0
    //文章页底部广告
    case ArticleBottom = 1
    //搜索页底部广告
    case SearchBottom = 2
    
    var BaiduID:String {
        switch self {
        case ChatBottom:
            return "2068346"
        case ArticleBottom:
            return "2081950"
        case .SearchBottom:
            return "2082832"
        }
    }
}

class CCADModel: NSObject {
    var adView:UIView?
    let displayObservable = PublishSubject<Bool>()
    
}

class CCADBanner: NSObject {
    
    private let adModel = CCADModel()
    
    
    func rx_adModelObservable(position:CCADBannerPosition) -> Observable<CCADModel> {
        return self.rx_adviewWithType(position)
    }
    
    
    private func rx_adviewWithType(position:CCADBannerPosition) -> Observable<CCADModel> {
        
            let adViewBaidu = BaiduMobAdView()
            adViewBaidu.AdUnitTag = position.BaiduID
            adViewBaidu.AdType = BaiduMobAdViewTypeBanner
            adViewBaidu.delegate = self
            adViewBaidu.start()
            self.adModel.adView = adViewBaidu
        
        return Observable.just(self.adModel)
    }

    
}

extension CCADBanner: BaiduMobAdViewDelegate {
    
    //Baidu
    func publisherId() -> String! {
        return "cfe01381"
    }
    
    func willDisplayAd(adview: BaiduMobAdView!) {
        self.adModel.displayObservable.on(.Next(true))
    }
    
    func failedDisplayAd(reason: BaiduMobFailReason) {
        self.adModel.displayObservable.on(.Next(false))
    }
    
    func didAdImpressed() {
        println("didAdImpressed")
    }
}
