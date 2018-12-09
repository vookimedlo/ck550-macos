//
//  AssembleCommandCustomization.swift
//  ck550-cli
//
//  Created by Michal Duda on 09/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import SwiftyJSON

private let jsonCustomizationDecode: Dictionary<String, CK550OffEffectCustomizationLayoutUS.KeyUS> = [
    "Escape": .Escape,
    "F1": .F1,
    "F2": .F2,
    "F3": .F3,
    "F4": .F4,
    "F5": .F5,
    "F6": .F6,
    "F7": .F7,
    "F8": .F8,
    "F9": .F9,
    "F10": .F10,
    "F11": .F11,
    "F12": .F12,
    "Print": .Print,
    "Scroll": .Scroll,
    "Pause": .Pause,
    "BackQuote": .BackQuote,
    "Numeric1": .Numeric1,
    "Numeric2": .Numeric2,
    "Numeric3": .Numeric3,
    "Numeric4": .Numeric4,
    "Numeric5": .Numeric5,
    "Numeric6": .Numeric6,
    "Numeric7": .Numeric7,
    "Numeric8": .Numeric8,
    "Numeric9": .Numeric9,
    "Numeric0": .Numeric0,
    "Minus": .Minus,
    "Equal": .Equal,
    "Backspace": .Backspace,
    "Tab": .Tab,
    "Q": .Q,
    "W": .W,
    "E": .E,
    "R": .R,
    "T": .T,
    "Y": .Y,
    "U": .U,
    "I": .I,
    "O": .O,
    "P": .P,
    "LeftSquareBracket": .LeftSquareBracket,
    "RightSquareBracket": .RightSquareBracket,
    "Backslash": .Backslash,
    "Capslock": .Capslock,
    "A": .A,
    "S": .S,
    "D": .D,
    "F": .F,
    "G": .G,
    "H": .H,
    "J": .J,
    "K": .K,
    "L": .L,
    "Semicolon": .Semicolon,
    "Apostroph": .Apostroph,
    "Enter": .Enter,
    "LeftShift": .LeftShift,
    "Z": .Z,
    "X": .X,
    "C": .C,
    "V": .V,
    "B": .B,
    "N": .N,
    "M": .M,
    "Comma": .Comma,
    "Point": .Point,
    "Slash": .Slash,
    "RightShift": .RightShift,
    "LeftCtrl": .LeftCtrl,
    "LeftWin": .LeftWin,
    "LeftAlt": .LeftAlt,
    "Space": .Space,
    "RightAlt": .RightAlt,
    "RightWin": .RightWin,
    "Function": .Function,
    "RightCtrl": .RightCtrl,
    "LeftArrow": .LeftArrow,
    "RightArrow": .RightArrow,
    "UpArrow": .UpArrow,
    "DownArrow": .DownArrow,
    "Insert": .Insert,
    "Delete": .Delete,
    "PageUp": .PageUp,
    "PageDown": .PageDown,
    "Home": .Home,
    "End": .End,
    "NumLock": .NumLock,
    "NumpadSlash": .NumpadSlash,
    "NumpadAsterisk": .NumpadAsterisk,
    "NumpadMinus": .NumpadMinus,
    "Numpad0": .Numpad0,
    "Numpad1": .Numpad1,
    "Numpad2": .Numpad2,
    "Numpad3": .Numpad3,
    "Numpad4": .Numpad4,
    "Numpad5": .Numpad5,
    "Numpad6": .Numpad6,
    "Numpad7": .Numpad7,
    "Numpad8": .Numpad8,
    "Numpad9": .Numpad9,
    "NumpadEnter": .NumpadEnter,
    "NumpadPlus": .NumpadPlus,
    "NumpadPoint": .NumpadPoint ]

private let jsonCustomEncode: Dictionary<CK550OffEffectCustomizationLayoutUS.KeyUS, String> = [
    .Escape: "Escape",
    .F1: "F1",
    .F2: "F2",
    .F3: "F3",
    .F4: "F4",
    .F5: "F5",
    .F6: "F6",
    .F7: "F7",
    .F8: "F8",
    .F9: "F9",
    .F10: "F10",
    .F11: "F11",
    .F12: "F12",
    .Print: "Print",
    .Scroll: "Scroll",
    .Pause: "Pause",
    .BackQuote: "BackQuote",
    .Numeric1: "Numeric1",
    .Numeric2: "Numeric2",
    .Numeric3: "Numeric3",
    .Numeric4: "Numeric4",
    .Numeric5: "Numeric5",
    .Numeric6: "Numeric6",
    .Numeric7: "Numeric7",
    .Numeric8: "Numeric8",
    .Numeric9: "Numeric9",
    .Numeric0: "Numeric0",
    .Minus: "Minus",
    .Equal: "Equal",
    .Backspace: "Backspace",
    .Tab: "Tab",
    .Q: "Q",
    .W: "W",
    .E: "E",
    .R: "R",
    .T: "T",
    .Y: "Y",
    .U: "U",
    .I: "I",
    .O: "O",
    .P: "P",
    .LeftSquareBracket: "LeftSquareBracket",
    .RightSquareBracket: "RightSquareBracket",
    .Backslash: "Backslash",
    .Capslock: "Capslock",
    .A: "A",
    .S: "S",
    .D: "D",
    .F: "F",
    .G: "G",
    .H: "H",
    .J: "J",
    .K: "K",
    .L: "L",
    .Semicolon: "Semicolon",
    .Apostroph: "Apostroph",
    .Enter: "Enter",
    .LeftShift: "LeftShift",
    .Z: "Z",
    .X: "X",
    .C: "C",
    .V: "V",
    .B: "B",
    .N: "N",
    .M: "M",
    .Comma: "Comma",
    .Point: "Point",
    .Slash: "Slash",
    .RightShift: "RightShift",
    .LeftCtrl: "LeftCtrl",
    .LeftWin: "LeftWin",
    .LeftAlt: "LeftAlt",
    .Space: "Space",
    .RightAlt: "RightAlt",
    .RightWin: "RightWin",
    .Function: "Function",
    .RightCtrl: "RightCtrl",
    .LeftArrow: "LeftArrow",
    .RightArrow: "RightArrow",
    .UpArrow: "UpArrow",
    .DownArrow: "DownArrow",
    .Insert: "Insert",
    .Delete: "Delete",
    .PageUp: "PageUp",
    .PageDown: "PageDown",
    .Home: "Home",
    .End: "End",
    .NumLock: "NumLock",
    .NumpadSlash: "NumpadSlash",
    .NumpadAsterisk: "NumpadAsterisk",
    .NumpadMinus: "NumpadMinus",
    .Numpad0: "Numpad0",
    .Numpad1: "Numpad1",
    .Numpad2: "Numpad2",
    .Numpad3: "Numpad3",
    .Numpad4: "Numpad4",
    .Numpad5: "Numpad5",
    .Numpad6: "Numpad6",
    .Numpad7: "Numpad7",
    .Numpad8: "Numpad8",
    .Numpad9: "Numpad9",
    .NumpadEnter: "NumpadEnter",
    .NumpadPlus: "NumpadPlus",
    .NumpadPoint: "NumpadPoint" ]

extension AssembleCommand {
    static func assembleCommandCustomization(configPath: String) throws -> CK550HIDCommand {
        guard let jsonString = try? String(contentsOfFile: configPath, encoding: String.Encoding.utf8) else {
            throw AssembleError.FileReadFailure(path: configPath)
        }
        
        let json = JSON(parseJSON: jsonString)
        if let error = json.error {
            switch error {
            case .invalidJSON:
                throw AssembleError.InvalidFormatJSON
            default:
                throw AssembleError.UnknownError
            }
        }

        let command = CK550HIDCommand()
        
        // Changing the color of keys in Off effect
        let layout = CK550OffEffectCustomizationLayoutUS()
        let custom = CK550OffEffectCustomizationKeys(layout: layout)
        
        if let jsonEffectCustomization = json["effect"]["customization"].dictionary {
            for key in jsonCustomizationDecode.keys {
                let red   = jsonEffectCustomization[key]?["red"].uInt ?? 0
                let green = jsonEffectCustomization[key]?["green"].uInt ?? 0
                let blue  = jsonEffectCustomization[key]?["blue"].uInt ?? 0
                
                if red <= 0xFF && green <= 0xFF && blue <= 0xFF {
                    // use color only if its value is valid in #XXYYZZ format
                    layout.setColor(key: jsonCustomizationDecode[key]!, color: RGBColor(red: UInt16(red), green: UInt16(green), blue: UInt16(blue)))
                }
            }
        }

        command.addOutgoingMessage(CK550Command.setEffectControl)
        command.addOutgoingMessage(CK550Command.setEffect(effectId: .Off))
        command.addOutgoingMessage(CK550Command.enableOffEffectModification)
        command.addOutgoingMessage(CK550Command.setOffEffectCustomizationUNKNOWN_BEFORE_PACKETS)
        
        let packets = custom.packets()
        for packet in packets {
            command.addOutgoingMessage(packet)
        }
        
        command.addOutgoingMessage(CK550Command.setEffect(effectId: .Off))
        command.addOutgoingMessage(CK550Command.setOffEffectCustomizationUNKNOWN_AFTER_PACKETS)
        
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
