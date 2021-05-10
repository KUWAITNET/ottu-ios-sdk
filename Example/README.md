
# OttuCheckout


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

    

#### Integrate with Xcode

Add the ****Apple Pay**** capability to your app. In Xcode, open your project settings, choose the ****Capabilities**** tab, and enable the ****Apple Pay**** switch. You may be prompted to log in to your developer account at this point. Enable the checkbox next to the merchant ID you created earlier, and your app is ready to accept Apple Pay.

![Enable the Apple pay capability in Xcode](https://storage.stfalcon.com/uploads/images/5c45cffa7e8f6.png)

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

checkout.domainUrl = "domain"

checkout.sessionID = "session_id"

let applePayConfig = ApplePayConfig()

applePayConfig.cards = [.Amex, .MasterCard, .Visa]

applePayConfig.countryCode = .SR

applePayConfig.merchantID = "merchant"

applePayConfig.merchantCapabilities = [.capability3DS]
applePayConfig.paymentItems = [
	PKPaymentSummaryItem(label: "My Product", amount: NSDecimalNumber(decimal: 1)),
	PKPaymentSummaryItem(label: "Delivery Tax", amount: NSDecimalNumber(decimal: 2))
]

checkout.configure(applePayConfig: applePayConfig, amount: "1", currency_code: .SAR)

```


| Name | Type |  Description | Defualt |
|--|--|--|--|
|applePayConfig|ApplePayConfig|Mandatory params to initiate ApplePay|no|
| applePayConfig.countryCode | [`String`](https://developer.apple.com/documentation/passkit/pkpaymentrequest/1619246-countrycode) |The two-letter ISO 3166 country code. | .SR |
| applePayConfig.cards | [`[PKPaymentNetwork]`](https://developer.apple.com/documentation/passkit/pkpaymentrequest/1619329-supportednetworks) |List of available payment methods that are supported by Apple Pay. | [.Amex, .Visa, .MasterCard] |
| applePayConfig.paymentItems | [`[PKPaymentSummaryItem]`](https://developer.apple.com/documentation/passkit/pkpaymentrequest/1619231-paymentsummaryitems) |An array of payment summary item objects that summarize the amount of the payment. | no |
| applePayConfig.merchantID | [`String`](https://developer.apple.com/documentation/passkit/pkpaymentrequest/1619246-countrycode) |Your merchant identifier. | no |
| applePayConfig.merchantCapabilities | [`PKMerchantCapability`](https://developer.apple.com/documentation/passkit/pkmerchantcapability/) |Capabilities for processing payment. | [.capability3DS] |
| amount | [`PKPaymentSummaryItem`](https://developer.apple.com/documentation/passkit/pkpaymentsummaryitem) |An object that defines a summary item in a payment request—for example, total, tax, discount, or grand total. | no |
| currency_code | [`String`](https://developer.apple.com/documentation/passkit/pkpaymentrequest/1619246-countrycode) |The three-letter ISO 4217 currency code. | no |
| domainUrl | [`String`](https://developer.apple.com/documentation/passkit/pkpaymentrequest/1619246-countrycode) | API pay url, where payment shall be confirmed against Apple Pay token | no |
| sessionID | [`String`](https://developer.apple.com/documentation/passkit/pkpaymentrequest/1619246-countrycode) | Specified token which you need to get here https://docs.ottu.com/#/sessionAPI | no |



  

  

Init UIView where Apple Pay button will be inserted

```

@IBOutlet weak var applePayButtonView:UIView!

```

Now you can request Apple Pay button

```

switch self.knpay.displayApplePayButton(applePayView: self.appleBtnView) {

	case .Eligible:
		break
	case .NeedSetup:
		break
	case .NotEligible:
		break
	case .SessionIDNotSetuped:
		break
	case .DomainURLNotSetuped:
		break
}

```

  

You can put code above in any place but before you start using SDK.



  ### Delegate
  You need to delegate Chekout 
```

checkout.delegate = self

```
Then implement CheckoutDelegate protocol to your ViewController

```

extension  ViewController: CheckoutDelegate {

	func paymentFinished(yourDomainResponse: [String:**Any**], applePayResultCompletion: **@escaping** (PKPaymentAuthorizationResult) -> Void) {

		if let approved = yourDomainResponse["approved"], approved as? Bool == true {
			applePayResultCompletion(PKPaymentAuthorizationResult(status: .success, errors: nil))
		}
		else {
			applePayResultCompletion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
		}
	}

	func  paymentDissmised() {
		//
	}
}

```


## Author

  

Ottu,    [Info@ottu.com](mailto:Info@ottu.com)

  

## License

  

OttuCheckout is available under the MIT license. See the LICENSE file for more info.
