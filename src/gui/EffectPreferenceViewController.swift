//
//  EffectPreferenceViewController.swift
//  ck550
//
//  Created by Michal Duda on 23/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Cocoa
import SwiftyJSON

protocol PreferenceViewController {
    var view: NSView {get set}
    var settings: JSON {get set}
    func setup()
    func deactivated()
}

class EffectPreferenceViewController: NSViewController, PreferenceViewController {
    @IBOutlet weak var speedTextField: NSTextField!
    @IBOutlet weak var speedComboBox: NSComboBox!
    @IBOutlet weak var randomColorButton: NSButton!
    @IBOutlet weak var colorTextField: NSTextField!
    @IBOutlet weak var backgroundColorTextField: NSTextField!
    @IBOutlet weak var directionTextField: NSTextField!
    @IBOutlet weak var directionComboBox: NSComboBox!
    @IBOutlet weak var colorButton: ColorButton!
    @IBOutlet weak var backgroundColorButton: ColorButton!

    var settings: JSON {
        get {
            return [AppPreferences.EffectKeys.backgroundColor.rawValue: RGBColor(backgroundColorButton.color).json,
                    AppPreferences.EffectKeys.color.rawValue: RGBColor(colorButton.color).json,
                    AppPreferences.EffectKeys.isColorRandom.rawValue: randomColorButton.state == .on,
                    AppPreferences.EffectKeys.speed.rawValue: speedComboBox.indexOfSelectedItem,
                    AppPreferences.EffectKeys.direction.rawValue: directionComboBox.indexOfSelectedItem]
        }
        set(json) {
            randomColorButton.state = json[AppPreferences.EffectKeys.isColorRandom.rawValue].boolValue ? .on : .off
            speedComboBox.selectItem(at: json[AppPreferences.EffectKeys.speed.rawValue].int ?? -1)
            colorButton.color = NSColor(RGBColor(json: json[AppPreferences.EffectKeys.color.rawValue]))
            backgroundColorButton.color = NSColor(RGBColor(json: json[AppPreferences.EffectKeys.backgroundColor.rawValue]))

            let directionIndex = json[AppPreferences.EffectKeys.direction.rawValue].int ?? -1
            if directionIndex > -1 {
                directionComboBox.selectItem(at: directionIndex)
            }

            setup()
        }
    }

    func setup() {
        if speedComboBox.indexOfSelectedItem == -1 {
            speedComboBox.selectItem(at: 2)
        }

        colorButton.isEnabled = !(randomColorButton.state == .on)
    }

    func adjustView(showColor: Bool = true,
                    showRandom: Bool = true,
                    showBackgroundColor: Bool = true,
                    showSpeed: Bool = true,
                    showDirection: Bool = false) {

        colorTextField.isHidden = !showColor
        colorButton.isHidden = !showColor
        randomColorButton.isHidden = !showRandom
        backgroundColorTextField.isHidden = !showBackgroundColor
        backgroundColorButton.isHidden = !showBackgroundColor
        speedTextField.isHidden = !showSpeed
        speedComboBox.isHidden = !showSpeed
        directionTextField.isHidden = !showDirection
        directionComboBox.isHidden = !showDirection
    }

    func setupDirectionComboBox(item: String) {
        directionComboBox.addItem(withObjectValue: item)
        directionComboBox.selectItem(at: 0)
    }

    func deactivated() {
        // Nothing for these types of effect settings
    }

    @IBAction func randomColorAction(_ sender: NSButton) {
        colorButton.isEnabled = !(sender.state == .on)
    }
}
