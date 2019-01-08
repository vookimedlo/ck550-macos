//
//  ColorPopover.swift
//  ck550
//
//  Created by Michal Duda on 07/01/2019.
//  Copyright © 2019 Michal Duda. All rights reserved.
//

import Foundation
import Cocoa

class ColorPopover: NSViewController {
    let colorPanel = NSColorPanel()
    let popover = NSPopover()

    var mode: NSColorPanel.Mode {
        get { return self.colorPanel.mode }
        set { self.colorPanel.mode = newValue }
    }

    var colorSpace: NSColorSpace? {
        get { return self.colorPanel.colorSpace }
        set { self.colorPanel.colorSpace = newValue }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    deinit {
        view.willRemoveSubview(colorPanel.contentView!)
    }

    private func setup() {
        view = NSView(frame: colorPanel.contentView!.frame)
        popover.contentViewController = self
        popover.contentSize = view.frame.size
        popover.behavior = .transient
        popover.animates = true

        colorPanel.mode = .RGB
        colorPanel.colorSpace = .genericRGB
    }

    override func viewWillAppear() {
        view.addSubview(colorPanel.contentView!)
    }

    override func viewDidDisappear() {
        view.willRemoveSubview(colorPanel.contentView!)
    }

    func setAction(target: Any?, selector: Selector?) {
        colorPanel.setTarget(target)
        colorPanel.setAction(selector)
    }

    func show(parent: NSView, initialColor: NSColor? = nil) {
        if let color = initialColor {
            colorPanel.color = color
        }
        popover.show(relativeTo: parent.bounds, of: parent, preferredEdge: NSRectEdge.maxY)
    }
}
