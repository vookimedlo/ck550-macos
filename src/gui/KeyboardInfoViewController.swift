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
        guard let userInfo = UserInfo(notification: notification,
                                      expected: Notification.Name.CustomKeyboardInfo)
            else {return}
        guard let isPlugged = userInfo[.isPlugged] as? Bool else {return}

        DispatchQueue.main.sync {
            if isPlugged {
                if let fwVersion = userInfo[.fwVersion] as? String {
                    firmwareTextField?.stringValue = fwVersion
                }
                if let product = userInfo[.product] as? String {
                    productTextField?.stringValue = product

                    if let manufacturer = userInfo[.manufacturer] as? String {
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
