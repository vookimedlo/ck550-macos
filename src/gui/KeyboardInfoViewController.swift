//
//  KeyboardInfoViewController.swift
//  ck550
//
//  Created by Michal Duda on 30/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Cocoa

class KeyboardInfoViewController: NSViewController, KeyboardInfoHandler {
    @IBOutlet weak var productTextField: NSTextField!
    @IBOutlet weak var firmwareTextField: NSTextField!

    func keyboardInfo(notification: Notification) {
        guard notification.name == Notification.Name.CustomKeyboardInfo else {return}
        guard let isPlugged = notification.userInfo?["isPlugged"] as? Bool else {return}

        DispatchQueue.main.sync {
            if isPlugged {
                if let fwVersion = notification.userInfo?["fwVersion"] as? String {
                    firmwareTextField?.stringValue = fwVersion
                }
                if let product = notification.userInfo?["product"] as? String {
                    productTextField?.stringValue = product

                    if let manufacturer = notification.userInfo?["manufacturer"] as? String {
                        productTextField?.toolTip = product + " by " + manufacturer
                    }
                }
            } else {
                firmwareTextField?.stringValue = ""
                productTextField?.stringValue = ""
            }
        }
    }
}
