//
//  TapApplePayStatus.swift
//
//  Created by Petr Yanenko on 23.04.2021.
//

import Foundation

/// This enum is a wrapper to indicate the current device/user status to Deal with Apple Pay
@objc public enum TapApplePayStatus:Int {
    /// This means the current device/user has Apple pay activated and a card belongs to the given payment networks
    case Eligible
    /// This means the current device/user has Apple pay activated but has no card belongs to the given payment networks
    case NeedSetup
    /// This means the current device/user cannot use Apple pay from Apple
    case NotEligible
    
    
    public func ApplePayStatusRawValue() -> String {
        switch self {
        case .Eligible:
            return "Eligible, This means the current device/user has Apple pay activated and a card belongs to the given payment networks"
        case .NeedSetup:
            return "NeedSetup, This means the current device/user has Apple pay activated but has no card belongs to the given payment networks"
        case .NotEligible:
        return "NotEligible, This means the current device/user cannot use Apple pay from Apple"
        default:
            return ""
        }
    }
}
