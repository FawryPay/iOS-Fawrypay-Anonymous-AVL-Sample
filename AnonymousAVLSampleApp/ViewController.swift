//
//  ViewController.swift
//  AnonymousAVLSampleApp
//
//  Created by Sameh on 13/07/2026.
//

import UIKit
import FawryPaySDK

class ViewController: UIViewController {

    private let serverURL = "https://atfawrystaging.atfawry.com/"
    private let merchantCode = "siYxylRjSPyg6dz0QH/y9A=="
    private let secureKey = "086f55c1-463b-425a-9342-f75b094c8b3e"

    private let customerInfo = LaunchCustomerModel(
        customerName: "John Doe",
        customerEmail: "john.doe@example.com",
        customerMobile: "01000000000",
        customerProfileId: "7117"
    )

    private let chargeInfo = ChargeItemsParamsModel(
        itemId: "item-001",
        charge_description: "Dummy item",
        price: 100,
        quantity: 1
    )

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Storyboard Actions

    @IBAction func launchAVLTapped(_ sender: UIButton) {
        let merchantInfo = makeMerchantInfo()
        let billingAcct = "1234567890"
        let beneficiaryWalletNumber = "01000000000"
        let avlInfo = AVLInfo(
            onUsBTC: 13,
            offUsBTC: 11,
            internationalBANs: ["123456", "654321"],
            onUsAvlFees: 7.0,
            offUsAvlFees: 11.0,
            minValue: nil,
            maxValue: nil,
            avlValue: nil,
            billingAcct: billingAcct,
            beneficiaryWalletNumber: beneficiaryWalletNumber,
            beneficiaryName: nil,
            screenTitle: "AVL FLOW"
        )

        let launchModel = FawryLaunchModel(
            customer: customerInfo,
            merchant: merchantInfo,
            chargeItems: [chargeInfo],
            allowVoucher: false,
            paymentWithCardToken: true,
            skipReceipt: false,
            skipCustomerInput: true,
            avlInfo: avlInfo,
        )

        AnonymousAVLFrameWorkHelper.sharedInstance.launchAVLSDK(
            on: self,
            launchModel: launchModel,
            baseURL: serverURL,
            appLanguage: AppLanguage.English,
            currency: Currency.egp,
            enable3Ds: true,
            authCaptureModePayment: false,
            completionBlock: { status in
                print("AVL: completionBlock \(String(describing: status))")
            },
            onPreCompletionHandler: { error in
                print("AVL: onPreCompletionHandler \(String(describing: error?.message))")
            },
            errorBlock: { error in
                print("AVL: errorBlock code=\(error?.errorCode ?? "") message=\(error?.message ?? "")")
            },
            onPaymentCompletedHandler: { chargeResponse in
                print("AVL: onPaymentCompletedHandler \(String(describing: chargeResponse))")
                if let response = chargeResponse as? PaymentChargeResponse {
                    print("merchantRefNumber=\(response.merchantRefNumber ?? "")")
                    print("orderStatus=\(response.orderStatus ?? "")")
                }
                if let error = chargeResponse as? FawryError {
                    print("error=\(error.message ?? "")")
                }
            },
            onSuccessHandler: { response in
                let merchantRefNumber = (response as? PaymentChargeResponse)?.merchantRefNumber ?? ""
                print("AVL: onSuccessHandler merchantRefNumber=\(merchantRefNumber)")
            }
        )
    }

    @IBAction func launchAnonymousTapped(_ sender: UIButton) {
        let merchantInfo = makeMerchantInfo()
        let checkoutModel = LaunchCheckoutModel(scheme: "myfawry")
        let launchModel = FawryLaunchModel(
            customer: customerInfo,
            merchant: merchantInfo,
            chargeItems: [chargeInfo],
            allowVoucher: true,
            paymentWithCardToken: true,
            skipReceipt: false,
            skipCustomerInput: true,
            paymentMethod: .all,
            checkoutModel: checkoutModel,
            enableToknization: true
        )

        AnonymousAVLFrameWorkHelper.sharedInstance.launchAnonymousSDK(
            on: self,
            launchModel: launchModel,
            baseURL: serverURL,
            appLanguage: AppLanguage.English,
            currency: Currency.egp,
            enable3Ds: true,
            authCaptureModePayment: false,
            completionBlock: { status in
                print("Anonymous: completionBlock \(String(describing: status))")
            },
            onPreCompletionHandler: { error in
                print("Anonymous: onPreCompletionHandler \(String(describing: error?.message))")
            },
            errorBlock: { error in
                print("Anonymous: errorBlock code=\(error?.errorCode ?? "") message=\(error?.message ?? "")")
            },
            onPaymentCompletedHandler: { chargeResponse in
                print("Anonymous: onPaymentCompletedHandler \(String(describing: chargeResponse))")
                if let response = chargeResponse as? PaymentChargeResponse {
                    print("merchantRefNumber=\(response.merchantRefNumber ?? "")")
                    print("orderStatus=\(response.orderStatus ?? "")")
                }
                if let error = chargeResponse as? FawryError {
                    print("error=\(error.message ?? "")")
                }
            },
            onSuccessHandler: { response in
                let merchantRefNumber = (response as? PaymentChargeResponse)?.merchantRefNumber ?? ""
                print("Anonymous: onSuccessHandler merchantRefNumber=\(merchantRefNumber)")
            }
        )
    }

    @IBAction func launchCardManagerTapped(_ sender: UIButton) {
        let merchantInfo = makeMerchantInfo()
        let launchModel = FawryLaunchModel(
            customer: customerInfo,
            merchant: merchantInfo,
            chargeItems: nil,
            allowVoucher: false,
            paymentWithCardToken: false
        )

        AnonymousAVLFrameWorkHelper.sharedInstance.launchCardManagerSDK(
            on: self,
            launchModel: launchModel,
            baseURL: serverURL,
            appLanguage: AppLanguage.English,
            currency: Currency.egp,
            enable3Ds: false,
            errorBlock: { error in
                print("CardManager: errorBlock \(error?.message ?? "")")
            },
            onAddedNewCard: { card in
                print("CardManager: onAddedNewCard \(String(describing: card))")
            },
            dismissBlock: {
                print("CardManager: dismissBlock")
            }
        )
    }

    // MARK: - Helpers

    private func makeMerchantInfo() -> LaunchMerchantModel {
        LaunchMerchantModel(
            merchantCode: merchantCode,
            merchantRefNum: AnonymousAVLFrameWorkHelper.sharedInstance.getMerchantReferenceNumber(),
            secureKey: secureKey
        )
    }
}
