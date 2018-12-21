//
//  PreferencesViewController.swift
//  ck550
//
//  Created by Michal Duda on 22/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Cocoa

class PreferencesViewController: NSViewController, NSOutlineViewDelegate, NSOutlineViewDataSource {
    @IBOutlet weak var listView: NSOutlineView!
    @IBOutlet weak var headerView: NSView!
    @IBOutlet weak var mainView: NSView!
    @IBOutlet weak var footerView: NSView!
    @IBOutlet weak var headerTitleTextField: NSTextField!
 
    static private var effectPreferences = EffectPreferences(name: "Effects")
    static private var allPreferences = [effectPreferences]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.wantsLayer = true
        footerView.wantsLayer = true
        
        Effect.allCases.forEach() { effect in
            let preference = EffectPreference(effect: effect)
            PreferencesViewController.effectPreferences.preferences.append(preference)
        }
        
        self.listView.expandItem(nil, expandChildren: true)
    }
    
    override func viewWillAppear() {
        headerView.layer?.backgroundColor = NSColor.black.cgColor
        headerView.layer?.borderColor = NSColor.red.cgColor
        headerView.addBottomBorder(color: NSColor.white, width: 2)
        headerTitleTextField.textColor = NSColor.white
        footerView.addTopBorder(color: NSColor.white, width: 2)
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor viewForTableColumn: NSTableColumn?, item: Any) -> NSView? {
        switch item {
        case let preferences as EffectPreferences:
            let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeaderCell"), owner: self) as! NSTableCellView
            if let textField = view.textField {
                textField.stringValue = preferences.name
            }
            return view
        case let preference as EffectPreference:
            let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DataCell"), owner: self) as! NSTableCellView
            if let textField = view.textField {
                textField.stringValue = preference.name
            }
            if let image = preference.icon {
                view.imageView!.image = image
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
    
    func outlineViewSelectionDidChange(_ notification: Notification){
        let listView = notification.object as! NSOutlineView
        let selectedIndex = listView.selectedRow
        let object: AnyObject? = listView.item(atRow: selectedIndex) as AnyObject
        
        switch object {
        case _ as EffectPreferences:
            headerTitleTextField.stringValue = "Effect Preferences"
        case let
            effectPreference as EffectPreference:
            headerTitleTextField.stringValue = effectPreference.name
        default:
            headerTitleTextField.stringValue = "Preferences"
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
    
    @IBAction func closeAction(_ sender: NSButton) {
        self.view.window?.performClose(self)
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
    
    init (effect: Effect, icon: NSImage? = nil){
        self.effect = effect
        self.name = effect.name()
        self.icon = icon
    }
}
