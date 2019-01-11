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
