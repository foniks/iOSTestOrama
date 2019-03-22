//
//  Operability.swift
//  iOSTestOrama
//
//  Created by Bruno Pampolha on 22/03/19.
//  Copyright © 2019 Bruno Pampolha. All rights reserved.
//

import Foundation

struct Operability: Codable {
    let minInitApplicationAmount: String
    
    enum CodingKeys: String, CodingKey {
        case minInitApplicationAmount = "minimum_initial_application_amount"
    }
}
