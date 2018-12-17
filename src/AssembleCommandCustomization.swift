//
//  AssembleCommandCustomization.swift
//  ck550-cli
//
//  Created by Michal Duda on 09/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import SwiftyJSON

private let jsonCustomizationDecode: [String: CK550OffEffectCustomizationLayoutUS.KeyUS] = [
    "Escape": .escape,
    "F1": .f1,
    "F2": .f2,
    "F3": .f3,
    "F4": .f4,
    "F5": .f5,
    "F6": .f6,
    "F7": .f7,
    "F8": .f8,
    "F9": .f9,
    "F10": .f10,
    "F11": .f11,
    "F12": .f12,
    "Print": .print,
    "Scroll": .scroll,
    "Pause": .pause,
    "BackQuote": .backQuote,
    "Numeric1": .numeric1,
    "Numeric2": .numeric2,
    "Numeric3": .numeric3,
    "Numeric4": .numeric4,
    "Numeric5": .numeric5,
    "Numeric6": .numeric6,
    "Numeric7": .numeric7,
    "Numeric8": .numeric8,
    "Numeric9": .numeric9,
    "Numeric0": .numeric0,
    "Minus": .minus,
    "Equal": .equal,
    "Backspace": .backspace,
    "Tab": .tab,
    "Q": .q,
    "W": .w,
    "E": .e,
    "R": .r,
    "T": .t,
    "Y": .y,
    "U": .u,
    "I": .i,
    "O": .o,
    "P": .p,
    "LeftSquareBracket": .leftSquareBracket,
    "RightSquareBracket": .rightSquareBracket,
    "Backslash": .backslash,
    "Capslock": .capslock,
    "A": .a,
    "S": .s,
    "D": .d,
    "F": .f,
    "G": .g,
    "H": .h,
    "J": .j,
    "K": .k,
    "L": .l,
    "Semicolon": .semicolon,
    "Apostrophe": .apostrophe,
    "Enter": .enter,
    "LeftShift": .leftShift,
    "Z": .z,
    "X": .x,
    "C": .c,
    "V": .v,
    "B": .b,
    "N": .n,
    "M": .m,
    "Comma": .comma,
    "Point": .point,
    "Slash": .slash,
    "RightShift": .rightShift,
    "LeftCtrl": .leftCtrl,
    "LeftWin": .leftWin,
    "LeftAlt": .leftAlt,
    "Space": .space,
    "RightAlt": .rightAlt,
    "RightWin": .rightWin,
    "Function": .function,
    "RightCtrl": .rightCtrl,
    "LeftArrow": .leftArrow,
    "RightArrow": .rightArrow,
    "UpArrow": .upArrow,
    "DownArrow": .downArrow,
    "Insert": .insert,
    "Delete": .delete,
    "PageUp": .pageUp,
    "PageDown": .pageDown,
    "Home": .home,
    "End": .end,
    "NumLock": .numLock,
    "NumpadSlash": .numpadSlash,
    "NumpadAsterisk": .numpadAsterisk,
    "NumpadMinus": .numpadMinus,
    "Numpad0": .numpad0,
    "Numpad1": .numpad1,
    "Numpad2": .numpad2,
    "Numpad3": .numpad3,
    "Numpad4": .numpad4,
    "Numpad5": .numpad5,
    "Numpad6": .numpad6,
    "Numpad7": .numpad7,
    "Numpad8": .numpad8,
    "Numpad9": .numpad9,
    "NumpadEnter": .numpadEnter,
    "NumpadPlus": .numpadPlus,
    "NumpadPoint": .numpadPoint]

private let jsonCustomEncode: [CK550OffEffectCustomizationLayoutUS.KeyUS: String] = [
    .escape: "Escape",
    .f1: "F1",
    .f2: "F2",
    .f3: "F3",
    .f4: "F4",
    .f5: "F5",
    .f6: "F6",
    .f7: "F7",
    .f8: "F8",
    .f9: "F9",
    .f10: "F10",
    .f11: "F11",
    .f12: "F12",
    .print: "Print",
    .scroll: "Scroll",
    .pause: "Pause",
    .backQuote: "BackQuote",
    .numeric1: "Numeric1",
    .numeric2: "Numeric2",
    .numeric3: "Numeric3",
    .numeric4: "Numeric4",
    .numeric5: "Numeric5",
    .numeric6: "Numeric6",
    .numeric7: "Numeric7",
    .numeric8: "Numeric8",
    .numeric9: "Numeric9",
    .numeric0: "Numeric0",
    .minus: "Minus",
    .equal: "Equal",
    .backspace: "Backspace",
    .tab: "Tab",
    .q: "Q",
    .w: "W",
    .e: "E",
    .r: "R",
    .t: "T",
    .y: "Y",
    .u: "U",
    .i: "I",
    .o: "O",
    .p: "P",
    .leftSquareBracket: "LeftSquareBracket",
    .rightSquareBracket: "RightSquareBracket",
    .backslash: "Backslash",
    .capslock: "Capslock",
    .a: "A",
    .s: "S",
    .d: "D",
    .f: "F",
    .g: "G",
    .h: "H",
    .j: "J",
    .k: "K",
    .l: "L",
    .semicolon: "Semicolon",
    .apostrophe: "Apostrophe",
    .enter: "Enter",
    .leftShift: "LeftShift",
    .z: "Z",
    .x: "X",
    .c: "C",
    .v: "V",
    .b: "B",
    .n: "N",
    .m: "M",
    .comma: "Comma",
    .point: "Point",
    .slash: "Slash",
    .rightShift: "RightShift",
    .leftCtrl: "LeftCtrl",
    .leftWin: "LeftWin",
    .leftAlt: "LeftAlt",
    .space: "Space",
    .rightAlt: "RightAlt",
    .rightWin: "RightWin",
    .function: "Function",
    .rightCtrl: "RightCtrl",
    .leftArrow: "LeftArrow",
    .rightArrow: "RightArrow",
    .upArrow: "UpArrow",
    .downArrow: "DownArrow",
    .insert: "Insert",
    .delete: "Delete",
    .pageUp: "PageUp",
    .pageDown: "PageDown",
    .home: "Home",
    .end: "End",
    .numLock: "NumLock",
    .numpadSlash: "NumpadSlash",
    .numpadAsterisk: "NumpadAsterisk",
    .numpadMinus: "NumpadMinus",
    .numpad0: "Numpad0",
    .numpad1: "Numpad1",
    .numpad2: "Numpad2",
    .numpad3: "Numpad3",
    .numpad4: "Numpad4",
    .numpad5: "Numpad5",
    .numpad6: "Numpad6",
    .numpad7: "Numpad7",
    .numpad8: "Numpad8",
    .numpad9: "Numpad9",
    .numpadEnter: "NumpadEnter",
    .numpadPlus: "NumpadPlus",
    .numpadPoint: "NumpadPoint"]

extension AssembleCommand {
    static func assembleCommandCustomization(configPath: String) throws -> CK550HIDCommand {
        guard let jsonString = try? String(contentsOfFile: configPath, encoding: String.Encoding.utf8) else {
            throw AssembleError.fileReadFailure(path: configPath)
        }

        let json = JSON(parseJSON: jsonString)
        if let error = json.error {
            switch error {
            case .invalidJSON:
                throw AssembleError.invalidFormatJSON
            default:
                throw AssembleError.unknownError
            }
        }

        let command = CK550HIDCommand()

        // Changing the color of keys in Off effect
        let layout = CK550OffEffectCustomizationLayoutUS()
        let custom = CK550Command.OffEffectOverride.CK550OffEffectCustomizationKeys(layout: layout)

        if let jsonEffectCustomization = json["effect"]["customization"].dictionary {
            for key in jsonCustomizationDecode.keys {
                let red = jsonEffectCustomization[key]?["red"].uInt ?? 0
                let green = jsonEffectCustomization[key]?["green"].uInt ?? 0
                let blue = jsonEffectCustomization[key]?["blue"].uInt ?? 0

                if red <= 0xFF && green <= 0xFF && blue <= 0xFF {
                    // use color only if its value is valid in #XXYYZZ format
                    layout.setColor(key: jsonCustomizationDecode[key]!, color: RGBColor(red: UInt16(red), green: UInt16(green), blue: UInt16(blue)))
                }
            }
        }

        command.addOutgoingMessage(CK550Command.setEffectControl)
        command.addOutgoingMessage(CK550Command.setEffect(effectId: .off))
        command.addOutgoingMessage(CK550Command.enableOffEffectModification)
        command.addOutgoingMessage(CK550Command.OffEffectOverride.Customization.setEffectUNKNOWN_BEFORE_PACKETS)

        let packets = custom.packets()
        for packet in packets {
            command.addOutgoingMessage(packet)
        }

        command.addOutgoingMessage(CK550Command.setEffect(effectId: .off))
        command.addOutgoingMessage(CK550Command.OffEffectOverride.Customization.setEffectUNKNOWN_AFTER_PACKETS)

        /*
         // Writes the color of keys in Off effect to flash
         _ = hidDevice.write(command: CK550Command.setProfileControl)
         _ = hidDevice.write(command: CK550Command.setEffectControl)
         _ = hidDevice.write(command: CK550Command.saveCurrentProfile)
         _ = hidDevice.write(command: CK550Command.setFirmwareControl)
         */

        //_ = hidDevice.write(command: CK550Command.setEffectControl)
        //_ = hidDevice.write(command: CK550Command.setActiveProfile(profileId: 4))
        //_ = hidDevice.write(command: CK550Command.setEffect(effectId: .Off))

        command.addOutgoingMessage(CK550Command.setFirmwareControl)

        return command
    }
}
