//
//  CK550CommandEffectsCustomization.swift
//  ck550-cli
//
//  Created by Michal Duda on 21/11/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

extension CK550Command {
    static func offEffectcustomizationPacket(packetId: Int) -> [uint8] {
        switch packetId {
        case 0:
            return newComand(request: [0x56, 0x83, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x80, 0x01, 0x00, 0xC1, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF])
        default:
            var command = newComand(request: [0x56, 0x83, 0x00])
            command[2] = UInt8(packetId)
            return command
        }
    }

    static var setOffEffectCustomizationUNKNOWN_BEFORE_PACKETS : [uint8] {
        get {
            return newComand(request: [0x56, 0x81, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0xBB, 0xBB, 0xBB, 0xBB, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        }
    }
    
    static var setOffEffectCustomizationUNKNOWN_AFTER_PACKETS : [uint8] {
        get {
            return newComand(request: [0x40, 0x63])
        }
    }
}


struct CK550OffEffectCustomizationKeyData {
    let packet : Int
    let offset : Int
    var color: RGBColor
    init(packet : Int, offset: Int) {
        self.packet = packet
        self.offset = offset
        self.color = RGBColor(red: 0, green: 0, blue: 0)
    }
}

protocol CK550OffEffectCustomizationLayout {
    init()
    associatedtype Key
    
    func color(key: Key) -> RGBColor
    func setColor(key: Key, color: RGBColor) -> Void
    func packet(key: Key) -> Int
    func offset(key: Key) -> Int
    func keys(packet: Int) -> Array<Key>
    func key(packet: Int, offset: Int) -> Key?
}

class CK550OffEffectCustomizationLayoutUS : CK550OffEffectCustomizationLayout {
    typealias Key = KeyUS
    enum KeyUS: Int, CaseIterable  {
        typealias RawValue = Int
        
        case
        /* Packet 0 */ Escape = 0, BackQuote, Tab, Capslock, LeftShift, LeftCtrl, LeftWin, Numeric1,
        /* Packet 1 */ Q, A, Z, LeftAlt, F1, Numeric2, W, S, X, F2, Numeric3, E, D, C, F3, Numeric4, R, F,
        /* Packet 2 */ V, F4, Numeric5, T, G, B, Space, Numeric6, Y, H, N, F5, Numeric7, U, J, M,
        /* Packet 3 */ F6, Numeric8, I, K, Comma, F7, Numeric9, O, L, Point, RightAlt, F8, Numeric0, P, Semicolon, Slash, RightWin, F9, Minus,
        /* Packet 4 */ LeftSquareBracket, Apostroph, Function, F10, Equal, RightSquareBracket, F11, F12, Backspace, Backslash, Enter,
        /* Packet 5 */ RightShift, RightCtrl, Print, Insert, Delete, LeftArrow, Scroll, Home, End, UpArrow, DownArrow, Pause, PageUp, PageDown, RightArrow,
        /* Packet 6 */ NumLock, Numpad7, Numpad4, Numpad1, NumSlash, Numpad8, Numpad5, Numpad2, Numpad0, NumpadAsterisk, Numpad9, Numpad6, Numpad3, NumpadPoint, NumpadMinus,
        /* Packet 7 */ NumpadPlus, NumpadEnter
    }
    
    var mapping = Array<CK550OffEffectCustomizationKeyData>(repeating: CK550OffEffectCustomizationKeyData(packet: 0, offset: 0), count: KeyUS.allCases.count)
    
    required init() {
        mapping[Key.Escape.rawValue]                = CK550OffEffectCustomizationKeyData(packet: 0, offset: 0x18)
        mapping[Key.BackQuote.rawValue]             = CK550OffEffectCustomizationKeyData(packet: 0, offset: 0x1B)
        mapping[Key.Tab.rawValue]                   = CK550OffEffectCustomizationKeyData(packet: 0, offset: 0x1E)
        mapping[Key.Capslock.rawValue]              = CK550OffEffectCustomizationKeyData(packet: 0, offset: 0x21)
        mapping[Key.LeftShift.rawValue]             = CK550OffEffectCustomizationKeyData(packet: 0, offset: 0x24)
        mapping[Key.LeftCtrl.rawValue]              = CK550OffEffectCustomizationKeyData(packet: 0, offset: 0x27)
        mapping[Key.LeftWin.rawValue]               = CK550OffEffectCustomizationKeyData(packet: 0, offset: 0x39)
        mapping[Key.Numeric1.rawValue]              = CK550OffEffectCustomizationKeyData(packet: 0, offset: 0x3F)
        mapping[Key.Q.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 1, offset: 0x06)
        mapping[Key.A.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 1, offset: 0x09)
        mapping[Key.Z.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 1, offset: 0x0C)
        mapping[Key.LeftAlt.rawValue]               = CK550OffEffectCustomizationKeyData(packet: 1, offset: 0x0F)
        mapping[Key.F1.rawValue]                    = CK550OffEffectCustomizationKeyData(packet: 1, offset: 0x12)
        mapping[Key.Numeric2.rawValue]              = CK550OffEffectCustomizationKeyData(packet: 1, offset: 0x15)
        mapping[Key.W.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 1, offset: 0x18)
        mapping[Key.S.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 1, offset: 0x1B)
        mapping[Key.X.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 1, offset: 0x1E)
        mapping[Key.F2.rawValue]                    = CK550OffEffectCustomizationKeyData(packet: 1, offset: 0x24)
        mapping[Key.Numeric3.rawValue]              = CK550OffEffectCustomizationKeyData(packet: 1, offset: 0x27)
        mapping[Key.E.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 1, offset: 0x2A)
        mapping[Key.D.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 1, offset: 0x2D)
        mapping[Key.C.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 1, offset: 0x30)
        mapping[Key.F3.rawValue]                    = CK550OffEffectCustomizationKeyData(packet: 1, offset: 0x36)
        mapping[Key.Numeric4.rawValue]              = CK550OffEffectCustomizationKeyData(packet: 1, offset: 0x39)
        mapping[Key.R.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 1, offset: 0x3C)
        mapping[Key.F.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 1, offset: 0x3F)
        mapping[Key.V.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 2, offset: 0x06)
        mapping[Key.F4.rawValue]                    = CK550OffEffectCustomizationKeyData(packet: 2, offset: 0x0C)
        mapping[Key.Numeric5.rawValue]              = CK550OffEffectCustomizationKeyData(packet: 2, offset: 0x0F)
        mapping[Key.T.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 2, offset: 0x12)
        mapping[Key.G.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 2, offset: 0x15)
        mapping[Key.B.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 2, offset: 0x18)
        mapping[Key.Space.rawValue]                 = CK550OffEffectCustomizationKeyData(packet: 2, offset: 0x1B)
        mapping[Key.Numeric6.rawValue]              = CK550OffEffectCustomizationKeyData(packet: 2, offset: 0x21)
        mapping[Key.Y.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 2, offset: 0x24)
        mapping[Key.H.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 2, offset: 0x27)
        mapping[Key.N.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 2, offset: 0x2A)
        mapping[Key.F5.rawValue]                    = CK550OffEffectCustomizationKeyData(packet: 2, offset: 0x30)
        mapping[Key.Numeric7.rawValue]              = CK550OffEffectCustomizationKeyData(packet: 2, offset: 0x33)
        mapping[Key.U.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 2, offset: 0x36)
        mapping[Key.J.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 2, offset: 0x39)
        mapping[Key.M.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 2, offset: 0x3C)
        mapping[Key.F6.rawValue]                    = CK550OffEffectCustomizationKeyData(packet: 3, offset: 0x06)
        mapping[Key.Numeric8.rawValue]              = CK550OffEffectCustomizationKeyData(packet: 3, offset: 0x09)
        mapping[Key.I.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 3, offset: 0x0C)
        mapping[Key.K.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 3, offset: 0x0F)
        mapping[Key.Comma.rawValue]                 = CK550OffEffectCustomizationKeyData(packet: 3, offset: 0x12)
        mapping[Key.F7.rawValue]                    = CK550OffEffectCustomizationKeyData(packet: 3, offset: 0x18)
        mapping[Key.Numeric9.rawValue]              = CK550OffEffectCustomizationKeyData(packet: 3, offset: 0x1B)
        mapping[Key.O.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 3, offset: 0x1E)
        mapping[Key.L.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 3, offset: 0x21)
        mapping[Key.Point.rawValue]                 = CK550OffEffectCustomizationKeyData(packet: 3, offset: 0x24)
        mapping[Key.RightAlt.rawValue]              = CK550OffEffectCustomizationKeyData(packet: 3, offset: 0x27)
        mapping[Key.F8.rawValue]                    = CK550OffEffectCustomizationKeyData(packet: 3, offset: 0x2A)
        mapping[Key.Numeric0.rawValue]              = CK550OffEffectCustomizationKeyData(packet: 3, offset: 0x2D)
        mapping[Key.P.rawValue]                     = CK550OffEffectCustomizationKeyData(packet: 3, offset: 0x30)
        mapping[Key.Semicolon.rawValue]             = CK550OffEffectCustomizationKeyData(packet: 3, offset: 0x33)
        mapping[Key.Slash.rawValue]                 = CK550OffEffectCustomizationKeyData(packet: 3, offset: 0x36)
        mapping[Key.RightWin.rawValue]              = CK550OffEffectCustomizationKeyData(packet: 3, offset: 0x39)
        mapping[Key.F9.rawValue]                    = CK550OffEffectCustomizationKeyData(packet: 3, offset: 0x3C)
        mapping[Key.Minus.rawValue]                 = CK550OffEffectCustomizationKeyData(packet: 3, offset: 0x3F)
        mapping[Key.LeftSquareBracket.rawValue]     = CK550OffEffectCustomizationKeyData(packet: 4, offset: 0x06)
        mapping[Key.Apostroph.rawValue]             = CK550OffEffectCustomizationKeyData(packet: 4, offset: 0x09)
        mapping[Key.Function.rawValue]              = CK550OffEffectCustomizationKeyData(packet: 4, offset: 0x0F)
        mapping[Key.F10.rawValue]                   = CK550OffEffectCustomizationKeyData(packet: 4, offset: 0x12)
        mapping[Key.Equal.rawValue]                 = CK550OffEffectCustomizationKeyData(packet: 4, offset: 0x15)
        mapping[Key.RightSquareBracket.rawValue]    = CK550OffEffectCustomizationKeyData(packet: 4, offset: 0x18)
        mapping[Key.F11.rawValue]                   = CK550OffEffectCustomizationKeyData(packet: 4, offset: 0x24)
        mapping[Key.F12.rawValue]                   = CK550OffEffectCustomizationKeyData(packet: 4, offset: 0x36)
        mapping[Key.Backspace.rawValue]             = CK550OffEffectCustomizationKeyData(packet: 4, offset: 0x39)
        mapping[Key.Backslash.rawValue]             = CK550OffEffectCustomizationKeyData(packet: 4, offset: 0x3C)
        mapping[Key.Enter.rawValue]                 = CK550OffEffectCustomizationKeyData(packet: 4, offset: 0x3F)
        mapping[Key.RightShift.rawValue]            = CK550OffEffectCustomizationKeyData(packet: 5, offset: 0x06)
        mapping[Key.RightCtrl.rawValue]             = CK550OffEffectCustomizationKeyData(packet: 5, offset: 0x09)
        mapping[Key.Print.rawValue]                 = CK550OffEffectCustomizationKeyData(packet: 5, offset: 0x0C)
        mapping[Key.Insert.rawValue]                = CK550OffEffectCustomizationKeyData(packet: 5, offset: 0x0F)
        mapping[Key.Delete.rawValue]                = CK550OffEffectCustomizationKeyData(packet: 5, offset: 0x12)
        mapping[Key.LeftArrow.rawValue]             = CK550OffEffectCustomizationKeyData(packet: 5, offset: 0x1B)
        mapping[Key.Scroll.rawValue]                = CK550OffEffectCustomizationKeyData(packet: 5, offset: 0x1E)
        mapping[Key.Home.rawValue]                  = CK550OffEffectCustomizationKeyData(packet: 5, offset: 0x21)
        mapping[Key.End.rawValue]                   = CK550OffEffectCustomizationKeyData(packet: 5, offset: 0x24)
        mapping[Key.UpArrow.rawValue]               = CK550OffEffectCustomizationKeyData(packet: 5, offset: 0x2A)
        mapping[Key.DownArrow.rawValue]             = CK550OffEffectCustomizationKeyData(packet: 5, offset: 0x2D)
        mapping[Key.Pause.rawValue]                 = CK550OffEffectCustomizationKeyData(packet: 5, offset: 0x30)
        mapping[Key.PageUp.rawValue]                = CK550OffEffectCustomizationKeyData(packet: 5, offset: 0x33)
        mapping[Key.PageDown.rawValue]              = CK550OffEffectCustomizationKeyData(packet: 5, offset: 0x36)
        mapping[Key.RightArrow.rawValue]            = CK550OffEffectCustomizationKeyData(packet: 5, offset: 0x3F)
        mapping[Key.NumLock.rawValue]               = CK550OffEffectCustomizationKeyData(packet: 6, offset: 0x09)
        mapping[Key.Numpad7.rawValue]               = CK550OffEffectCustomizationKeyData(packet: 6, offset: 0x0C)
        mapping[Key.Numpad4.rawValue]               = CK550OffEffectCustomizationKeyData(packet: 6, offset: 0x0F)
        mapping[Key.Numpad1.rawValue]               = CK550OffEffectCustomizationKeyData(packet: 6, offset: 0x12)
        mapping[Key.NumSlash.rawValue]              = CK550OffEffectCustomizationKeyData(packet: 6, offset: 0x1B)
        mapping[Key.Numpad8.rawValue]               = CK550OffEffectCustomizationKeyData(packet: 6, offset: 0x1E)
        mapping[Key.Numpad5.rawValue]               = CK550OffEffectCustomizationKeyData(packet: 6, offset: 0x21)
        mapping[Key.Numpad2.rawValue]               = CK550OffEffectCustomizationKeyData(packet: 6, offset: 0x24)
        mapping[Key.Numpad0.rawValue]               = CK550OffEffectCustomizationKeyData(packet: 6, offset: 0x27)
        mapping[Key.NumpadAsterisk.rawValue]        = CK550OffEffectCustomizationKeyData(packet: 6, offset: 0x2D)
        mapping[Key.Numpad9.rawValue]               = CK550OffEffectCustomizationKeyData(packet: 6, offset: 0x30)
        mapping[Key.Numpad6.rawValue]               = CK550OffEffectCustomizationKeyData(packet: 6, offset: 0x33)
        mapping[Key.Numpad3.rawValue]               = CK550OffEffectCustomizationKeyData(packet: 6, offset: 0x36)
        mapping[Key.NumpadPoint.rawValue]           = CK550OffEffectCustomizationKeyData(packet: 6, offset: 0x39)
        mapping[Key.NumpadMinus.rawValue]           = CK550OffEffectCustomizationKeyData(packet: 6, offset: 0x3F)
        mapping[Key.NumpadPlus.rawValue]            = CK550OffEffectCustomizationKeyData(packet: 7, offset: 0x06)
        mapping[Key.NumpadEnter.rawValue]           = CK550OffEffectCustomizationKeyData(packet: 7, offset: 0x0C)
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

class CK550OffEffectCustomizationKeys<LAYOUT: CK550OffEffectCustomizationLayout> {
    var layout: LAYOUT
    init(layout: LAYOUT) {
        self.layout = layout
    }
    
    public func packets() -> Array<Array<uint8>> {
        let sharedColorDataOffset = 0x3F
        var packets = Array<Array<uint8>>()
        
        for packetId in (0...7) {
            var packet = CK550Command.offEffectcustomizationPacket(packetId: packetId)
            
            // Shared color data from the previous packet
            if let key = layout.key(packet: packetId - 1, offset: sharedColorDataOffset) {
                let color = layout.color(key: key)
                packet[0x04] = UInt8(color.green)
                packet[0x05] = UInt8(color.blue)
            }
            
            for offsetId in (0...19) {
                let offset = 0x06 + 3 * offsetId
                if let key = layout.key(packet: packetId, offset: offset) {
                    let color = layout.color(key: key)
                    packet[offset] = UInt8(color.red)
                    if offset == sharedColorDataOffset {
                        continue
                    }
                    packet[offset + 1] = UInt8(color.green)
                    packet[offset + 2] = UInt8(color.blue)
                }
            }
            packets.append(packet)
        }
        
        return packets
    }
}
