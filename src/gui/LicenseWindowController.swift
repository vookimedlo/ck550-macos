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
    @objc dynamic private var contentData: Data?
    let asset = NSDataAsset(name: "LICENSE", bundle: Bundle.main)

    override func windowDidLoad() {
        super.windowDidLoad()
        contentData = asset?.data
    }
}
