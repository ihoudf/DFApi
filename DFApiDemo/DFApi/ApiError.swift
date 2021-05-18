//
//  ApiError.swift
//  DFApi
//
//  Created by ihoudf on 2021/4/28.
//

import Foundation

public enum ApiError: Swift.Error, CaseIterable {
    // *** 本地错误码 ***
    case ApiLocalErrorUnknown
    case ApiLocalErrorIllegalParams
    case ApiLocalErrorDataFormat
    case ApiLocalErrorNoLinkToNet
    case ApiLocalErrorTimedOut
    
    
    // *** 服务端错误码 ***
    case ApiServerErrorUnknown // 未知错误
//    case ApiServerErrorCustom1
//    case ApiServerErrorCustom2
}

extension ApiError: CustomNSError {

    public static var errorDomain: String { return "ApiErrorDomain" }

    public var errorUserInfo: [String: Any] {
        var userInfo: [String: Any] = [:]
        userInfo[NSLocalizedDescriptionKey] = errorDescription
        return userInfo
    }

    public var errorCode: Int {
        switch self {
        //
        case .ApiLocalErrorUnknown: return -10000
        case .ApiLocalErrorIllegalParams: return -10001
        case .ApiLocalErrorDataFormat: return -10002
        case .ApiLocalErrorNoLinkToNet: return -10003
        case .ApiLocalErrorTimedOut: return -10004
        //
        case .ApiServerErrorUnknown: return 1000
//        case .ApiServerErrorCustom1: return 4001
//        case .ApiServerErrorCustom2: return 4002
        }
    }

}

extension ApiError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        //
        case .ApiLocalErrorUnknown: return "未知错误"
        case .ApiLocalErrorIllegalParams: return "非法参数"
        case .ApiLocalErrorDataFormat: return "数据格式错误"
        case .ApiLocalErrorNoLinkToNet: return "没有网络连接"
        case .ApiLocalErrorTimedOut: return "请求超时"
            
        //
        case .ApiServerErrorUnknown: return "服务器异常，请稍后再试"
//        case .ApiServerErrorCustom1: return "错误1"
//        case .ApiServerErrorCustom2: return "错误2"
        }
    }
}
