//
//  Api.swift
//  DFApi
//
//  Created by ihoudf on 2021/4/27.
//

import Foundation
import Moya

enum Api {
    // 接口1
    case rankList
    // 接口2
    case searchHot
    // 接口3
    case userInfo(userId: String)
    
}

extension Api: TargetType {
    var baseURL: URL { URL(string: ApiEnv.currentEnv.rawValue)! }
    var path: String { ApiPath }
    var method: Moya.Method { ApiMethod }
    var sampleData: Data { "".data(using: String.Encoding.utf8)! }
    var task: Task { ApiTask }
    var headers: [String : String]? { ApiHeaders }
}

// MARK: - 以下这样拆分的好处是避免臃肿，可快速新建文件拆分
// MARK: - 接口地址

extension Api {
    var ApiPath: String {
        switch self {
        case .rankList: return "rank/list"
        case .searchHot: return "search/hotkeywordsnew"
        case .userInfo: return "user/sss/info"
        }
    }
}


// MARK: - 请求方式

extension Api {
    var ApiMethod: Moya.Method {
        switch self {
        case .userInfo(userId: _):
            return .post
        default:
            return .get
        }
    }
}


// MARK: - 参数

extension Api {
    var ApiTask: Task {
        var param: [String : Any] = [:]
        switch self {
        case .userInfo(let userId):
            param["userid"] = userId
        default: break
        }
        return .requestParameters(parameters: ["param" : param], encoding: URLEncoding.default)
    }
}


// MARK: - 公共头

extension Api {
    var ApiHeaders: [String : String] {
        return ["platform" : "ios"]
    }
}








