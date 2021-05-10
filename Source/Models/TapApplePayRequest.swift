//
//  ApplePayRequest.swift
//
//  Created by Petr Yanenko on 23.04.2021.
//

import Foundation
import PassKit

/// The class that represents the request details that identefies the transaction
@objc public class ApplePayRequest:NSObject {
    
    /// The country code where the user transacts
    public lazy var countryCode:CountryCode = .US
    /// The currency code the transaction has
    public lazy var currencyCode:CurrencyCode = .USD
    /// The payment networks you  want to limit the payment to
    public lazy var paymentNetworks:[TapApplePayPaymentNetwork] = [.Amex,.Visa, .MasterCard]
    /// What are the items you want to show in the apple pay sheet
    public lazy var paymentItems:[PKPaymentSummaryItem] = []
    /// The total amount you want to collect
    public lazy var paymentAmount:Double = 0
    /// The apple pay merchant identefier
    public lazy var merchantID:String = ""
    /// The apple pay merchant capabilities
    public lazy var merchantCapability:PKMerchantCapability = [.capability3DS]
    
    /// The actual apple pay request
    public lazy var appleRequest:PKPaymentRequest = .init()
    
    /**
     Creates a Tap Apple Pay request that can be used afterards to make an apple pay request
     - Parameter countryCode: The country code where the user transacts default .US
     - Parameter currencyCode: The currency code the transaction has default .USD
     - Parameter paymentNetworks:  The payment networks you  want to limit the payment to default [.Amex,.Visa,.Mada,.MasterCard]
     - Parameter var paymentItems: What are the items you want to show in the apple pay sheet default  []
     - Parameter paymentAmount: The total amount you want to collect
     - Parameter merchantID: The apple pay merchant identefier default ""
     **/
    public func build(with countryCode:CountryCode = .US, paymentNetworks:[TapApplePayPaymentNetwork] = [.Amex,.Visa,.MasterCard], paymentItems:[PKPaymentSummaryItem] = [], paymentAmount:Double,currencyCode:CurrencyCode = .USD,merchantID:String, merchantCapapbility:PKMerchantCapability = [.capability3DS]) {
        self.countryCode = countryCode
        self.paymentNetworks = paymentNetworks
        self.paymentItems = paymentItems
        self.paymentAmount = paymentAmount
        self.currencyCode = currencyCode
        self.merchantID = merchantID
        self.merchantCapability = merchantCapapbility
        configureApplePayRequest()
    }
    
    internal func updateValues() {
        configureApplePayRequest()
    }
    
    internal func configureApplePayRequest() {
        appleRequest = .init()
        appleRequest.countryCode = countryCode.rawValue
        appleRequest.currencyCode = currencyCode.appleRawValue
        appleRequest.paymentSummaryItems = paymentItems
        appleRequest.paymentSummaryItems.append(.init(label: "", amount: NSDecimalNumber(value: paymentAmount)))
        appleRequest.supportedNetworks = paymentNetworks.map{ $0.applePayNetwork! }
        appleRequest.merchantIdentifier = merchantID
        appleRequest.merchantCapabilities = merchantCapability
    }
}
