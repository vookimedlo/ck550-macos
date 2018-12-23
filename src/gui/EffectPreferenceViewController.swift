//
//  EffectPreferenceViewController.swift
//  ck550
//
//  Created by Michal Duda on 23/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Cocoa

protocol PreferenceViewController {
    var view: NSView {get set}
    func setup()
    func deactivated()
}

class EffectPreferenceViewController: NSViewController, PreferenceViewController {
    @IBOutlet weak var speedComboBox: NSComboBox!
    @IBOutlet weak var randomColorButton: NSButton!
    @IBOutlet weak var colorWell: NSColorWell!
    
    func setup() {
        if speedComboBox.indexOfSelectedItem == -1 {
            speedComboBox.selectItem(at: 2)
        }
        
        colorWell.isEnabled = !(randomColorButton.state == .on)
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
