//
//  LicenseWindowController.swift
//  ck550
//
//  Created by Michal Duda on 19/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Cocoa

class LicenseWindowController: NSWindowController {
    @IBOutlet var licenseTextView: NSTextView!
    @objc dynamic private var contentURL: URL?

    override func windowDidLoad() {
        super.windowDidLoad()
        // TODO: decide what license will be used and load a license file from resources
        // contentURL = Bundle.main.url(forResource: "TODO", withExtension: "rtf")
    }
}
