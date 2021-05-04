//
//  ViewController.swift
//  OttuCheckout
//
//  Created by Yanenko Petr on 05/04/2021.
//  Copyright (c) 2021 Yanenko Petr. All rights reserved.
//

import UIKit
import PassKit
import OttuCheckout

class ViewController: UIViewController {

    @IBOutlet weak var applePayView:UIView!
    
    var checkout: Checkout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkout = Checkout(viewController: self)
        checkout.delegate = self
        
        checkout.configure(applePayConfig: ApplePayConfig(_countryCode: .SA, _cards: [.Visa,.Amex,.MasterCard], _paymentItems: nil), amount: "1", currency_code: .SAR, merchantID: "merchant", domain: "https://domain", session_id: "session_id")
    }

    @IBAction func addApplePAyBtn(_ sender:UIButton) {
        checkout.displayApplePayButton(applePayView: applePayView)
    }
}

extension ViewController: CheckoutDelegate {
        
    func paymentFinished(yourDomainResponse: [String:Any], applePayResultCompletion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        if let approved = yourDomainResponse["approved"], approved as! Bool == true {
            applePayResultCompletion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        }
        else {
            applePayResultCompletion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
        }
    }
    
    
    func paymentDissmised() {
        // Apple Pay was dissmissed
    }
    
}
