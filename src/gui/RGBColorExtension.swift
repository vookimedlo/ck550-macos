//
//  RGBColorExtension.swift
//  ck550
//
//  Created by Michal Duda on 25/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

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

    init(red: UInt8, green: UInt8, blue: UInt8) {
        self.init(red: UInt16(red), green: UInt16(green), blue: UInt16(blue))
    }

    init(_ nscolor: NSColor) {
        let color = nscolor.colorSpace != NSColorSpace.genericRGB ? nscolor : nscolor.usingColorSpace(NSColorSpace.genericRGB)
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
