//
//  PreferencesViewControllerOutline.swift
//  ck550
//
//  Created by Michal Duda on 24/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

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
        Effect.allCases.forEach() { effect in
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
                let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeaderCell"), owner: self) as! NSTableCellView
                if let textField = view.textField {
                    textField.stringValue = preferences.name
                }
                effectListViewContainer = view
                return view
            }
            return view
        case let preference as EffectPreference:
            guard let view = effectListViewItems[preference.effect] else {
                let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DataCell"), owner: self) as! NSTableCellView
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

    func outlineViewSelectionDidChange(_ notification: Notification){
        let listView = notification.object as! NSOutlineView
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

fileprivate class EffectPreferences: NSObject {
    let name: String
    var preferences: [EffectPreference] = [EffectPreference]()
    let icon: NSImage?

    init (name:String, icon:NSImage? = nil){
        self.name = name
        self.icon = icon
    }
}

fileprivate class EffectPreference: NSObject {
    var name: String
    var effect: Effect
    let icon: NSImage?

    init (effect: Effect, icon: NSImage? = nil) {
        self.effect = effect
        self.name = effect.name()
        self.icon = icon
    }
}
