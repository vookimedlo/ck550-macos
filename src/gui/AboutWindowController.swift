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
    private var licenseWindowController: LicenseWindowController?
    private var releaseNotesWindowController: ReleaseNotesWindowController?

    func windowWillClose(_ notification: Notification) {
        licenseWindowController?.window?.close()
        releaseNotesWindowController?.window?.close()
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        let bundleVersion = Bundle.bundleVersion()
        versionTextField.stringValue = "Version \(bundleVersion.version) build \(bundleVersion.build)"
    }

    @objc private func windowWillClose(notification: Notification) {
        guard let object = notification.object as? NSWindow else { return }
        NotificationCenter.default.removeObserver(self, name: NSWindow.willCloseNotification, object: object)
        if object.isEqual(licenseWindowController?.window) {
            licenseWindowController = nil
        }
        if object.isEqual(releaseNotesWindowController?.window) {
            releaseNotesWindowController = nil
        }
    }

    @IBAction func licenseAction(_ sender: NSButton) {
        guard licenseWindowController == nil else {
            licenseWindowController?.window?.orderFrontRegardless()
            return
        }
        licenseWindowController = LicenseWindowController(windowNibName: NSNib.Name("LicenseWindow"))
        NotificationCenter.default.addObserver(self, selector: #selector(windowWillClose(notification:)), name: NSWindow.willCloseNotification, object: licenseWindowController?.window)
        licenseWindowController?.window?.orderFrontRegardless()
    }

    @IBAction func releaseNotesAction(_ sender: NSButton) {
        guard releaseNotesWindowController == nil else {
            releaseNotesWindowController?.window?.orderFrontRegardless()
            return
        }
        releaseNotesWindowController = ReleaseNotesWindowController(windowNibName: NSNib.Name("ReleaseNotesWindow"))
        NotificationCenter.default.addObserver(self, selector: #selector(windowWillClose(notification:)), name: NSWindow.willCloseNotification, object: releaseNotesWindowController?.window)
        releaseNotesWindowController?.window?.orderFrontRegardless()
    }
}
