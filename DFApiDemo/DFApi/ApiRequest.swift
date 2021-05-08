//
//  ApiRequest.swift
//  DFApi
//
//  Created by ihoudf on 2021/4/28.
//

import Foundation
import HandyJSON
import Moya

enum ApiRequestType {
                    // | 菊花 | 缓存 | 提示 |
    case `default`  // |  有  |  无 |  有  |
    case cached     // |  有  |  有 |  有  |
    case custom     // |  无  |  无 |  无  |
}

public typealias completion<T: HandyJSON> = (_ isSucc: Bool, _ returnData: T?, _ err: Swift.Error?) -> Void

/// 发起请求
/// - Parameters:
///   - type: 请求类型
///   - target: 接口名
///   - completion: 回调
func ApiRequest<T: HandyJSON>(type: ApiRequestType? = .default,
                              target: Api,
                              completion: completion<T>?) {
    
    guard let completion = completion else { return }
    
    let needLoading = type != ApiRequestType.custom
    let needCache = type == ApiRequestType.cached
    let needTips = type != ApiRequestType.custom
    
    
    // 需要缓存，有缓存先返回缓存
    if needCache {
        if let data = getCache(for: target) {
            let str = String(data: data, encoding: .utf8)
            if let object = ApiModel<T>.deserialize(from: str) {
                completion(true, object.data?.returnData, nil)
            }
        }
    }
    
    // 开始请求
    let plugins = needLoading ? [ApiRequestPlugin()] : []
    let provider = MoyaProvider<Api>(plugins: plugins)
    provider.df_request(target, needCache, needTips, completion)
}

