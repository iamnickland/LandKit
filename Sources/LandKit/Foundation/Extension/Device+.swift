//
//  Device+.swift
//  LandKit
//
//  Created by Anakin on 2024/7/29.
//

import Foundation
 
#if os(watchOS)
    import WatchKit
#else
    import UIKit
#endif

// MARK: - Device

public enum Device {
    case iPodTouch5
    case iPodTouch6
    case iPodTouch7
    case iPhone4
    case iPhone4s
    case iPhone5
    case iPhone5c
    case iPhone5s
    case iPhone6
    case iPhone6Plus
    case iPhone6s
    case iPhone6sPlus
    case iPhone7
    case iPhone7Plus
    case iPhoneSE
    case iPhone8
    case iPhone8Plus
    case iPhoneX
    case iPhoneXS
    case iPhoneXSMax
    case iPhoneXR
    case iPhone11
    case iPhone11Pro
    case iPhone11ProMax
    case iPhoneSE2
    case iPhone12
    case iPhone12Mini
    case iPhone12Pro
    case iPhone12ProMax
    case iPhone13
    case iPhone13Mini
    case iPhone13Pro
    case iPhone13ProMax
    case iPhoneSE3
    case iPhone14
    case iPhone14Plus
    case iPhone14Pro
    case iPhone14ProMax
    case iPhone15
    case iPhone15Plus
    case iPhone15Pro
    case iPhone15ProMax
    case iPad2
    case iPad3
    case iPad4
    case iPadAir
    case iPadAir2
    case iPad5
    case iPad6
    case iPadAir3
    case iPad7
    case iPad8
    case iPad9
    case iPad10
    case iPadAir4
    case iPadAir5
    case iPadMini
    case iPadMini2
    case iPadMini3
    case iPadMini4
    case iPadMini5
    case iPadMini6
    case iPadPro9Inch
    case iPadPro12Inch
    case iPadPro12Inch2
    case iPadPro10Inch
    case iPadPro11Inch
    case iPadPro12Inch3
    case iPadPro11Inch2
    case iPadPro12Inch4
    case iPadPro11Inch3
    case iPadPro12Inch5
    case iPadPro11Inch4
    case iPadPro12Inch6
    
    /// Device is not yet known (implemented)
    /// You can still use this enum as before but the description equals the identifier (you can get multiple identifiers for the same product class
    /// (e.g. "iPhone6,1" or "iPhone 6,2" do both mean "iPhone 5s"))
    case unknown(String)
    
    /// Returns a `Device` representing the current device this software runs on.
    public static var current: Device {
        return Device.mapToDevice(identifier: Device.identifier)
    }
    
    /// Gets the identifier from the system, such as "iPhone7,1".
    public static var identifier: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)
        
        let identifier = mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }()
    
    /// Maps an identifier to a Device. If the identifier can not be mapped to an existing device, `UnknownDevice(identifier)` is returned.
    ///
    /// - parameter identifier: The device identifier, e.g. "iPhone7,1". Can be obtained from `Device.identifier`.
    ///
    /// - returns: An initialized `Device`.
    public static func mapToDevice(identifier: String) -> Device { // swiftlint:disable:this cyclomatic_complexity function_body_length
        switch identifier {
        case "iPod5,1": return iPodTouch5
        case "iPod7,1": return iPodTouch6
        case "iPod9,1": return iPodTouch7
        case "iPhone3,1",
             "iPhone3,2",
             "iPhone3,3": return iPhone4
        case "iPhone4,1": return iPhone4s
        case "iPhone5,1",
             "iPhone5,2": return iPhone5
        case "iPhone5,3",
             "iPhone5,4": return iPhone5c
        case "iPhone6,1",
             "iPhone6,2": return iPhone5s
        case "iPhone7,2": return iPhone6
        case "iPhone7,1": return iPhone6Plus
        case "iPhone8,1": return iPhone6s
        case "iPhone8,2": return iPhone6sPlus
        case "iPhone9,1",
             "iPhone9,3": return iPhone7
        case "iPhone9,2",
             "iPhone9,4": return iPhone7Plus
        case "iPhone8,4": return iPhoneSE
        case "iPhone10,1",
             "iPhone10,4": return iPhone8
        case "iPhone10,2",
             "iPhone10,5": return iPhone8Plus
        case "iPhone10,3",
             "iPhone10,6": return iPhoneX
        case "iPhone11,2": return iPhoneXS
        case "iPhone11,4",
             "iPhone11,6": return iPhoneXSMax
        case "iPhone11,8": return iPhoneXR
        case "iPhone12,1": return iPhone11
        case "iPhone12,3": return iPhone11Pro
        case "iPhone12,5": return iPhone11ProMax
        case "iPhone12,8": return iPhoneSE2
        case "iPhone13,2": return iPhone12
        case "iPhone13,1": return iPhone12Mini
        case "iPhone13,3": return iPhone12Pro
        case "iPhone13,4": return iPhone12ProMax
        case "iPhone14,5": return iPhone13
        case "iPhone14,4": return iPhone13Mini
        case "iPhone14,2": return iPhone13Pro
        case "iPhone14,3": return iPhone13ProMax
        case "iPhone14,6": return iPhoneSE3
        case "iPhone14,7": return iPhone14
        case "iPhone14,8": return iPhone14Plus
        case "iPhone15,2": return iPhone14Pro
        case "iPhone15,3": return iPhone14ProMax
        case "iPhone15,4": return iPhone15
        case "iPhone15,5": return iPhone15Plus
        case "iPhone16,1": return iPhone15Pro
        case "iPhone16,2": return iPhone15ProMax
        case "iPad2,1",
             "iPad2,2",
             "iPad2,3",
             "iPad2,4": return iPad2
        case "iPad3,1",
             "iPad3,2",
             "iPad3,3": return iPad3
        case "iPad3,4",
             "iPad3,5",
             "iPad3,6": return iPad4
        case "iPad4,1",
             "iPad4,2",
             "iPad4,3": return iPadAir
        case "iPad5,3",
             "iPad5,4": return iPadAir2
        case "iPad6,11",
             "iPad6,12": return iPad5
        case "iPad7,5",
             "iPad7,6": return iPad6
        case "iPad11,3",
             "iPad11,4": return iPadAir3
        case "iPad7,11",
             "iPad7,12": return iPad7
        case "iPad11,6",
             "iPad11,7": return iPad8
        case "iPad12,1",
             "iPad12,2": return iPad9
        case "iPad13,18",
             "iPad13,19": return iPad10
        case "iPad13,1",
             "iPad13,2": return iPadAir4
        case "iPad13,16",
             "iPad13,17": return iPadAir5
        case "iPad2,5",
             "iPad2,6",
             "iPad2,7": return iPadMini
        case "iPad4,4",
             "iPad4,5",
             "iPad4,6": return iPadMini2
        case "iPad4,7",
             "iPad4,8",
             "iPad4,9": return iPadMini3
        case "iPad5,1",
             "iPad5,2": return iPadMini4
        case "iPad11,1",
             "iPad11,2": return iPadMini5
        case "iPad14,1",
             "iPad14,2": return iPadMini6
        case "iPad6,3",
             "iPad6,4": return iPadPro9Inch
        case "iPad6,7",
             "iPad6,8": return iPadPro12Inch
        case "iPad7,1",
             "iPad7,2": return iPadPro12Inch2
        case "iPad7,3",
             "iPad7,4": return iPadPro10Inch
        case "iPad8,1",
             "iPad8,2",
             "iPad8,3",
             "iPad8,4": return iPadPro11Inch
        case "iPad8,5",
             "iPad8,6",
             "iPad8,7",
             "iPad8,8": return iPadPro12Inch3
        case "iPad8,9",
             "iPad8,10": return iPadPro11Inch2
        case "iPad8,11",
             "iPad8,12": return iPadPro12Inch4
        case "iPad13,4",
             "iPad13,5",
             "iPad13,6",
             "iPad13,7": return iPadPro11Inch3
        case "iPad13,8",
             "iPad13,9",
             "iPad13,10",
             "iPad13,11": return iPadPro12Inch5
        case "iPad14,3",
             "iPad14,4": return iPadPro11Inch4
        case "iPad14,5",
             "iPad14,6": return iPadPro12Inch6
        default: return unknown(identifier)
        }
    }
    
    // MARK: Current Device
    
    /// Whether or not the current device is the current device.
    private var isCurrent: Bool {
        return self == Device.current
    }
    
    public var isZoomed: Bool? {
        guard isCurrent else { return nil }
        if Int(UIScreen.main.scale.rounded()) == 3 {
            // Plus-sized
            return UIScreen.main.nativeScale > 2.7 && UIScreen.main.nativeScale < 3
        } else {
            return UIScreen.main.nativeScale > UIScreen.main.scale
        }
    }
    
    /// The brightness level of the screen.
    public var screenBrightness: Int {
        #if os(iOS)
            return Int(UIScreen.main.brightness * 100)
        #else
            return 100
        #endif
    }
}

// MARK: CustomStringConvertible

extension Device: CustomStringConvertible {
    public var description: String {
        switch self {
        case .iPodTouch5: return "iPod touch (5th generation)"
        case .iPodTouch6: return "iPod touch (6th generation)"
        case .iPodTouch7: return "iPod touch (7th generation)"
        case .iPhone4: return "iPhone 4"
        case .iPhone4s: return "iPhone 4s"
        case .iPhone5: return "iPhone 5"
        case .iPhone5c: return "iPhone 5c"
        case .iPhone5s: return "iPhone 5s"
        case .iPhone6: return "iPhone 6"
        case .iPhone6Plus: return "iPhone 6 Plus"
        case .iPhone6s: return "iPhone 6s"
        case .iPhone6sPlus: return "iPhone 6s Plus"
        case .iPhone7: return "iPhone 7"
        case .iPhone7Plus: return "iPhone 7 Plus"
        case .iPhoneSE: return "iPhone SE"
        case .iPhone8: return "iPhone 8"
        case .iPhone8Plus: return "iPhone 8 Plus"
        case .iPhoneX: return "iPhone X"
        case .iPhoneXS: return "iPhone XS"
        case .iPhoneXSMax: return "iPhone XS Max"
        case .iPhoneXR: return "iPhone XR"
        case .iPhone11: return "iPhone 11"
        case .iPhone11Pro: return "iPhone 11 Pro"
        case .iPhone11ProMax: return "iPhone 11 Pro Max"
        case .iPhoneSE2: return "iPhone SE (2nd generation)"
        case .iPhone12: return "iPhone 12"
        case .iPhone12Mini: return "iPhone 12 mini"
        case .iPhone12Pro: return "iPhone 12 Pro"
        case .iPhone12ProMax: return "iPhone 12 Pro Max"
        case .iPhone13: return "iPhone 13"
        case .iPhone13Mini: return "iPhone 13 mini"
        case .iPhone13Pro: return "iPhone 13 Pro"
        case .iPhone13ProMax: return "iPhone 13 Pro Max"
        case .iPhoneSE3: return "iPhone SE (3rd generation)"
        case .iPhone14: return "iPhone 14"
        case .iPhone14Plus: return "iPhone 14 Plus"
        case .iPhone14Pro: return "iPhone 14 Pro"
        case .iPhone14ProMax: return "iPhone 14 Pro Max"
        case .iPhone15: return "iPhone 15"
        case .iPhone15Plus: return "iPhone 15 Plus"
        case .iPhone15Pro: return "iPhone 15 Pro"
        case .iPhone15ProMax: return "iPhone 15 Pro Max"
        case .iPad2: return "iPad 2"
        case .iPad3: return "iPad (3rd generation)"
        case .iPad4: return "iPad (4th generation)"
        case .iPadAir: return "iPad Air"
        case .iPadAir2: return "iPad Air 2"
        case .iPad5: return "iPad (5th generation)"
        case .iPad6: return "iPad (6th generation)"
        case .iPadAir3: return "iPad Air (3rd generation)"
        case .iPad7: return "iPad (7th generation)"
        case .iPad8: return "iPad (8th generation)"
        case .iPad9: return "iPad (9th generation)"
        case .iPad10: return "iPad (10th generation)"
        case .iPadAir4: return "iPad Air (4th generation)"
        case .iPadAir5: return "iPad Air (5th generation)"
        case .iPadMini: return "iPad Mini"
        case .iPadMini2: return "iPad Mini 2"
        case .iPadMini3: return "iPad Mini 3"
        case .iPadMini4: return "iPad Mini 4"
        case .iPadMini5: return "iPad Mini (5th generation)"
        case .iPadMini6: return "iPad Mini (6th generation)"
        case .iPadPro9Inch: return "iPad Pro (9.7-inch)"
        case .iPadPro12Inch: return "iPad Pro (12.9-inch)"
        case .iPadPro12Inch2: return "iPad Pro (12.9-inch) (2nd generation)"
        case .iPadPro10Inch: return "iPad Pro (10.5-inch)"
        case .iPadPro11Inch: return "iPad Pro (11-inch)"
        case .iPadPro12Inch3: return "iPad Pro (12.9-inch) (3rd generation)"
        case .iPadPro11Inch2: return "iPad Pro (11-inch) (2nd generation)"
        case .iPadPro12Inch4: return "iPad Pro (12.9-inch) (4th generation)"
        case .iPadPro11Inch3: return "iPad Pro (11-inch) (3rd generation)"
        case .iPadPro12Inch5: return "iPad Pro (12.9-inch) (5th generation)"
        case .iPadPro11Inch4: return "iPad Pro (11-inch) (4th generation)"
        case .iPadPro12Inch6: return "iPad Pro (12.9-inch) (6th generation)"
        case let .unknown(identifier): return identifier
        }
    }
}

// MARK: Equatable

extension Device: Equatable {
    /// Compares two devices
    ///
    /// - parameter lhs: A device.
    /// - parameter rhs: Another device.
    ///
    /// - returns: `true` iff the underlying identifier is the same.
    public static func == (lhs: Device, rhs: Device) -> Bool {
        return lhs.description == rhs.description
    }
}
