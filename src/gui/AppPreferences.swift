/*

Licensed under the MIT license:

Copyright (c) 2019 Michal Duda

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

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
