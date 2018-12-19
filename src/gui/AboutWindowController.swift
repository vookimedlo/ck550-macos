//
//  AboutWindowController.swift
//  ck550
//
//  Created by Michal Duda on 19/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Cocoa

class AboutWindowController: NSWindowController, NSWindowDelegate {
    @IBOutlet weak var versionTextField: NSTextField!
    
    func windowWillClose(_ notification: Notification) {
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        let bundleVersion = Bundle.bundleVersion()
        versionTextField.stringValue = "Version \(bundleVersion.version) build \(bundleVersion.build)"
    }

    @objc private func windowWillClose(notification: Notification) {

    }
    
    @IBAction func licenseAction(_ sender: NSButton) {
    }
    
    @IBAction func releaseNotesAction(_ sender: NSButton) {
    }
}
