//
//  ApiRequestPlugin.swift
//  DFApi
//
//  Created by ihoudf on 2021/4/28.
//

import Foundation
import UIKit
import MBProgressHUD
import Moya

class ApiRequestPlugin: PluginType {
    
//    init(_ target: Api,
//         _ needCache: Bool,
//         _ needTips: Bool,
//         _ completion: completion<T>?) {
//
//    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var mRequest = request
        mRequest.timeoutInterval = 30
        return mRequest
    }
    
    func willSend(_ request: RequestType, target: TargetType) {
        DispatchQueue.main.async {
            guard let view = topVC?.view else { return }
            MBProgressHUD.hide(for: view, animated: false)
            MBProgressHUD.showAdded(to: view, animated: true)
        }
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        DispatchQueue.main.async {
            guard let view = topVC?.view else { return }
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        return result
    }
}


func showToast(_ text: String?) {
    guard let text = text, let view = topVC?.view else { return }
    DispatchQueue.main.async {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.isUserInteractionEnabled = false
        hud.removeFromSuperViewOnHide = true
        hud.mode = .text
        hud.detailsLabel.text = text
        hud.detailsLabel.font = .systemFont(ofSize: 14, weight: .regular)
        hud.contentColor = .white
        hud.bezelView.color = UIColor.black.withAlphaComponent(0.5)
        hud.bezelView.style = .solidColor
        hud.margin = 20
        hud.hide(animated: true, afterDelay: 1.5)
    }
}


var topVC: UIViewController? {
    guard var vc = UIApplication.shared.delegate?.window??.rootViewController else {
        return nil
    }
    while true {
        if vc is UINavigationController {
            vc = (vc as! UINavigationController).visibleViewController!
        } else if vc is UITabBarController {
            vc = (vc as! UITabBarController).selectedViewController!
        } else if vc.presentedViewController != nil {
            vc = vc.presentedViewController!
        } else {
            break
        }
    }
    return vc
}

// MARK: - loading插件

//let ApiLoadingPlugin = NetworkActivityPlugin { (type, target) in
//    DispatchQueue.main.async {
//        guard let view = topVC?.view else { return }
//        switch type {
//        case .began:
//            MBProgressHUD.hide(for: view, animated: false)
//            MBProgressHUD.showAdded(to: view, animated: true)
//        case .ended:
//            MBProgressHUD.hide(for: view, animated: true)
//        }
//    }
//}





