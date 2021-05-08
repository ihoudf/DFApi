//
//  ApiEnv.swift
//  DFApi
//
//  Created by ihoudf on 2021/4/28.
//

import Foundation
import UIKit

public enum ApiEnv: String {
    /// 开发环境
    case develop = "http://app.u17.com/v3/appV3_3/ios/phone"
    /// 测试环境
    case test = "http://www.baidu.com"
    /// 生产环境
    case production = "http://"
    
    
    static private let ApiEnvKey = "ApiEnvKey"
    
    // 默认环境
    static private let `default`: ApiEnv = .develop
    
    // 当前环境
    public static var currentEnv: ApiEnv {
        guard let env = UserDefaults.standard.value(forKey: ApiEnv.ApiEnvKey) as? ApiEnv.RawValue else {
            return `default`
        }
        return ApiEnv(rawValue: env)!
    }
    
    /// 切换环境
    static func switchEnv(_ env: ApiEnv) {
        if currentEnv == env { return }
        UserDefaults.standard.setValue(env.rawValue, forKey: ApiEnv.ApiEnvKey)
        UserDefaults.standard.synchronize()
        exit(0)
    }
}


extension ApiEnv {
    
    static func showEnvAlert() {
        let alert = UIAlertController(title: "切换环境", message: "", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "开发", style: .default) { (action) in
            switchEnv(.develop)
        }
        
        let action2 = UIAlertAction(title: "测试", style: .default) { (action) in
            switchEnv(.test)
        }
        
        let action3 = UIAlertAction(title: "生产", style: .default) { (action) in
            switchEnv(.production)
        }
                
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        UIApplication.shared.delegate?.window??.rootViewController?.present(alert, animated: true)
    }
    
}

