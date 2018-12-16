//
//  CommonColors.swift
//  ck550-cli
//
//  Created by Michal Duda on 14/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

enum CommonColors {
    case white
    case black
    case random

    func command() -> [Int] {
        switch self {
        case .white:
            return [0xFF, 0xFF, 0xFF]
        case .black:
            return [0x00, 0x00, 0x00]
        case .random:
            return []
        }
    }
}
