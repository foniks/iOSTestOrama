//
//  Fund.swift
//  iOSTestOrama
//
//  Created by Bruno Pampolha on 22/03/19.
//  Copyright © 2019 Bruno Pampolha. All rights reserved.
//

import Foundation

class Fund: Codable {
    let id: Int
    let fullName: String
    let simpleName: String
    let initialDate: String
    let operability: Operability
    let specification: Specification
    let strategyVideo: StrategyVideo?
    let manager: FundManager
    
    var purchased: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case simpleName = "simple_name"
        case initialDate = "initial_date"
        case operability
        case specification
        case strategyVideo = "strategy_video"
        case manager = "fund_manager"
    }
}
