//
//  ApiRequestEx.swift
//  DFApi
//
//  Created by ihoudf on 2021/5/6.
//

import Foundation
import Moya
import HandyJSON


extension MoyaProvider {
    
    // MARK: - 请求
    @discardableResult
    open func df_request<T: HandyJSON>(_ target: Target,
                                       _ needCache: Bool,
                                       _ needTips: Bool,
                                       _ completion: completion<T>?) -> Cancellable?  {
        
        return request(target, callbackQueue: DispatchQueue.main) { (result) in
            guard let completion = completion else { return }
            switch result {
            case let .success(response):
                self.handleSucc(target, response, needCache, needTips, completion)
            case let .failure(error):
                self.handleError(target, error, needTips, completion)
            }
        }
    }
    
    
    // MARK: - 处理成功回调
    
    private func handleSucc<T: HandyJSON>(_ target: Target,
                                          _ response: Response,
                                          _ needCache: Bool,
                                          _ needTips: Bool,
                                          _ completion: completion<T>) {
        do {
            // 根据http的错误码获取正常返回的response
            let res = try response.filterSuccessfulStatusCodes()
            do {
                let jsonStr = try res.mapString()
                
                // 打印
                if let jsonObject = try? res.mapJSON(),
                   let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]) {
                    let msg = String(data: data, encoding: String.Encoding.utf8) ?? ""
                    self.log(target, msg: msg)
                }
                
                //解析
                guard let object = ApiModel<T>.deserialize(from: jsonStr) else {
                    handleError(target, MoyaError.jsonMapping(res), needTips, completion)
                    return
                }
                
                // 根据服务端的业务码
                // 1.如果不是成功码，则回调错误码
                if object.code != 1 { // 1是前后端约定好的成功码
                    for e in ApiError.allCases {
                        if e.errorCode == object.code {
                            completion(false, nil, e)
                            break
                        }
                    }
                    return
                }
                
                // 缓存
                if needCache {
                    setCache(object: res.data, for: target as! Api)
                }
                
                // 2.成功回调
                completion(true, object.data?.returnData, nil)
                
            } catch {
                handleError(target, error as! MoyaError, needTips, completion)
            }
        } catch {
            handleError(target, error as! MoyaError, needTips, completion)
        }
    }
    
    
    // MARK: - 处理失败回调
    
    private func handleError<T: HandyJSON>(_ target: Target,
                                           _ error: MoyaError,
                                           _ needTips: Bool,
                                           _ completion: completion<T>) {
        var e: Swift.Error?
        var statusCode = ""
        
        switch error {
        // 请求参数错误类（.requestMapping是无效的url地址）
        case .parameterEncoding(_),
             .encodableMapping(_),
             .requestMapping(_):
            e = ApiError.ApiLocalErrorIllegalParams
        
        // 数据解析错误类
        case .imageMapping(_),
             .jsonMapping(_),
             .stringMapping(_),
             .objectMapping(_, _):
            e = ApiError.ApiLocalErrorDataFormat
            
        // http错误码类
        case .statusCode(let res):
            
            statusCode = "\(res.statusCode)"
            e = ApiError.ApiServerErrorUnknown

        // 其他类
        case .underlying(let err, _):
            switch err.asAFError {
            case .sessionTaskFailed(let errs):
                let errs = errs as NSError
                switch errs.code {
                case NSURLErrorDNSLookupFailed,
                     NSURLErrorDataNotAllowed,
                     NSURLErrorNotConnectedToInternet:
                    e = ApiError.ApiLocalErrorNoLinkToNet

                case NSURLErrorTimedOut:
                    e = ApiError.ApiLocalErrorTimedOut
                default: break
                }
            default: break
            }
        }

        let err = e == nil ? error : e
        let tips = err?.localizedDescription ?? ""
        
        // toast提示
        if needTips {
            showToast(tips + statusCode)
        }
        
        // 打印
        log(target, isSmile: false, msg: "\n==>> Msg：\(tips)\n==>> Error：" + "\(err!)")
        
        // 失败回调
        completion(false, nil, e)
    }
    
    
    // MARK: - 打印
    
    private func log(_ target: Target, isSmile: Bool = true, msg: String) {
        
        #if DEBUG
        
        // 时间格式
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        // 参数
        var paramsDic: [String: Any] = target.headers ?? [:]
        switch target.task {
        case let .requestParameters(parameters: parameters, encoding: _):
            for (key, value) in parameters {
                paramsDic.updateValue(value, forKey: key)
            }
            break
        default: break
        }
        var params = ""
        if let data = try? JSONSerialization.data(withJSONObject: paramsDic, options: [.prettyPrinted]) {
            params = String(data: data, encoding: String.Encoding.utf8) ?? ""
        }
        
        // 打印
        print("""
        ------------------------  Request Begin  --------------------------
        \("时间：" + dateformatter.string(from: Date()))
        \("地址：" + target.baseURL.absoluteString + "/" + target.path)
        \("方式：" + target.method.rawValue)
        \("参数：" + params)
        \("返回：" + (isSmile ? "💚💚💚💚" : "💔💔💔💔") + msg)
        ------------------------  Request End  ---------------------------
        """)
        
        #endif
    }
    
    
}
