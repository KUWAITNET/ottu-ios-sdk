//
//  Checkout.swift
//
//  Created by Petr Yanenko on 23.04.2021.
//

import Foundation
import PassKit

@available(iOS 11.0, *)
public protocol CheckoutDelegate {
    func paymentFinished(yourDomainResponse:[String:Any], applePayResultCompletion: @escaping (PKPaymentAuthorizationResult) -> Void)
    func onErrorHandler(serverResponse:[String:Any]?, statusCode:Int?, error:Error?)
    func paymentDissmised()
}

@available(iOS 12.0, *)
@objcMembers public class Checkout:NSObject {
    
    private var parrentVC: UIViewController!
    private var paymentAmount:NSDecimalNumber!
    private var tapApplePayButton:TapApplePayButton?
    
    public var domainURL:String!
    public var sessionID:String!
    private var code:String!
    private var amount:String!
    private var currency_code:String!

    private var isApplePayShowed:Bool = false
    
    var myApplePayRequest:ApplePayRequest = .init()
    public var delegate:CheckoutDelegate?
    
    private var CustomPaymentMethodTypes = [
        "unknown",
        "credit",
        "prepaid",
        "store"
    ]

    public func configure(applePayConfig:ApplePayConfig, amount:String, currency_code:CurrencyCode, viewController: UIViewController) {
        
        myApplePayRequest.build(with: applePayConfig.countryCode, paymentNetworks: applePayConfig.cards, paymentItems: applePayConfig.paymentItems, paymentAmount: Double(amount) ?? 1, currencyCode: currency_code, merchantID: applePayConfig.merchantID, merchantCapapbility: applePayConfig.merchantCapabilities)
        
        self.parrentVC = viewController
        self.currency_code = currency_code.appleRawValue
        self.amount = amount
        self.code = applePayConfig.code
    }
    
    public func displayApplePayButton(applePayView:UIView) -> TapApplePayStatus {
        
        guard let _ = domainURL else {
            return .DomainURLNotSetuped
        }
        
        guard let _ = sessionID else {
            return .SessionIDNotSetuped
        }
        
        guard let _ = code else {
            return .SessionIDNotSetuped
        }
        
        let applePayStatus:TapApplePayStatus = checkApplePayStats()

        if applePayStatus == .Eligible {
            if !isApplePayShowed {
                tapApplePayButton = TapApplePayButton.init(frame: applePayView.bounds)
                tapApplePayButton?.setup()
                tapApplePayButton?.dataSource = self
                tapApplePayButton?.delegate = self
                applePayView.addSubview(tapApplePayButton!)
                isApplePayShowed = true
            }
        }
        
        return applePayStatus
    }
    
    func startApplePaySetup() {
        ApplePay.startApplePaySetupProcess()
    }
    
    //MARK: Flutter plugin (Payment without button)
    public func pay(viewController:UIViewController)-> TapApplePayStatus{
        guard let _ = domainURL else {
            return .DomainURLNotSetuped
        }
        
        guard let _ = sessionID else {
            return .SessionIDNotSetuped
        }
        
        let applePayStatus:TapApplePayStatus = checkApplePayStats()

        if applePayStatus == .Eligible {
            if !isApplePayShowed {
                tapApplePayButton = TapApplePayButton.init(frame: viewController.view.bounds)
                tapApplePayButton?.setup()
                tapApplePayButton?.dataSource = self
                tapApplePayButton?.delegate = self
                tapApplePayButton?.isHidden = true
                viewController.view.addSubview(tapApplePayButton!)
                isApplePayShowed = true
                
            }
            tapApplePayButton?.pay()
        }
        return applePayStatus
    }
    
    private func checkApplePayStats() -> TapApplePayStatus  {
        return ApplePay.applePayStatus(for: myApplePayRequest.paymentNetworks, shouldOpenSetupDirectly: false)
    }
}

@available(iOS 12.0, *)
extension Checkout:TapApplePayButtonDataSource,TapApplePayButtonDelegate {
    
    func showAlert(title:String, data:String, isCopy:Bool = true) {
        let alertControl = UIAlertController(title: title, message: data, preferredStyle: .alert)
        
        if isCopy {
            let copyAction = UIAlertAction(title: "Copy", style: .default) { (_) in
                DispatchQueue.main.async { [weak self] in
                    let vc = UIActivityViewController(activityItems: [data], applicationActivities: [])
                    self?.parrentVC.present(vc, animated: true)
                }
            }
            
            alertControl.addAction(copyAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
        alertControl.addAction(cancelAction)
        DispatchQueue.main.async { [weak self] in
            self?.parrentVC.present(alertControl, animated: true, completion: nil)
        }
    }
    
    public func tapApplePayFinished(payment: PKPayment, completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        guard let domain = domainURL else {
            completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
            return
        }
        
        guard let session = sessionID else {
            completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
            return
        }
        
        let url = URL(string: "https://\(domain)/b/session/api/v1/pay")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            let paymentData = try JSONSerialization.jsonObject(with: payment.token.paymentData, options: .mutableContainers) as? [String:AnyObject]
            
            let postData = [
                "amount":self.amount!,
                "currency_code":self.currency_code!,
                "session_id": session,
                "code": self.code!,
                "device": UIDevice().type.rawValue,
                "apple_pay_payload": [
                    "token": [
                        "token": [
                            "paymentData": paymentData as Any,
                            "paymentMethod": [
                                "displayName" : payment.token.paymentMethod.displayName!,
                                "network" : payment.token.paymentMethod.network!.rawValue,
                                "type" :  CustomPaymentMethodTypes[Int(payment.token.paymentMethod.type.rawValue)]
                            ],
                            "transactionIdentifier":payment.token.transactionIdentifier
                        ]
                    ]
                ]
            ] as [String : Any]
            
            if let postData = (try? JSONSerialization.data(withJSONObject: postData, options: [.prettyPrinted])) {
                
                request.httpBody = postData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    do {

                        guard let data = data else {
                            if let error = error {
                                self.delegate?.onErrorHandler(serverResponse: nil, statusCode: nil, error: error)
                                completion(PKPaymentAuthorizationResult(status: .failure, errors: [error]))
                            }
                            else {
                                self.delegate?.onErrorHandler(serverResponse: nil, statusCode: nil, error: error)
                                completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                            }
                            return
                        }
                        
                        guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject] else {
                            self.delegate?.onErrorHandler(serverResponse: nil, statusCode: nil, error: nil)
                            completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                            return
                        }
                        
                        guard let httpResponse = response as? HTTPURLResponse else {
                            self.delegate?.onErrorHandler(serverResponse: json, statusCode: nil, error: nil)
                            completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                            return
                        }
                        
                        if !(200...299).contains(httpResponse.statusCode) {
                            self.delegate?.onErrorHandler(serverResponse: json, statusCode: httpResponse.statusCode, error: nil)
                            completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                            return
                        }
                        
                        
                        self.delegate?.paymentFinished(yourDomainResponse: json, applePayResultCompletion: completion)
                        
                    } catch let error {
                        completion(PKPaymentAuthorizationResult(status: .failure, errors: [error]))
                        return
                    }
                }
                
                task.resume()
            }
        } catch let error {
            completion(PKPaymentAuthorizationResult(status: .failure, errors: [error]))
            return
        }
    }
    
    public func tapApplePayDissmised() {
        delegate?.paymentDissmised()
    }
    
    public var tapApplePayRequest: ApplePayRequest {
        return myApplePayRequest
    }
}
