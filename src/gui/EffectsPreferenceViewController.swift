//
//  EffectsPreferenceViewController.swift
//  ck550
//
//  Created by Michal Duda on 26/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Cocoa
import SwiftyJSON

class EffectsPreferenceViewController: NSViewController, PreferenceViewController {
    var settings: JSON {
        get {
            return [:]
        }
        set {

        }
    }

    func setup() {
        // No implementation, because no preferences are not available for given effect
    }

    func deactivated() {
        // No implementation, because no preferences are not available for given effect
    }

    @IBAction func restoreDefaultEffectsSettingsAction(_ sender: NSButton) {
        let notification = Notification(name: .CustomEffectDefaultConfiguration, object: self, userInfo: nil)
        NotificationCenter.default.post(notification)
    }
}
