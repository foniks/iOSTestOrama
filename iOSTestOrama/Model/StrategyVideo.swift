//
//  StrategyVideo.swift
//  iOSTestOrama
//
//  Created by Bruno Pampolha on 22/03/19.
//  Copyright © 2019 Bruno Pampolha. All rights reserved.
//

import Foundation

struct StrategyVideo: Codable {
    let thumbnailURL: String?
    
    enum CodingKeys: String, CodingKey {
        case thumbnailURL = "thumbnail"
    }
}
