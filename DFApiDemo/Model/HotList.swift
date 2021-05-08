//
//  HotList.swift
//  DFApiDemo
//
//  Created by houdongfeng on 2021/5/6.
//

import Foundation
import HandyJSON

struct HotListModel: HandyJSON {
    var hotItems: [hotItemsModel]?
    var defaultSearch: String?
}

struct hotItemsModel: HandyJSON {
    var bgColor: String?
    var comic_id: String?
    var name: String?
}
