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
        case .wave: return "Rainbow Wave"
        case .crossMode: return "Crosshair"
        case .singleKey: return "Reactive Fade"
        case .customization: return "Custom"
        case .star: return "Stars"
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
