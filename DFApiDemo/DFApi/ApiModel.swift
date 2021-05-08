//
//  ApiModel.swift
//  DFApi
//
//  Created by ihoudf on 2021/4/28.
//

import Foundation
import HandyJSON

class ApiModel<T: HandyJSON>: HandyJSON {
    var code: Int = 1 // 业务码
    var msg: String? // 信息
    var data: ReturnData<T>? // 数据
    required init() {}
}

class ReturnData<T: HandyJSON>: HandyJSON {
    var message:String?
    var returnData: T?
    var stateCode: Int = 0
    required init() {}
}


class ApiEmptyModel: HandyJSON {
    required init() {}
}
