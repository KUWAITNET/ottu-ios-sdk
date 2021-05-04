//
//  ApplePayPaymentNetwork.swift
//
//  Created by Petr Yanenko on 23.04.2021.
//

import Foundation
import struct PassKit.PKPaymentNetwork

/// Enum to define  a payment network to be provided into Apple Pay request
@objc public enum TapApplePayPaymentNetwork: Int, RawRepresentable, CaseIterable {
    
    public typealias AllCases = [TapApplePayPaymentNetwork]
    
    public static var allCases: AllCases {
        get {
            var allCasesArray:[TapApplePayPaymentNetwork] = [.Amex,.CartesBancaires,.Discover,.Eftpos,.Electron,.idCredit,.Interac,.JCB,.Maestro,.MasterCard,.PrivateLabel,.QuicPay,.Suica,.Visa,.VPay]
            if #available(iOS 12.1.1, *) {
                allCasesArray.append(.Mada)
                allCasesArray.append(.Elo)
            }
            return allCasesArray
        }
    }
    
    case Amex
    case CartesBancaires
    case Discover
    case Eftpos
    case Electron
    @available(iOS 12.1.1, *)
    case Elo
    case idCredit
    case Interac
    case JCB
    @available(iOS 12.1.1, *)
    case Mada
    case Maestro
    case MasterCard
    case PrivateLabel
    case QuicPay
    case Suica
    case Visa
    case VPay
    
    /// Coming constcutors to spport creating enums from String in case of parsing it from JSON
    public init?(rawValue: String) {
        switch rawValue.lowercased() {
        case "amex":
            self = .Amex
        case "cartesbancaires":
            self = .CartesBancaires
        case "discover":
            self = .Discover
        case "eftpos":
            self = .Eftpos
        case "electron":
            self = .Electron
        case "idcredit":
            self = .idCredit
        case "interac":
            self = .Interac
        case "jcb":
            self = .JCB
        case "maestro":
            self = .Maestro
        case "mastercard":
            self = .MasterCard
        case "privatelabel":
            self = .PrivateLabel
        case "quicpay":
            self = .QuicPay
        case "suica":
            self = .Suica
        case "visa":
            self = .Visa
        case "vpay":
            self = .VPay
        default:
            if #available(iOS 12.1.1, *) {
                switch rawValue.lowercased() {
                case "elo":
                    self = .Elo
                case "mada":
                    self = .Mada
                default:
                    return nil
                }
            }else { return nil }
        }
    }
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .Amex:
            return "Amex"
        case .CartesBancaires:
            return "CartesBancaires"
        case .Discover:
            return "Discover"
        case .Eftpos:
            return "Eftpos"
        case .Electron:
            return "Electron"
        case .idCredit:
            return "idCredit"
        case .Interac:
            return "Interac"
        case .JCB:
            return "JCB"
        case .Maestro:
            return "Maestro"
        case .MasterCard:
            return "MasterCard"
        case .PrivateLabel:
            return "PrivateLabel"
        case .QuicPay:
            return "QuicPay"
        case .Suica:
            return "Suica"
        case .Visa:
            return "Visa"
        case .VPay:
            return "VPay"
        default:
            if #available(iOS 12.1.1, *) {
                switch self {
                case .Elo:
                    return "Elo"
                case .Mada:
                    return "Mada"
                default:
                    return ""
                }
            }else {return ""}
        }
    }
    
    public var applePayNetwork : PKPaymentNetwork? {
        switch self {
        case .Amex:
            return .amex
        case .CartesBancaires:
            if #available(iOS 11.2, *) {
                return .cartesBancaires
            } else {
                return nil
            }
        case .Discover:
            return .discover
        case .Eftpos:
            if #available(iOS 12.0, *) {
                return .eftpos
            } else {
                return nil
            }
        case .Electron:
            if #available(iOS 12.0, *) {
                return .electron
            } else {
                return nil
            }
        case .idCredit:
            if #available(iOS 10.3, *) {
                return .idCredit
            } else {
                return nil
            }
        case .Interac:
            if #available(iOS 9.2, *) {
                return .interac
            } else {
                return nil
            }
        case .JCB:
            if #available(iOS 10.1, *) {
                return .JCB
            } else {
                return nil
            }
        case .Maestro:
            if #available(iOS 12.0, *) {
                return .maestro
            } else {
                return nil
            }
        case .MasterCard:
            return .masterCard
        case .PrivateLabel:
            return .privateLabel
        case .QuicPay:
            if #available(iOS 10.3, *) {
                return .quicPay
            } else {
                return nil
            }
        case .Suica:
            if #available(iOS 10.1, *) {
                return .suica
            } else {
                return nil
            }
        case .Visa:
            return .visa
        case .VPay:
            if #available(iOS 12.0, *) {
                return .vPay
            } else {
                return nil
            }
        default:
            if #available(iOS 12.1.1, *) {
                switch self {
                case .Elo:
                    return .elo
                case .Mada:
                    return .mada
                default:
                    return nil
                }
            }else {return nil}
        }
    }
}
