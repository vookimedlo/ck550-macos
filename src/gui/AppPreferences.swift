//
//  AppPreferences.swift
//  ck550
//
//  Created by Michal Duda on 28/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Cocoa
import SwiftyJSON

class AppPreferences {
    var configuration: JSON?
    var configurationPath: URL = URL(fileURLWithPath: "")

    enum Preferences: String {
        case effect
    }

    enum EffectKeys: String {
        case backgroundColor, color, isColorRandom, speed, direction
    }

    subscript(key: Preferences) -> JSON {
        get {
            return configuration?[key.rawValue] ?? JSON()
        }
        set(newValue) {
            configuration?[key.rawValue] = newValue
        }
    }

    init(file: String = "config.json") {
        let urls = FileManager.default.urls(for: .applicationSupportDirectory,
                                            in: .userDomainMask)
        if let url = urls.last {
            configurationPath = url.appendingPathComponent(file)
            try? FileManager.default.createDirectory(at: url,
                                                     withIntermediateDirectories: true,
                                                     attributes: nil)
        }
    }

    func readDefaultPreferences() {
        let asset = NSDataAsset(name: "guiDefaultSettings", bundle: Bundle.main)
        if let configuration = try? JSON(data: asset!.data,
                                         options: JSONSerialization.ReadingOptions.allowFragments) {
            self.configuration = configuration
        } else {
            logError("Cannot read default configuration")
        }
    }

    func read() {
        if let string = try? String(contentsOf: configurationPath,
                                    encoding: String.Encoding.utf8) {
            configuration = JSON(parseJSON: string)
        } else {
            readDefaultPreferences()
        }
    }

    func write() {
        if let output = configuration?.rawString(String.Encoding.utf8,
                                                options: JSONSerialization.WritingOptions.prettyPrinted) {
            try? output.write(to: configurationPath,
                              atomically: false,
                              encoding: String.Encoding.utf8)
        }
    }
}
