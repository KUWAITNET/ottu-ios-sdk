# OttuCheckout

[![CI Status](https://img.shields.io/travis/Yanenko Petr/OttuCheckout.svg?style=flat)](https://travis-ci.org/Yanenko Petr/OttuCheckout)
[![Version](https://img.shields.io/cocoapods/v/OttuCheckout.svg?style=flat)](https://cocoapods.org/pods/OttuCheckout)
[![License](https://img.shields.io/cocoapods/l/OttuCheckout.svg?style=flat)](https://cocoapods.org/pods/OttuCheckout)
[![Platform](https://img.shields.io/cocoapods/p/OttuCheckout.svg?style=flat)](https://cocoapods.org/pods/OttuCheckout)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

OttuCheckout is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'OttuCheckout'
```


## Using

### Setup
in `ViewController`

After install SDK from  Cocoapods you need to implement it in to your Controller
```
import OttuCheckout
```
Then create variable like this 
```
var checkout = Checkout!
```
After this you can set config apple pay request
```
checkout.configure(applePayConfig: ApplePayConfig(cards: [.Amex,.Visa, .MasterCard], countryCode: .SA, paymentItems: **nil**), amount: "1", currency_code: .SAR, merchantID: "yourMerchantID", domain: "yourDomain", session_id: "yourSession")
```
| Name | Type |  Description | Defualt |
|--|--|--|--|
|applePayConfig|ApplePayConfig|Mandatory params to initiate ApplePay|no|
| applePayConfig.countryCode | [`String`](https://developer.apple.com/documentation/passkit/pkpaymentrequest/1619246-countrycode) |The two-letter ISO 3166 country code. | no |
| applePayConfig.cards | [`[PKPaymentNetwork]`](https://developer.apple.com/documentation/passkit/pkpaymentrequest/1619329-supportednetworks) |List of available payment methods that are supported by Apple Pay. | no |
| applePayConfig.paymentItems | [`[PKPaymentSummaryItem]`](https://developer.apple.com/documentation/passkit/pkpaymentrequest/1619231-paymentsummaryitems) |An array of payment summary item objects that summarize the amount of the payment. | no |
| amount | [`PKPaymentSummaryItem`](https://developer.apple.com/documentation/passkit/pkpaymentsummaryitem) |An object that defines a summary item in a payment request—for example, total, tax, discount, or grand total. | no |
| currency_code | [`String`](https://developer.apple.com/documentation/passkit/pkpaymentrequest/1619246-countrycode) |The three-letter ISO 4217 currency code. | no |
| merchantID | [`String`](https://developer.apple.com/documentation/passkit/pkpaymentrequest/1619246-countrycode) |Your merchant identifier. | no |
| domain | [`String`](https://developer.apple.com/documentation/passkit/pkpaymentrequest/1619246-countrycode) | API pay url, where payment shall be confirmed against Apple Pay token | no |
| session_id | [`String`](https://developer.apple.com/documentation/passkit/pkpaymentrequest/1619246-countrycode) | Specified token which you need to get here https://docs.ottu.com/#/sessionAPI | no |


Init UIView where Apple Pay button will be inserted
```
@IBOutlet weak var appleBtnView:UIView!
```
Now you can request Apple Pay button
```
checkout.displayApplePayButton(applePayView: appleBtnView)
```

You can put code above in any place but before you start using SDK.


## Set up Apple Pay `client side`
First, you need to obtain an Apple Merchant ID. Start by heading to the  [Registering a Merchant ID](https://developer.apple.com/documentation/passkit/apple_pay/setting_up_apple_pay_requirements)  page on the Apple Developer website.

Fill out the form with a description and identifier. Your description is for your own records and can be modified in the future (we recommend just using the name of your app). The identifier must be unique (across all apps, not just yours) and can’t be changed later (although you can always make another one). We recommend using  `merchant.com.{{your_app_name}}`.
#### Create a new Apple Pay certificate

You need to include a certificate in your app to encrypt outgoing payment data.
First, head to the  [Apple Pay](https://dashboard.stripe.com/account/payments/apple_pay)  Settings page in the Dashboard. Choose  **Add new application**  and download the  `.certSigningRequest`  file.

Next, back on the Apple Developer site, visit the  [Add iOS Certificate](https://developer.apple.com/documentation/passkit/apple_pay/setting_up_apple_pay_requirements)  page. Choose  **Apple Pay Certificate**  from the options and click  **Continue**. On the next page, choose the Merchant ID you created earlier from the dropdown and continue.

The next page explains that you can obtain a CSR from your Payment Provider (which at this point you’ve done already) or create one manually.  **Important note:**  you  **must**  use the CSR provided by Stripe - creating your own won’t work. So ignore the directions at the bottom of this page and continue on.

You’ll be prompted to upload a  `.certSigningRequest`  file. Choose the file you downloaded from the Dashboard and continue. You’ll see a success page, with an option to download your certificate. Download it. Finally, return to the Dashboard and upload this  `.cer`  file to Stripe.
#### Integrate with Xcode
Add the **Apple Pay** capability to your app. In Xcode, open your project settings, choose the **Capabilities** tab, and enable the **Apple Pay** switch. You may be prompted to log in to your developer account at this point. Enable the checkbox next to the merchant ID you created earlier, and your app is ready to accept Apple Pay.
 ![Enable the Apple pay capability in Xcode](https://storage.stfalcon.com/uploads/images/5c45cffa7e8f6.png)

### Usage example 
```
import UIKit
import OttuCheckout
import PassKit

class ViewController: UIViewController {

    @IBOutlet weak var applePayView:UIView!

    var checkout: Checkout!
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        checkout = Checkout(viewController: self)
        checkout.delegate = self
        checkout.configure(applePayConfig: ApplePayConfig(cards: [.Amex,.Visa, .MasterCard], countryCode: .SA, paymentItems: **nil**), amount: "1", currency_code: .SAR, merchantID: "merchant.kbsoft.example", domain: "https://ksa.ottu.dev", session_id: "test")
    }

    @IBAction func addApplePAyBtn(_ sender:UIButton) {
        checkout.displayApplePayButton(applePayView: applePayView)
    }
}

extension ViewController: CheckoutDelegate {

    func paymentFinished(yourDomainResponse: [String:Any], applePayResultCompletion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        if let approved = yourDomainResponse["approved"], approved as! Bool == true {
            applePayResultCompletion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        } else {
            applePayResultCompletion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
        }
    }

    func paymentDissmised() {
            // Apple Pay was dissmissed
    }
}
```


## Author

Yanenko Petr, yanenkopetr1841@gmail.com

## License

OttuCheckout is available under the MIT license. See the LICENSE file for more info.
