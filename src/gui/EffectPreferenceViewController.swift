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
    @IBOutlet weak var colorWell: NSColorWell!
    @IBOutlet weak var backgroundColorTextField: NSTextField!
    @IBOutlet weak var backgroundColorWell: NSColorWell!
    @IBOutlet weak var directionTextField: NSTextField!
    @IBOutlet weak var directionComboBox: NSComboBox!

    private enum JSONKeys: String {
        case backgroundColor, color, isColorRandom, speed, direction
    }

    var settings: JSON {
        get {
            return [JSONKeys.backgroundColor.rawValue: RGBColor((backgroundColorWell?.color)!).json,
                    JSONKeys.color.rawValue: RGBColor((colorWell?.color)!).json,
                    JSONKeys.isColorRandom.rawValue: randomColorButton.state == .on,
                    JSONKeys.speed.rawValue: speedComboBox.indexOfSelectedItem,
                    JSONKeys.direction.rawValue: directionComboBox.indexOfSelectedItem]
        }
        set(json) {
            randomColorButton.state = json[JSONKeys.isColorRandom.rawValue].boolValue ? .on : .off
            speedComboBox.selectItem(at: json[JSONKeys.speed.rawValue].int ?? -1)
            colorWell.color = NSColor(RGBColor(json: json[JSONKeys.color.rawValue]))
            backgroundColorWell.color = NSColor(RGBColor(json: json[JSONKeys.backgroundColor.rawValue]))

            let directionIndex = json[JSONKeys.direction.rawValue].int ?? -1
            if directionIndex > -1 {
                directionComboBox.selectItem(at: directionIndex)
            }
        }
    }

    func setup() {
        if speedComboBox.indexOfSelectedItem == -1 {
            speedComboBox.selectItem(at: 2)
        }

        colorWell.isEnabled = !(randomColorButton.state == .on)
    }

    func adjustView(showColor: Bool = true,
                    showRandom: Bool = true,
                    showBackgroundColor: Bool = true,
                    showSpeed: Bool = true,
                    showDirection: Bool = false) {
        colorTextField.isHidden = !showColor
        colorWell.isHidden = !showColor
        randomColorButton.isHidden = !showRandom
        backgroundColorTextField.isHidden = !showBackgroundColor
        backgroundColorWell.isHidden = !showBackgroundColor
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
        NSColorPanel.shared.orderOut(nil)
    }

    @IBAction func colorWellAction(_ sender: NSColorWell) {

    }

    @IBAction func randomColorAction(_ sender: NSButton) {
        colorWell.isEnabled = !(sender.state == .on)
    }
}
