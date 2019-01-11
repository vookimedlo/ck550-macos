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

protocol PreferencesViewControllerOutline {
    init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?)
    func preferenceSelected(effect: Effect)
    func preferenceSelected()
    func preferenceNotSelected()
}

extension PreferencesViewController: NSOutlineViewDelegate, NSOutlineViewDataSource, PreferencesViewControllerOutline {
    static private var effectPreferences: EffectPreferences = {
        let effectPreferences = EffectPreferences(name: "Effects")
        Effect.allCases.forEach { effect in
            let preference = EffectPreference(effect: effect)
            effectPreferences.preferences.append(preference)
        }
        return effectPreferences
    }()

    static private var allPreferences = [effectPreferences]

    func outlineView(_ outlineView: NSOutlineView, viewFor viewForTableColumn: NSTableColumn?, item: Any) -> NSView? {
        switch item {
        case let preferences as EffectPreferences:
            guard let view = effectListViewContainer else {
                guard let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeaderCell"), owner: self) as? NSTableCellView else {return nil}
                if let textField = view.textField {
                    textField.stringValue = preferences.name
                }
                effectListViewContainer = view
                return view
            }
            return view
        case let preference as EffectPreference:
            guard let view = effectListViewItems[preference.effect] else {
                guard let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DataCell"), owner: self) as? NSTableCellView else {return nil}
                if let textField = view.textField {
                    textField.stringValue = preference.name
                }
                if let image = preference.icon {
                    view.imageView!.image = image
                }
                effectListViewItems[preference.effect] = view
                return view
            }
            return view
        default:
            return nil
        }
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        switch item {
        case _ as EffectPreferences:
            return true
        default:
            return false
        }
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let item: Any = item {
            switch item {
            case let preferences as EffectPreferences:
                return preferences.preferences[index]
            default:
                return self
            }
        } else {
            switch index {
            default:
                return PreferencesViewController.effectPreferences
                /*
                 case 0:
                 return effectPreferences
                 default:
                 return otherPreferences
                 */
            }
        }
    }

    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        switch item {
        case let preferences as EffectPreferences:
            return (preferences.preferences.count > 0) ? true : false
        default:
            return false
        }
    }

    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let item: Any = item {
            switch item {
            case let preferences as EffectPreferences:
                return preferences.preferences.count
            default:
                return 0
            }
        } else {
            return PreferencesViewController.allPreferences.count
        }
    }

    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let listView = notification.object as? NSOutlineView else {return}
        let selectedIndex = listView.selectedRow
        let object: AnyObject? = listView.item(atRow: selectedIndex) as AnyObject
        switch object {
        case _ as EffectPreferences:
            preferenceSelected()
        case let
            effectPreference as EffectPreference:
            preferenceSelected(effect: (effectPreference.effect))
        default:
            preferenceNotSelected()
        }
    }
}

private class EffectPreferences: NSObject {
    let name: String
    var preferences: [EffectPreference] = [EffectPreference]()
    let icon: NSImage?

    init (name: String, icon: NSImage? = nil) {
        self.name = name
        self.icon = icon
    }
}

private class EffectPreference: NSObject {
    var name: String
    var effect: Effect
    let icon: NSImage?

    init (effect: Effect, icon: NSImage? = nil) {
        self.effect = effect
        self.name = effect.name
        self.icon = icon
    }
}
