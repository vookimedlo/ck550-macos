//
//  ComponentsLicenseWindowController.swift
//  ck550
//
//  Created by Michal Duda on 10/01/2019.
//  Copyright © 2019 Michal Duda. All rights reserved.
//

import Foundation
import Cocoa

class ComponentsLicenseWindowController: NSWindowController {
    @IBOutlet var licenseTextView: NSTextView!
    @objc dynamic private var contentData: Data?
    let asset = NSDataAsset(name: "COMPONENTS", bundle: Bundle.main)

    override func windowDidLoad() {
        super.windowDidLoad()
        contentData = asset?.data
    }
}
