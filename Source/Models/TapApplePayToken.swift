//
//  TapApplePayToken.swift
//
//  Created by Petr Yanenko on 23.04.2021.
//

import Foundation
import class PassKit.PKPaymentToken

/// A class to represent TapApplePayToken model
@objcMembers public class TapApplePayToken:NSObject {
    
    /// This holds the raw apple token as PKPaymentToken, once set all other values are defined
    public var rawAppleToken:PKPaymentToken? {
        didSet{
            convertTokenToString()
            convertTokenToJson()
        }
    }
    /// This holds a string representation of the apple payment token
    public var stringAppleToken:String?
    
    /// This holds a dictionary representation of the apple payment token
    public var jsonAppleToken:[String: Any] = [:]
    
    /**
     Create TapApplePayToken object with an apple payment token
     - Parameter rawAppleToken: This is the raw apple token you want to wrap. All other representations will be converted automatically
     */
    public init(with rawAppleToken:PKPaymentToken) {
        super.init()
        
        self.rawAppleToken = rawAppleToken
        /// THis is for testing purposes only so it will show something on simulator and testing dvices for the team who has no Apple pay
        if self.rawAppleToken == nil || self.rawAppleToken?.paymentData.count == 0 {
            convertTokenToString()
            convertTokenToJson()
        }
    }
    
    /// Convert Apple pay token data to a string format
    internal func convertTokenToString(){
        /// Double check there is an Apple token to convert fist
        stringAppleToken = nil
        if let nonNullAppleToken = self.rawAppleToken {
            stringAppleToken = String(data: nonNullAppleToken.paymentData, encoding: .utf8) ?? nil
        }
    }
    
    /// Convert Apple pay token data to a dict format
    internal func convertTokenToJson(){
        convertTokenToString()
        /// Double check there is an Apple token to convert fist
        if let nonNullString = self.stringAppleToken,
           let jsonData = nonNullString.data(using: .utf8){
            do {
                self.jsonAppleToken = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
            } catch {
                //
            }
        }
    }
}
