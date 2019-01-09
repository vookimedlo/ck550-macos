//
//  ReleaseNotesWindowController.swift
//  ck550
//
//  Created by Michal Duda on 19/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Cocoa

class ReleaseNotesWindowController: NSWindowController {
    @IBOutlet var releaseNotesTextView: NSTextView!
    @objc dynamic private var contentData: Data?
    let asset = NSDataAsset(name: "changelog", bundle: Bundle.main)

    override func windowDidLoad() {
        super.windowDidLoad()
        contentData = asset?.data
    }
}
