//
//  BundleExtension.swift
//  ck550
//
//  Created by Michal Duda on 18/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

extension Bundle {
    static func appName() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        guard let version: String = dictionary["CFBundleName"] as? String else {
            return ""
        }
        return version
    }
}
