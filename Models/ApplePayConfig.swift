//
//  Cehsadasd.swift
//  KNPAYSDK
//
//  Created by Petr Yanenko on 02.05.2021.
//

import Foundation
import PassKit

public class ApplePayConfig:NSObject {
    
    var countryCode:CountryCode
    var cards : [TapApplePayPaymentNetwork] = [.Amex, .Visa, .MasterCard]
    var paymentItems:[PKPaymentSummaryItem] = []
    
    public init(_countryCode:CountryCode, _cards : [TapApplePayPaymentNetwork], _paymentItems:[PKPaymentSummaryItem]?) {
        countryCode = _countryCode
        cards = _cards
        
        if let newItems = _paymentItems {
            paymentItems = newItems
        }
    }
}
