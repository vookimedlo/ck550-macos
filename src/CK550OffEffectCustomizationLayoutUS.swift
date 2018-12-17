//
//  CK550OffEffectCustomizationLayoutUS.swift
//  ck550-cli
//
//  Created by Michal Duda on 17/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

class CK550OffEffectCustomizationLayoutUS: CK550OffEffectCustomizationLayout {
    typealias Key = KeyUS

    enum KeyUS: Int, CaseIterable {
        typealias RawValue = Int
        // swiftlint:disable identifier_name
        case
        /* Packet 0 */ escape = 0, backQuote, tab, capslock, leftShift, leftCtrl, leftWin, numeric1,
        /* Packet 1 */ q, a, z, leftAlt, f1, numeric2, w, s, x, f2, numeric3, e, d, c, f3, numeric4, r, f,
        /* Packet 2 */ v, f4, numeric5, t, g, b, space, numeric6, y, h, n, f5, numeric7, u, j, m,
        /* Packet 3 */ f6, numeric8, i, k, comma, f7, numeric9, o, l, point, rightAlt, f8, numeric0, p, semicolon, slash, rightWin, f9, minus,
        /* Packet 4 */ leftSquareBracket, apostrophe, function, f10, equal, rightSquareBracket, f11, f12, backspace, backslash, enter,
        /* Packet 5 */ rightShift, rightCtrl, print, insert, delete, leftArrow, scroll, home, end, upArrow, downArrow, pause, pageUp, pageDown, rightArrow,
        /* Packet 6 */ numLock, numpad7, numpad4, numpad1, numpadSlash, numpad8, numpad5, numpad2, numpad0, numpadAsterisk, numpad9, numpad6, numpad3, numpadPoint, numpadMinus,
        /* Packet 7 */ numpadPlus, numpadEnter
        // swiftlint:enable identifier_name
    }

    struct KeyData {
        let packet: Int
        let offset: Int
        var color: RGBColor

        init(packet: Int, offset: Int) {
            self.packet = packet
            self.offset = offset
            self.color = RGBColor(red: 0, green: 0, blue: 0)
        }
    }

    var mapping = [KeyData](repeating: KeyData(packet: 0, offset: 0), count: KeyUS.allCases.count)

    required init() {
        mapping[Key.escape.rawValue] = KeyData(packet: 0, offset: 0x18)
        mapping[Key.backQuote.rawValue] = KeyData(packet: 0, offset: 0x1B)
        mapping[Key.tab.rawValue] = KeyData(packet: 0, offset: 0x1E)
        mapping[Key.capslock.rawValue] = KeyData(packet: 0, offset: 0x21)
        mapping[Key.leftShift.rawValue] = KeyData(packet: 0, offset: 0x24)
        mapping[Key.leftCtrl.rawValue] = KeyData(packet: 0, offset: 0x27)
        mapping[Key.leftWin.rawValue] = KeyData(packet: 0, offset: 0x39)
        mapping[Key.numeric1.rawValue] = KeyData(packet: 0, offset: 0x3F)
        mapping[Key.q.rawValue] = KeyData(packet: 1, offset: 0x06)
        mapping[Key.a.rawValue] = KeyData(packet: 1, offset: 0x09)
        mapping[Key.z.rawValue] = KeyData(packet: 1, offset: 0x0C)
        mapping[Key.leftAlt.rawValue] = KeyData(packet: 1, offset: 0x0F)
        mapping[Key.f1.rawValue] = KeyData(packet: 1, offset: 0x12)
        mapping[Key.numeric2.rawValue] = KeyData(packet: 1, offset: 0x15)
        mapping[Key.w.rawValue] = KeyData(packet: 1, offset: 0x18)
        mapping[Key.s.rawValue] = KeyData(packet: 1, offset: 0x1B)
        mapping[Key.x.rawValue] = KeyData(packet: 1, offset: 0x1E)
        mapping[Key.f2.rawValue] = KeyData(packet: 1, offset: 0x24)
        mapping[Key.numeric3.rawValue] = KeyData(packet: 1, offset: 0x27)
        mapping[Key.e.rawValue] = KeyData(packet: 1, offset: 0x2A)
        mapping[Key.d.rawValue] = KeyData(packet: 1, offset: 0x2D)
        mapping[Key.c.rawValue] = KeyData(packet: 1, offset: 0x30)
        mapping[Key.f3.rawValue] = KeyData(packet: 1, offset: 0x36)
        mapping[Key.numeric4.rawValue] = KeyData(packet: 1, offset: 0x39)
        mapping[Key.r.rawValue] = KeyData(packet: 1, offset: 0x3C)
        mapping[Key.f.rawValue] = KeyData(packet: 1, offset: 0x3F)
        mapping[Key.v.rawValue] = KeyData(packet: 2, offset: 0x06)
        mapping[Key.f4.rawValue] = KeyData(packet: 2, offset: 0x0C)
        mapping[Key.numeric5.rawValue] = KeyData(packet: 2, offset: 0x0F)
        mapping[Key.t.rawValue] = KeyData(packet: 2, offset: 0x12)
        mapping[Key.g.rawValue] = KeyData(packet: 2, offset: 0x15)
        mapping[Key.b.rawValue] = KeyData(packet: 2, offset: 0x18)
        mapping[Key.space.rawValue] = KeyData(packet: 2, offset: 0x1B)
        mapping[Key.numeric6.rawValue] = KeyData(packet: 2, offset: 0x21)
        mapping[Key.y.rawValue] = KeyData(packet: 2, offset: 0x24)
        mapping[Key.h.rawValue] = KeyData(packet: 2, offset: 0x27)
        mapping[Key.n.rawValue] = KeyData(packet: 2, offset: 0x2A)
        mapping[Key.f5.rawValue] = KeyData(packet: 2, offset: 0x30)
        mapping[Key.numeric7.rawValue] = KeyData(packet: 2, offset: 0x33)
        mapping[Key.u.rawValue] = KeyData(packet: 2, offset: 0x36)
        mapping[Key.j.rawValue] = KeyData(packet: 2, offset: 0x39)
        mapping[Key.m.rawValue] = KeyData(packet: 2, offset: 0x3C)
        mapping[Key.f6.rawValue] = KeyData(packet: 3, offset: 0x06)
        mapping[Key.numeric8.rawValue] = KeyData(packet: 3, offset: 0x09)
        mapping[Key.i.rawValue] = KeyData(packet: 3, offset: 0x0C)
        mapping[Key.k.rawValue] = KeyData(packet: 3, offset: 0x0F)
        mapping[Key.comma.rawValue] = KeyData(packet: 3, offset: 0x12)
        mapping[Key.f7.rawValue] = KeyData(packet: 3, offset: 0x18)
        mapping[Key.numeric9.rawValue] = KeyData(packet: 3, offset: 0x1B)
        mapping[Key.o.rawValue] = KeyData(packet: 3, offset: 0x1E)
        mapping[Key.l.rawValue] = KeyData(packet: 3, offset: 0x21)
        mapping[Key.point.rawValue] = KeyData(packet: 3, offset: 0x24)
        mapping[Key.rightAlt.rawValue] = KeyData(packet: 3, offset: 0x27)
        mapping[Key.f8.rawValue] = KeyData(packet: 3, offset: 0x2A)
        mapping[Key.numeric0.rawValue] = KeyData(packet: 3, offset: 0x2D)
        mapping[Key.p.rawValue] = KeyData(packet: 3, offset: 0x30)
        mapping[Key.semicolon.rawValue] = KeyData(packet: 3, offset: 0x33)
        mapping[Key.slash.rawValue] = KeyData(packet: 3, offset: 0x36)
        mapping[Key.rightWin.rawValue] = KeyData(packet: 3, offset: 0x39)
        mapping[Key.f9.rawValue] = KeyData(packet: 3, offset: 0x3C)
        mapping[Key.minus.rawValue] = KeyData(packet: 3, offset: 0x3F)
        mapping[Key.leftSquareBracket.rawValue] = KeyData(packet: 4, offset: 0x06)
        mapping[Key.apostrophe.rawValue] = KeyData(packet: 4, offset: 0x09)
        mapping[Key.function.rawValue] = KeyData(packet: 4, offset: 0x0F)
        mapping[Key.f10.rawValue] = KeyData(packet: 4, offset: 0x12)
        mapping[Key.equal.rawValue] = KeyData(packet: 4, offset: 0x15)
        mapping[Key.rightSquareBracket.rawValue] = KeyData(packet: 4, offset: 0x18)
        mapping[Key.f11.rawValue] = KeyData(packet: 4, offset: 0x24)
        mapping[Key.f12.rawValue] = KeyData(packet: 4, offset: 0x36)
        mapping[Key.backspace.rawValue] = KeyData(packet: 4, offset: 0x39)
        mapping[Key.backslash.rawValue] = KeyData(packet: 4, offset: 0x3C)
        mapping[Key.enter.rawValue] = KeyData(packet: 4, offset: 0x3F)
        mapping[Key.rightShift.rawValue] = KeyData(packet: 5, offset: 0x06)
        mapping[Key.rightCtrl.rawValue] = KeyData(packet: 5, offset: 0x09)
        mapping[Key.print.rawValue] = KeyData(packet: 5, offset: 0x0C)
        mapping[Key.insert.rawValue] = KeyData(packet: 5, offset: 0x0F)
        mapping[Key.delete.rawValue] = KeyData(packet: 5, offset: 0x12)
        mapping[Key.leftArrow.rawValue] = KeyData(packet: 5, offset: 0x1B)
        mapping[Key.scroll.rawValue] = KeyData(packet: 5, offset: 0x1E)
        mapping[Key.home.rawValue] = KeyData(packet: 5, offset: 0x21)
        mapping[Key.end.rawValue] = KeyData(packet: 5, offset: 0x24)
        mapping[Key.upArrow.rawValue] = KeyData(packet: 5, offset: 0x2A)
        mapping[Key.downArrow.rawValue] = KeyData(packet: 5, offset: 0x2D)
        mapping[Key.pause.rawValue] = KeyData(packet: 5, offset: 0x30)
        mapping[Key.pageUp.rawValue] = KeyData(packet: 5, offset: 0x33)
        mapping[Key.pageDown.rawValue] = KeyData(packet: 5, offset: 0x36)
        mapping[Key.rightArrow.rawValue] = KeyData(packet: 5, offset: 0x3F)
        mapping[Key.numLock.rawValue] = KeyData(packet: 6, offset: 0x09)
        mapping[Key.numpad7.rawValue] = KeyData(packet: 6, offset: 0x0C)
        mapping[Key.numpad4.rawValue] = KeyData(packet: 6, offset: 0x0F)
        mapping[Key.numpad1.rawValue] = KeyData(packet: 6, offset: 0x12)
        mapping[Key.numpadSlash.rawValue] = KeyData(packet: 6, offset: 0x1B)
        mapping[Key.numpad8.rawValue] = KeyData(packet: 6, offset: 0x1E)
        mapping[Key.numpad5.rawValue] = KeyData(packet: 6, offset: 0x21)
        mapping[Key.numpad2.rawValue] = KeyData(packet: 6, offset: 0x24)
        mapping[Key.numpad0.rawValue] = KeyData(packet: 6, offset: 0x27)
        mapping[Key.numpadAsterisk.rawValue] = KeyData(packet: 6, offset: 0x2D)
        mapping[Key.numpad9.rawValue] = KeyData(packet: 6, offset: 0x30)
        mapping[Key.numpad6.rawValue] = KeyData(packet: 6, offset: 0x33)
        mapping[Key.numpad3.rawValue] = KeyData(packet: 6, offset: 0x36)
        mapping[Key.numpadPoint.rawValue] = KeyData(packet: 6, offset: 0x39)
        mapping[Key.numpadMinus.rawValue] = KeyData(packet: 6, offset: 0x3F)
        mapping[Key.numpadPlus.rawValue] = KeyData(packet: 7, offset: 0x06)
        mapping[Key.numpadEnter.rawValue] = KeyData(packet: 7, offset: 0x0C)
    }

    func color(key: Key) -> RGBColor {
        return mapping[key.rawValue].color
    }

    func setColor(key: Key, color: RGBColor) {
        mapping[key.rawValue].color = color
    }

    func packet(key: Key) -> Int {
        return mapping[key.rawValue].packet
    }

    func offset(key: Key) -> Int {
        return mapping[key.rawValue].offset
    }

    func keys(packet: Int) -> [Key] {
        var list = [Key]()
        Key.allCases.forEach { (key) in
            if mapping[key.rawValue].packet == packet {
                list.append(key)
            }
        }
        return list
    }

    func key(packet: Int, offset: Int) -> Key? {
        var retval: Key?
        Key.allCases.forEach { (key) in
            let data = mapping[key.rawValue]
            if data.packet == packet && data.offset == offset {
                return retval = key
            }
        }
        return retval
    }
}
