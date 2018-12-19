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
    
    static func bundleVersion() -> (version: String, build: String) {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ("", "")
        }
        guard let version = dictionary["CFBundleShortVersionString"]  as? String else {
            return ("", "")
        }
        guard let build = dictionary[kCFBundleVersionKey as String] as? String else {
            return (version, "")
        }        
        return (version, build)
    }
}
