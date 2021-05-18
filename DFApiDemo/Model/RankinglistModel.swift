//
//  TSHomeTailModel.swift
//  DFApi
//
//  Created by ihoudf on 2021/4/28.
//

import Foundation
import HandyJSON

class RankinglistModel: HandyJSON {
    var rankinglist: [RankingModel]?
    required init() {}
}

class RankingModel: HandyJSON {
    var argCon: Int = 0
    var argName: String = ""
    var argValue: Int = 0
    var canEdit: Bool = false
    var cover: String = ""
    var isLike: Bool = false
    var sortId: Int = 0
    var sortName: String = ""
    var title: String = ""
    var subTitle: String = ""
    var rankingType: String = ""
    required init() {}

}
