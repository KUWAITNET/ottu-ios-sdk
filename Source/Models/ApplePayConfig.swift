//
//  Cehsadasd.swift
//  KNPAYSDK
//
//  Created by Petr Yanenko on 02.05.2021.
//

import Foundation
import PassKit

public class ApplePayConfig:NSObject {
    
    public var countryCode:CountryCode = .SR
    public var merchantID:String = String()
    public var code:String = String()
    public var cards : [TapApplePayPaymentNetwork] = [.Amex, .Visa, .MasterCard]
    public var paymentItems:[PKPaymentSummaryItem] = []
    public var merchantCapabilities:PKMerchantCapability = [.capability3DS]
    
}
