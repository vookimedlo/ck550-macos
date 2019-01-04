//
//  EffectCustomizationPreferenceViewController.swift
//  ck550
//
//  Created by Michal Duda on 01/01/2019.
//  Copyright © 2019 Michal Duda. All rights reserved.
//

import Foundation
import Cocoa
import SwiftyJSON

// swiftlint:disable type_name
class EffectCustomizationPreferenceViewController: NSViewController, PreferenceViewController {
// swiftlint:enable type_name
    @IBOutlet weak var loadedFileTextField: NSTextField!
    @IBOutlet weak var saveFileButton: NSButton!
    @IBOutlet weak var keyboardGridView: NSGridView!

    let openPanel = NSOpenPanel()
    let savePanel = NSSavePanel()

    var keyboardButtons: [CK550OffEffectCustomizationLayoutUS.KeyUS: NSButton] = [:]
    var internalSettings: JSON = [:]

    var settings: JSON {
        get {
            internalSettings = jsonData()
            return internalSettings
        }
        set(newValue) {
            logDebug("customization settings")
            internalSettings = newValue
            if internalSettings.count > 0 {
                internalSettings.forEach { (arg) in
                    let (jsonKey, jsonValue) = arg
                    if let key = JSONCustomizationEffectUSLayout.jsonCustomizationDecode[jsonKey] {
                        keyboardButtons[key]?.setTextColor(NSColor(RGBColor(json: jsonValue)))
                    }
                }
            } else {
                keyboardButtons.values.forEach { button in
                    resetKeyboardButtonColor(button)
                }
            }
        }
    }

    private func jsonData() -> JSON {
        var data: JSON = [:]
        keyboardButtons.forEach { (arg) in
            let (key, button) = arg
            if let jsonKey = JSONCustomizationEffectUSLayout.jsonCustomEncode[key] {
                data[jsonKey] = RGBColor(button.getTextColor()).json
            }
        }
        return data
    }

    private func resetKeyboardButtonColor(_ button: NSButton) {
        button.layer?.backgroundColor = NSColor.gray.cgColor
        button.setTextColor(NSColor(RGBColor()))
    }

    func setup() {
        logDebug("customization setup")

        openPanel.title = "Import a custumization effect data"
        openPanel.message = "Select a customization effect data to import ..."
        openPanel.allowedFileTypes = ["public.json"]

        savePanel.title = "Export a custumization effect data"
        savePanel.message = "Select a file to export a customization effect data ..."
        savePanel.allowedFileTypes = ["public.json"]
        savePanel.isExtensionHidden = false
        savePanel.canSelectHiddenExtension = true
        savePanel.showsTagField = false

        for rowId in 0...(keyboardGridView.numberOfRows - 1) {
            for columnId in 0...(keyboardGridView.numberOfColumns - 1) {
                let cell = keyboardGridView.cell(atColumnIndex: columnId,
                                                 rowIndex: rowId)
                if let view = cell.contentView {
                    if let button = view as? NSButton {
                        button.wantsLayer = true
                        resetKeyboardButtonColor(button)

                        if let key = CK550OffEffectCustomizationLayoutUS.KeyUS.init(rawValue: view.tag) {
                            keyboardButtons[key] = button
                            button.target = self
                            button.action = #selector(keyboardButtonAction(_:))
                        }
                    }
                }
            }
        }
    }

    func deactivated() {
        NSColorPanel.shared.orderOut(nil)

        keyboardButtons.values.forEach { button in
            button.target = nil
            button.action = nil
        }

        keyboardButtons = [:]
    }

    @objc func keyboardButtonAction(_ sender: NSButton) {
        NSColorPanel.shared.mode = .RGB
        NSColorPanel.shared.colorSpace = NSColorSpace.genericRGB
        NSColorPanel.shared.setTarget(sender)
        NSColorPanel.shared.setAction(#selector(NSButton.textColorChangedAction(_:)))
        NSColorPanel.shared.color = sender.getTextColor()
        NSColorPanel.shared.orderFrontRegardless()
    }

    @objc func allColorsChangedAction(_ sender: NSColorPanel) {
        keyboardButtons.values.forEach { button in
            button.setTextColor(sender.color)
        }
    }

    @IBAction func loadFileAction(_ sender: NSButton) {
        var userInfoBuilder = UserInfo()
        userInfoBuilder[.isSelected] = false

        let userChoice = openPanel.runModal()

        switch userChoice {
        case .OK:
            logDebug("file selected %@", openPanel.url?.absoluteString ?? "")
            if let url = openPanel.url {
                userInfoBuilder[.isSelected] = true
                userInfoBuilder[.customizationFile] = url
            }
        default:
            logDebug("open dialog cancelled")
        }

        let notification = Notification(name: .CustomFileLoaded,
                                        object: self,
                                        userInfo: userInfoBuilder.userInfo)
        NotificationCenter.default.post(notification)
    }

    @IBAction func saveFileAction(_ sender: NSButton) {
        logDebug("Export button")

        let userChoice = savePanel.runModal()
        switch userChoice {
        case .OK:
            logDebug("file selected %@", savePanel.url?.absoluteString ?? "")
            if let url = savePanel.url {
                let json: JSON = [AppPreferences.Preferences.effect.rawValue: [Effect.customization.rawValue: jsonData()]]
                let jsonString = json.rawString(.utf8,
                                                options: [.prettyPrinted, .sortedKeys]) ?? ""
                do {
                    try jsonString.write(to: url,
                                         atomically: true,
                                         encoding: .utf8)
                } catch {
                    logError("Cannot write a customization file")
                }
            }
        default:
            logDebug("save dialog cancelled")
        }
    }

    @IBAction func clearColorsAction(_ sender: NSButton) {
        keyboardButtons.values.forEach { button in
            resetKeyboardButtonColor(button)
        }
    }

    @IBAction func setAllColorsAction(_ sender: NSButton) {
        NSColorPanel.shared.mode = .RGB
        NSColorPanel.shared.colorSpace = NSColorSpace.genericRGB
        NSColorPanel.shared.setTarget(self)
        NSColorPanel.shared.setAction(#selector(allColorsChangedAction(_:)))
        NSColorPanel.shared.orderFrontRegardless()
    }
}
