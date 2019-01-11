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

class AboutWindowController: NSWindowController, NSWindowDelegate {
    @IBOutlet weak var versionTextField: NSTextField!
    @IBOutlet weak var imageView: NSImageView!
    private var componentsLicenseWindowController: ComponentsLicenseWindowController?
    private var licenseWindowController: LicenseWindowController?
    private var releaseNotesWindowController: ReleaseNotesWindowController?

    func windowWillClose(_ notification: Notification) {
        componentsLicenseWindowController?.window?.close()
        licenseWindowController?.window?.close()
        releaseNotesWindowController?.window?.close()
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        let bundleVersion = Bundle.bundleVersion()
        versionTextField.stringValue = "Version \(bundleVersion.version) build \(bundleVersion.build)"
        imageView.image = NSImage(named: "icon")
    }

    @objc private func windowWillClose(notification: Notification) {
        guard let object = notification.object as? NSWindow else { return }
        NotificationCenter.default.removeObserver(self,
                                                  name: NSWindow.willCloseNotification,
                                                  object: object)
        if object.isEqual(componentsLicenseWindowController?.window) {
            componentsLicenseWindowController = nil
        }
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(windowWillClose(notification:)),
                                               name: NSWindow.willCloseNotification,
                                               object: licenseWindowController?.window)
        licenseWindowController?.window?.orderFrontRegardless()
    }

    @IBAction func releaseNotesAction(_ sender: NSButton) {
        guard releaseNotesWindowController == nil else {
            releaseNotesWindowController?.window?.orderFrontRegardless()
            return
        }
        releaseNotesWindowController = ReleaseNotesWindowController(windowNibName: NSNib.Name("ReleaseNotesWindow"))
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(windowWillClose(notification:)),
                                               name: NSWindow.willCloseNotification,
                                               object: releaseNotesWindowController?.window)
        releaseNotesWindowController?.window?.orderFrontRegardless()
    }

    @IBAction func componentsLicenseAction(_ sender: NSButton) {
        guard licenseWindowController == nil else {
            licenseWindowController?.window?.orderFrontRegardless()
            return
        }
        componentsLicenseWindowController = ComponentsLicenseWindowController(windowNibName: NSNib.Name("ComponentsLicenseWindow"))
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(windowWillClose(notification:)),
                                               name: NSWindow.willCloseNotification,
                                               object: componentsLicenseWindowController?.window)
        componentsLicenseWindowController?.window?.orderFrontRegardless()
    }
}
