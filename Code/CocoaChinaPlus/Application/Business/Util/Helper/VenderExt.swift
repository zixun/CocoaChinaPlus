//
//  VenderExt.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/8/11.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import Alamofire
import Ji
import MBProgressHUD
import Neon

//MARK: - Alamofire - Request
extension DataRequest {
    
    func responseJi(_ completionJi:@escaping (_ ji:Ji?,_ error:Error?) -> Void) -> Self {
        
        return response { response in
            guard response.error == nil && response.data != nil else {
                UIAlertView.quickTip(message: "您的网络有问题，请确认网络是否异常")
                return
            }
            
            let jiDoc = Ji(htmlData: response.data!)!
            completionJi(jiDoc, response.error)
          
        }
    }
}


public func CCRequest(
    _ method: HTTPMethod,
    _ URLString: String,
    cheat:Bool = true,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default)
    -> DataRequest {
        
        var headers:HTTPHeaders?
        if cheat {
            headers = HTTPHeaders()
            headers!["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36"
        }
        
        
        return Alamofire.request(URLString, method: method, parameters: parameters, encoding: encoding, headers: headers)
}

extension MBProgressHUD {
    static func showText(_ text:String) {
        let view = UIApplication.shared.keyWindow
        let hud = MBProgressHUD.showAdded(to: view!, animated: true)
        hud.label.text = text
        hud.mode = MBProgressHUDMode.text
        hud.color = UIColor.assistColor()
        hud.margin = 10.0
        hud.labelColor = UIColor.white
        hud.removeFromSuperViewOnHide = true
        // 1秒之后再消失
        hud.hide(true, afterDelay: 1)
    }
}


extension Anchorable {
    
    func anchorAndFillEdge(_ edge: Edge, xPad: CGFloat, yPad: CGFloat, otherSizeTupling: CGFloat) {
        
        var otherSize :CGFloat = 0.0
        
        switch edge {
        case .top:
            otherSize =  ( superFrame.width - (2 * xPad) ) * otherSizeTupling
            
        case .left:
            otherSize  = ( superFrame.height - (2 * yPad) ) * otherSizeTupling
            
        case .bottom:
            otherSize = ( superFrame.width - (2 * xPad) ) * otherSizeTupling
            
        case .right:
            otherSize = ( superFrame.height - (2 * yPad) ) * otherSizeTupling
        }
        
        self.anchorAndFillEdge(edge, xPad: xPad, yPad: yPad, otherSize: otherSize)
    }
}

extension UILabel {
    
    func anchorInCornerWithAutoSize(_ corner: Neon.Corner, xPad: CGFloat, yPad: CGFloat) {
        
        let size = self._boundingRectWithSize(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        self.anchorInCorner(corner, xPad: xPad, yPad: yPad, width: size.width, height: size.height)
    }
    
    
    fileprivate func _boundingRectWithSize(_ size: CGSize) -> CGSize{
        guard self.text != nil else {
            return CGSize.zero
        }
        
        let text = self.text! as NSString
        let options = [NSStringDrawingOptions.truncatesLastVisibleLine,NSStringDrawingOptions.usesLineFragmentOrigin,NSStringDrawingOptions.usesFontLeading] as NSStringDrawingOptions
        let attributes = [NSFontAttributeName :  self.font]
        
        return text.boundingRect(with: size, options: options, attributes: attributes, context: nil).size
    }
}

