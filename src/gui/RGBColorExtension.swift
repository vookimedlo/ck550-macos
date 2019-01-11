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

protocol JSONDecodable {
    init(json: JSON)
}

protocol JSONEncodable {
    var json: JSON {get}
}

private let eightBitMultiplicator: CGFloat = 255

extension RGBColor: JSONEncodable, JSONDecodable {
    var json: JSON {
        return ["red": JSON(integerLiteral: IntegerLiteralType(red)),
                "green": JSON(integerLiteral: IntegerLiteralType(green)),
                "blue": JSON(integerLiteral: IntegerLiteralType(blue))]
    }

    init(red: UInt8 = 0, green: UInt8 = 0, blue: UInt8 = 0) {
        self.init(red: UInt16(red), green: UInt16(green), blue: UInt16(blue))
    }

    init(_ nscolor: NSColor) {
        let color = nscolor.colorSpace == NSColorSpace.genericRGB ? nscolor : nscolor.usingColorSpace(NSColorSpace.genericRGB)
        self.init(red: UInt8((color?.redComponent)! * eightBitMultiplicator),
                  green: UInt8((color?.greenComponent)! * eightBitMultiplicator),
                  blue: UInt8((color?.blueComponent)! * eightBitMultiplicator))
    }

    init(json: JSON) {
        self.init(red: json["red"].uInt8!,
                  green: json["green"].uInt8!,
                  blue: json["blue"].uInt8!)
    }
}
