//
//  SupportedEffects.swift
//  ck550
//
//  Created by Michal Duda on 20/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

enum Effect: CaseIterable {
    case staticKeys
    case wave
    case crossMode
    case singleKey
    case customization
    case star
    case colorCycle
    case breathing
    case ripple
    case snowing
    case reactivePunch
    case heartbeat
    case fireball
    case circleSpectrum
    case reactiveTornado
    case waterRipple
    case off

    func name() -> String {
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
