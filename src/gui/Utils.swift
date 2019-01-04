//
//  Utils.swift
//  ck550
//
//  Created by Michal Duda on 03/01/2019.
//  Copyright © 2019 Michal Duda. All rights reserved.
//

import Foundation
import SwiftyJSON

func isJSONParsable(_ string: String) -> Bool {
    let json = JSON(parseJSON: string)
    if let error = json.error {
        switch error {
        case .invalidJSON:
            return false
        default:
            return false
        }
    }
    return true
}
