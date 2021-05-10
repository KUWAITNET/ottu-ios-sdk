//
//  ViewController.swift
//  OttuCheckout
//
//  Created by Yanenko Petr on 05/04/2021.
//  Copyright (c) 2021 Yanenko Petr. All rights reserved.
//

import UIKit
import OttuCheckout
import RxSwift
import RxCocoa
import PassKit

class ViewController: UIViewController {
    
    var knpay = Checkout()
    
    @IBOutlet weak var addApplePayButton:UIButton!
    @IBOutlet weak var priceTextField:UITextField!
    @IBOutlet weak var sessionTextField:UITextField!
    @IBOutlet weak var codeTextField:UITextField!
    @IBOutlet weak var appleBtnView:UIView!
    @IBOutlet weak var textFieldTrailingConstraint:NSLayoutConstraint!
    
    var disposeBag = DisposeBag()
    
    var isApplePayBtnPresented = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewConfiguration()
        codeTextField.attributedPlaceholder = NSAttributedString(string: "Like this: apple-pay",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        knpay.delegate = self
    }
    
    func checkApplePayBtnVisible() {
        
        addApplePayButton.isHidden = isApplePayBtnPresented
        
        UIView.animate(withDuration: 0.3) {
            if let price = self.priceTextField.text, !price.isEmpty, let sessionID = self.sessionTextField.text, !sessionID.isEmpty {
                self.addApplePayButton.alpha = 1
                
                let config = ApplePayConfig()
                config.merchantID = "merchant.dev.ottu.ksa"
                config.cards = [.Amex, .Visa, .MasterCard]
                config.countryCode = .SR
                config.merchantCapabilities = [.capability3DS]
                
                config.paymentItems = [
                    PKPaymentSummaryItem(label: "My Product", amount: NSDecimalNumber(decimal: 1)),
                    PKPaymentSummaryItem(label: "Delivery Tax", amount: NSDecimalNumber(decimal: 2))
                ]
                
                self.knpay.sessionID = self.sessionTextField.text!
                self.knpay.domainURL = "ksa.ottu.dev"
                self.knpay.code = self.codeTextField.text!
                self.knpay.configure(applePayConfig: config, amount: self.priceTextField.text!, currency_code: .SAR, viewController: self)
                
                self.appleBtnView.alpha = 1
            }
            else {
                self.addApplePayButton.alpha = 0
                self.appleBtnView.alpha = 0
            }
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

     if string == "," {
       textField.text! += "."
       return false
     }

     let dotsCount = textField.text!.components(separatedBy: ".").count - 1
       if dotsCount > 0 && string == "." {
       return false
     }
        
     return true
    }

    
    func setupViewConfiguration() {
        
        addApplePayButton.alpha = 0
        appleBtnView.alpha = 0
        
        Observable.zip(priceTextField.rx.text, priceTextField.rx.text.skip(1))
            .subscribe(onNext: { (old, new) in
                
                var oldValue = old
                let dotsCount = (new?.components(separatedBy: ".").count)! - 1
                if dotsCount > 1  {
                    if ((oldValue?.components(separatedBy: ".").count)! - 1 > 1) {
                        oldValue?.removeLast()
                    }
                    self.priceTextField.text = oldValue
                  }
                }).disposed(by: disposeBag)
        
        priceTextField.rx.text.subscribe(onNext: {
            _ in
            self.checkApplePayBtnVisible()
        }).disposed(by: disposeBag)
        
        hideKeyboardWhenTappedAround()
        
        // Subscribe to Keyboard Will Show notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        // Subscribe to Keyboard Will Hide notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        priceTextField.rx.controlEvent(.editingChanged).subscribe(onNext: {
            _ in
            self.checkApplePayBtnVisible()
        }).disposed(by: disposeBag)
        
        sessionTextField.rx.controlEvent(.editingChanged).subscribe(onNext: {
            _ in
            
            self.checkApplePayBtnVisible()
            
        }).disposed(by: disposeBag)
        
        addApplePayButton.rx.tap.subscribe(onNext: {
            _ in
            
            self.knpay.displayApplePayButton(applePayView: self.appleBtnView)
            self.isApplePayBtnPresented = true
            self.addApplePayButton.isHidden = true
            
        }).disposed(by: disposeBag)
        
    }
    
    @objc
    dynamic func keyboardWillShow(
        _ notification: NSNotification
    ) {
        animateWithKeyboard(notification: notification) {
            (keyboardFrame) in
            let constant = 20 + keyboardFrame.height
            self.textFieldTrailingConstraint?.constant = constant
        }
    }
    
    @objc
    dynamic func keyboardWillHide(
        _ notification: NSNotification
    ) {
        animateWithKeyboard(notification: notification) {
            (keyboardFrame) in
            self.textFieldTrailingConstraint?.constant = 20
        }
    }
}


extension ViewController {
    func animateWithKeyboard(
        notification: NSNotification,
        animations: ((_ keyboardFrame: CGRect) -> Void)?
    ) {
        // Extract the duration of the keyboard animation
        let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        let duration = notification.userInfo![durationKey] as! Double
        
        // Extract the final frame of the keyboard
        let frameKey = UIResponder.keyboardFrameEndUserInfoKey
        let keyboardFrameValue = notification.userInfo![frameKey] as! NSValue
        
        // Extract the curve of the iOS keyboard animation
        let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
        let curveValue = notification.userInfo![curveKey] as! Int
        let curve = UIView.AnimationCurve(rawValue: curveValue)!

        // Create a property animator to manage the animation
        let animator = UIViewPropertyAnimator(
            duration: duration,
            curve: curve
        ) {
            // Perform the necessary animation layout updates
            animations?(keyboardFrameValue.cgRectValue)
            
            // Required to trigger NSLayoutConstraint changes
            // to animate
            self.view?.layoutIfNeeded()
        }
        
        // Start the animation
        animator.startAnimation()
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension Decimal {
    var significantFractionalDecimalDigits: Int {
        return max(-exponent, 0)
    }
}

extension ViewController: CheckoutDelegate {
        
    func paymentFinished(yourDomainResponse: [String:Any], applePayResultCompletion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        if let approved = yourDomainResponse["approved"], approved as? Bool == true {
            applePayResultCompletion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        }
        else {
            applePayResultCompletion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
        }
    }
    
    
    func paymentDissmised() {
        //
    }
}

