//
//  CK550Command.swift
//  ck550
//
//  Created by Michal Duda on 11/11/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

struct CK550Command {

    static var setManualControl : [uint8] {
        get {
            return newComand(request: [0x41, 0x02])
        }
    }
    static var setManualControl2 : [uint8] {
        get {
            return newComand(request: [0xC0, 0xF0, 0x00, 0x00, 0x01])
        }
    }

    
    static var turnLEDsOff : [uint8] {
        get {
            return newComand(request: [0xC0, 0x00])
        }
    }
    static private var setLEDsColorTemplate : [uint8] {
        get {
            return newComand(request: [0xC0, 0x00])
        }
    }
    static var getCustomRGBMapping : [uint8] {
        get {
            return newComand(request: [0x52, 0xa8])
        }
    }

    
    static private var setLEDColorTemplate : [uint8] {
        get {
            return newComand(request: [0x56, 0x42, 0x00, 0x00, 0x03, 0x01])
        }
    }

    
    static var setCustomRGBMapping0 : [uint8] {
        get {
            return newComand(request: [0x56, 0x83, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x80, 0x01, 0x00, 0xC1, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00])
        }
    }
    static var setCustomRGBMapping1 : [uint8] {
        get {
            return newComand(request: [0x56, 0x83, 0x01, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0xFF, 0xFF, 0xFF, 0x00, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0xFF, 0xFF, 0xFF, 0x00, 0x00])
        }
    }
    
    static var setCustomRGBMapping2 : [uint8] {
        get {
            return newComand(request: [0x56, 0x83, 0x02, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0xff, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        }
    }
    
    static var setCustomRGBMapping4 : [uint8] {
        get {
            return newComand(request: [0x56, 0x83, 0x04, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x2F, 0x2F, 0xFF, 0xFF, 0x00, 0xFF, 0xFF, 0x00, 0xFF, 0xFF, 0x00, 0xFF, 0xFF, 0x00, 0xFF, 0xFF, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF])
        }
    }
    
    static var setCustomRGBMapping6 : [uint8] {
        get {
            return newComand(request: [0x56, 0x83, 0x06, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        }
    }
    
    static var setCustomRGBMapping7 : [uint8] {
        get {
            return newComand(request: [0x56, 0x83, 0x07, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        }
    }
    
    static var setCustomRGBMapping5 : [uint8] {
        get {
            return newComand(request: [0x56, 0x83, 0x05, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF
])
        }
    }
    
    static var setCustomRGBMapping3 : [uint8] {
        get {
            return newComand(request: [0x56, 0x83, 0x03, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00
])
        }
    }
    

    static var setCustomizationRGBControl : [uint8] {
        get {
            return newComand(request: [0x41, 0x80])
        }
    }
    static var settmp2 : [uint8] {
        get {
            return newComand(request: [0x56, 0x81, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0xBB, 0xBB, 0xBB, 0xBB, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        }
    }

    static var settmp3 : [uint8] {
        get {
            return newComand(request: [0x40, 0x63])
        }
    }
    
    static func newComand(request: [uint8]) -> [uint8] {
        var command = Array.init(repeating: UInt8(0x00), count: 64)
        command.replaceSubrange(Range<Int>(uncheckedBounds: (lower: 0, upper: request.count)), with: request)
        return command
    }
    
    
    static func setLEDsColor(red: uint8, green: uint8, blue: uint8) -> [uint8] {
        var command = setLEDsColorTemplate
        command[4] = red
        command[5] = green
        command[6] = blue
        return command
    }
        
    static func setLEDColor(key: uint8, red: uint8, green: uint8, blue: uint8) -> [uint8] {
        var command = setLEDColorTemplate
        command[6] = key
        command[7] = red
        command[8] = green
        command[9] = blue
        print ("----")
        print(Data(command).hexString())
        return command
    }
    

    

}

struct CK550CustomizationKeyData {
    let packet : Int
    let offset : Int
    var color: RGBColor
    init(packet : Int, offset: Int) {
        self.packet = packet
        self.offset = offset
        self.color = RGBColor(red: 0, green: 0, blue: 0)
    }
}

protocol Layout {
    init(mapping: inout Array<CK550CustomizationKeyData>)
    associatedtype Key
    
    func color(key: Key) -> RGBColor
    func setColor(key: Key, color: RGBColor) -> Void
    func packet(key: Key) -> Int
    func offset(key: Key) -> Int
    func keys(packet: Int) -> Array<Key>
    func key(packet: Int, offset: Int) -> Key?
}

class LayoutUS : Layout {
    typealias Key = KeyUS
    enum KeyUS: Int, CaseIterable  {
        typealias RawValue = Int
        
        case Escape = 0, BackQuote, Tab, Capslock, LeftShift, LeftCtrl, LeftWin, Number1,
        Q, A, Z, LeftAlt, F1, Numeric2, W, S, X, F2, Numeric3, E, D, C, F3, Numeric4, R, F,
        V, F4, Numeric5, T, G, B, Space, Numeric6, Y, H, N, F5, Numeric7, U, J, M,
        F6, Numeric8, I, K, Comma, F7, Numeric9, O, L, Point, RightAlt, F8, Numeric0, P, Semicolon, Slash, RightWin, F9, Minus,
        LeftSquareBracket, Apostroph, Function, F10, Equal, RightCurlyBracket, F11, F12, Backspace, Backslash, Enter,
        RightShift, RightCtrl, Print, Insert, Delete, LeftArrow, Scroll, Home, End, UpArrow, DownArrow, Pause, PageUp, PageDown, RightArrow,
        Numlock, Num7, Num4, Num1, NumSlash, Num8, Num5, Num2, Num0, NumAsterisk, Num9, Num6, Num3, NumPoint, NumMinus, NumPlus, NumEnter
    }
    
    var mapping: Array<CK550CustomizationKeyData>
    
    required init(mapping: inout Array<CK550CustomizationKeyData>) {
        self.mapping = mapping
        mapping[Key.Escape.rawValue] = CK550CustomizationKeyData(packet: 0, offset: 0x18)
        mapping[Key.BackQuote.rawValue] = CK550CustomizationKeyData(packet: 0, offset: 0x1B)
        mapping[Key.Tab.rawValue] = CK550CustomizationKeyData(packet: 0, offset: 0x1E)
        mapping[Key.Capslock.rawValue] = CK550CustomizationKeyData(packet: 0, offset: 0x21)
        mapping[Key.LeftShift.rawValue] = CK550CustomizationKeyData(packet: 0, offset: 0x24)
        mapping[Key.LeftCtrl.rawValue] = CK550CustomizationKeyData(packet: 0, offset: 0x27)
        mapping[Key.LeftWin.rawValue] = CK550CustomizationKeyData(packet: 0, offset: 0x39)
        mapping[Key.Number1.rawValue] = CK550CustomizationKeyData(packet: 0, offset: 0x3F)
        mapping[Key.Q.rawValue] = CK550CustomizationKeyData(packet: 1, offset: 0x06)
        mapping[Key.A.rawValue] = CK550CustomizationKeyData(packet: 1, offset: 0x09)
        mapping[Key.Z.rawValue] = CK550CustomizationKeyData(packet: 1, offset: 0x0C)
        mapping[Key.LeftAlt.rawValue] = CK550CustomizationKeyData(packet: 1, offset: 0x0F)
        mapping[Key.F1.rawValue] = CK550CustomizationKeyData(packet: 1, offset: 0x12)
        mapping[Key.Numeric2.rawValue] = CK550CustomizationKeyData(packet: 1, offset: 0x15)
        mapping[Key.W.rawValue] = CK550CustomizationKeyData(packet: 1, offset: 0x18)
        mapping[Key.S.rawValue] = CK550CustomizationKeyData(packet: 1, offset: 0x1B)
        mapping[Key.X.rawValue] = CK550CustomizationKeyData(packet: 1, offset: 0x1E)
        mapping[Key.F2.rawValue] = CK550CustomizationKeyData(packet: 1, offset: 0x24)
        mapping[Key.Numeric3.rawValue] = CK550CustomizationKeyData(packet: 1, offset: 0x27)
        mapping[Key.E.rawValue] = CK550CustomizationKeyData(packet: 1, offset: 0x2A)
        mapping[Key.D.rawValue] = CK550CustomizationKeyData(packet: 1, offset: 0x2D)
        mapping[Key.C.rawValue] = CK550CustomizationKeyData(packet: 1, offset: 0x30)
        mapping[Key.F3.rawValue] = CK550CustomizationKeyData(packet: 1, offset: 0x36)
        mapping[Key.Numeric4.rawValue] = CK550CustomizationKeyData(packet: 1, offset: 0x39)
        mapping[Key.R.rawValue] = CK550CustomizationKeyData(packet: 1, offset: 0x3C)
        mapping[Key.F.rawValue] = CK550CustomizationKeyData(packet: 1, offset: 0x3F)
        mapping[Key.V.rawValue] = CK550CustomizationKeyData(packet: 2, offset: 0x06)
        mapping[Key.F4.rawValue] = CK550CustomizationKeyData(packet: 2, offset: 0x0C)
        mapping[Key.Numeric5.rawValue] = CK550CustomizationKeyData(packet: 2, offset: 0x0F)
        mapping[Key.T.rawValue] = CK550CustomizationKeyData(packet: 2, offset: 0x12)
        mapping[Key.G.rawValue] = CK550CustomizationKeyData(packet: 2, offset: 0x15)
        mapping[Key.B.rawValue] = CK550CustomizationKeyData(packet: 2, offset: 0x18)
        mapping[Key.Space.rawValue] = CK550CustomizationKeyData(packet: 2, offset: 0x1B)
        mapping[Key.Numeric6.rawValue] = CK550CustomizationKeyData(packet: 2, offset: 0x21)
        mapping[Key.Y.rawValue] = CK550CustomizationKeyData(packet: 2, offset: 0x24)
        mapping[Key.H.rawValue] = CK550CustomizationKeyData(packet: 2, offset: 0x27)
        mapping[Key.N.rawValue] = CK550CustomizationKeyData(packet: 2, offset: 0x2A)
        mapping[Key.F5.rawValue] = CK550CustomizationKeyData(packet: 2, offset: 0x30)
        mapping[Key.Numeric7.rawValue] = CK550CustomizationKeyData(packet: 2, offset: 0x33)
        mapping[Key.U.rawValue] = CK550CustomizationKeyData(packet: 2, offset: 0x36)
        mapping[Key.J.rawValue] = CK550CustomizationKeyData(packet: 2, offset: 0x39)
        mapping[Key.M.rawValue] = CK550CustomizationKeyData(packet: 2, offset: 0x3C)
        mapping[Key.F6.rawValue] = CK550CustomizationKeyData(packet: 3, offset: 0x06)
        mapping[Key.Numeric8.rawValue] = CK550CustomizationKeyData(packet: 3, offset: 0x09)
        mapping[Key.I.rawValue] = CK550CustomizationKeyData(packet: 3, offset: 0x0C)
        mapping[Key.K.rawValue] = CK550CustomizationKeyData(packet: 3, offset: 0x0F)
        mapping[Key.Comma.rawValue] = CK550CustomizationKeyData(packet: 3, offset: 0x12)
        mapping[Key.F7.rawValue] = CK550CustomizationKeyData(packet: 3, offset: 0x18)
        mapping[Key.Numeric9.rawValue] = CK550CustomizationKeyData(packet: 3, offset: 0x1B)
        mapping[Key.O.rawValue] = CK550CustomizationKeyData(packet: 3, offset: 0x1E)
        mapping[Key.L.rawValue] = CK550CustomizationKeyData(packet: 3, offset: 0x21)
        mapping[Key.Point.rawValue] = CK550CustomizationKeyData(packet: 3, offset: 0x24)
        mapping[Key.RightAlt.rawValue] = CK550CustomizationKeyData(packet: 3, offset: 0x27)
        mapping[Key.F8.rawValue] = CK550CustomizationKeyData(packet: 3, offset: 0x2A)
        mapping[Key.Numeric0.rawValue] = CK550CustomizationKeyData(packet: 3, offset: 0x2D)
        mapping[Key.P.rawValue] = CK550CustomizationKeyData(packet: 3, offset: 0x30)
        mapping[Key.Semicolon.rawValue] = CK550CustomizationKeyData(packet: 3, offset: 0x33)
        mapping[Key.Slash.rawValue] = CK550CustomizationKeyData(packet: 3, offset: 0x36)
        mapping[Key.RightWin.rawValue] = CK550CustomizationKeyData(packet: 3, offset: 0x39)
        mapping[Key.F9.rawValue] = CK550CustomizationKeyData(packet: 3, offset: 0x3C)
        mapping[Key.Minus.rawValue] = CK550CustomizationKeyData(packet: 3, offset: 0x3F)
        mapping[Key.LeftSquareBracket.rawValue] = CK550CustomizationKeyData(packet: 0, offset: 0x06)
        mapping[Key.Apostroph.rawValue] = CK550CustomizationKeyData(packet: 4, offset: 0x09)
        mapping[Key.Function.rawValue] = CK550CustomizationKeyData(packet: 4, offset: 0x0F)
        mapping[Key.F10.rawValue] = CK550CustomizationKeyData(packet: 4, offset: 0x12)
        mapping[Key.Equal.rawValue] = CK550CustomizationKeyData(packet: 4, offset: 0x15)
        mapping[Key.RightCurlyBracket.rawValue] = CK550CustomizationKeyData(packet: 4, offset: 0x18)
        mapping[Key.F11.rawValue] = CK550CustomizationKeyData(packet: 4, offset: 0x24)
        mapping[Key.F12.rawValue] = CK550CustomizationKeyData(packet: 4, offset: 0x36)
        mapping[Key.Backspace.rawValue] = CK550CustomizationKeyData(packet: 4, offset: 0x39)
        mapping[Key.Backslash.rawValue] = CK550CustomizationKeyData(packet: 4, offset: 0x3C)
        mapping[Key.Enter.rawValue] = CK550CustomizationKeyData(packet: 4, offset: 0x3F)
        mapping[Key.RightShift.rawValue] = CK550CustomizationKeyData(packet: 5, offset: 0x06)
        mapping[Key.RightCtrl.rawValue] = CK550CustomizationKeyData(packet: 5, offset: 0x09)
        mapping[Key.Print.rawValue] = CK550CustomizationKeyData(packet: 5, offset: 0x0C)
        mapping[Key.Insert.rawValue] = CK550CustomizationKeyData(packet: 5, offset: 0x0F)
        mapping[Key.Delete.rawValue] = CK550CustomizationKeyData(packet: 5, offset: 0x12)
        mapping[Key.LeftArrow.rawValue] = CK550CustomizationKeyData(packet: 5, offset: 0x1B)
        mapping[Key.Scroll.rawValue] = CK550CustomizationKeyData(packet: 5, offset: 0x1E)
        mapping[Key.Home.rawValue] = CK550CustomizationKeyData(packet: 5, offset: 0x21)
        mapping[Key.End.rawValue] = CK550CustomizationKeyData(packet: 5, offset: 0x24)
        mapping[Key.UpArrow.rawValue] = CK550CustomizationKeyData(packet: 5, offset: 0x2A)
        mapping[Key.DownArrow.rawValue] = CK550CustomizationKeyData(packet: 5, offset: 0x2D)
        mapping[Key.Pause.rawValue] = CK550CustomizationKeyData(packet: 5, offset: 0x30)
        mapping[Key.PageUp.rawValue] = CK550CustomizationKeyData(packet: 5, offset: 0x33)
        mapping[Key.PageDown.rawValue] = CK550CustomizationKeyData(packet: 5, offset: 0x36)
        mapping[Key.RightArrow.rawValue] = CK550CustomizationKeyData(packet: 5, offset: 0x3F)
        mapping[Key.Numlock.rawValue] = CK550CustomizationKeyData(packet: 6, offset: 0x09)
        mapping[Key.Num7.rawValue] = CK550CustomizationKeyData(packet: 6, offset: 0x0C)
        mapping[Key.Num4.rawValue] = CK550CustomizationKeyData(packet: 6, offset: 0x0F)
        mapping[Key.Num1.rawValue] = CK550CustomizationKeyData(packet: 6, offset: 0x12)
        mapping[Key.NumSlash.rawValue] = CK550CustomizationKeyData(packet: 6, offset: 0x1B)
        mapping[Key.Num8.rawValue] = CK550CustomizationKeyData(packet: 6, offset: 0x1E)
        mapping[Key.Num5.rawValue] = CK550CustomizationKeyData(packet: 6, offset: 0x21)
        mapping[Key.Num2.rawValue] = CK550CustomizationKeyData(packet: 6, offset: 0x24)
        mapping[Key.Num0.rawValue] = CK550CustomizationKeyData(packet: 6, offset: 0x27)
        mapping[Key.NumAsterisk.rawValue] = CK550CustomizationKeyData(packet: 6, offset: 0x2D)
        mapping[Key.Num9.rawValue] = CK550CustomizationKeyData(packet: 6, offset: 0x30)
        mapping[Key.Num6.rawValue] = CK550CustomizationKeyData(packet: 6, offset: 0x33)
        mapping[Key.Num3.rawValue] = CK550CustomizationKeyData(packet: 6, offset: 0x36)
        mapping[Key.NumPoint.rawValue] = CK550CustomizationKeyData(packet: 6, offset: 0x39)
        mapping[Key.NumMinus.rawValue] = CK550CustomizationKeyData(packet: 6, offset: 0x3F)
        mapping[Key.NumPlus.rawValue] = CK550CustomizationKeyData(packet: 7, offset: 0x06)
        mapping[Key.NumEnter.rawValue] = CK550CustomizationKeyData(packet: 7, offset: 0x0C)
    }
    
    func color(key: Key) -> RGBColor {
        return mapping[key.rawValue].color
    }
    
    func setColor(key: Key, color: RGBColor) -> Void {
        mapping[key.rawValue].color = color
    }
    
    func packet(key: Key) -> Int {
        return mapping[key.rawValue].packet
    }
    
    func offset(key: Key) -> Int {
        return mapping[key.rawValue].offset
    }
    
    func keys(packet: Int) -> Array<Key> {
        var list = Array<Key>()
        Key.allCases.forEach { (key) in
            if mapping[key.rawValue].packet == packet {
                list.append(key)
            }
        }
        return list
    }
    
    func key(packet: Int, offset: Int) -> Key? {
        var retval : Key? = nil
        Key.allCases.forEach { (key) in
            let data = mapping[key.rawValue]
            if data.packet == packet && data.offset == offset {
                return retval = key
            }
        }
        return retval
    }
}

class CK550CustomizationKeys<LAYOUT : Layout> {
    var mapping = Array<CK550CustomizationKeyData>()
    var layout : LAYOUT
    init() {
        layout = LAYOUT.init(mapping: &mapping)
    }
}
