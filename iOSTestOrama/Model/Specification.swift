//
//  Specification.swift
//  iOSTestOrama
//
//  Created by Bruno Pampolha on 22/03/19.
//  Copyright © 2019 Bruno Pampolha. All rights reserved.
//

import Foundation

struct Specification: Codable {
    let riskProfile: FundRiskProfile
    
    enum CodingKeys: String, CodingKey {
        case riskProfile = "fund_risk_profile"
    }
}
