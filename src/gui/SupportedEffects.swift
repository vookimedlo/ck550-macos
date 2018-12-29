//
//  SupportedEffects.swift
//  ck550
//
//  Created by Michal Duda on 20/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

/// Available effects in GUI.
/// - Important:
/// RawValues cannot be changed anymore once declared, thus they are suitable for configuration files
enum Effect: String, CaseIterable {
    case staticKeys = "Static"
    case wave = "Wave"
    case crossMode = "Cross Mode"
    case singleKey = "Single Key"
    case customization = "Customization"
    case star = "Star"
    case colorCycle = "Color Cycle"
    case breathing = "Breathing"
    case ripple = "Ripple"
    case snowing = "Snowing"
    case reactivePunch = "Reactive Punch"
    case heartbeat = "Heartbeat"
    case fireball = "Fireball"
    case circleSpectrum = "Circle Spectrum"
    case reactiveTornado = "Reactive Tornado"
    case waterRipple = "Water Ripple"
    case off = "Off"

    /// Strings for displaying in GUI
    var name: String {
        switch self {
        case .staticKeys: return "Static"
        case .wave: return "Wave"
        case .crossMode: return "Cross Mode"
        case .singleKey: return "Single Key"
        case .customization: return "Customization"
        case .star: return "Star"
        case .colorCycle: return "Color Cycle"
        case .breathing: return "Breathing"
        case .ripple: return "Ripple"
        case .snowing: return "Snowing"
        case .reactivePunch: return "Reactive Punch"
        case .heartbeat: return "Heartbeat"
        case .fireball: return "Fireball"
        case .circleSpectrum: return "Circle Spectrum"
        case .reactiveTornado: return "Reactive Tornado"
        case .waterRipple: return "Water Ripple"
        case .off: return "Off"
        }
    }
}
