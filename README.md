# **FawryPay Anonymous + AVL iOS SDK**

Accept popular payment methods and AVL (deposit-to-wallet) flows with a single client-side implementation.

## **Before You Start**

Use this integration if you want your iOS application to:

- Accept cards and other payment methods.
- Save and display cards for reuse.
- Launch AVL (deposit to wallet) payments.
- Manage saved cards via Card Manager.

Make sure you have an active FawryPay account, or [**create an account**](https://atfawry.fawrystaging.com/merchant/register).

### **How iOS SDK Looks Like**

<p align="center">
  <img src="https://github.com/user-attachments/assets/96e7b726-08b4-4af7-8e8e-491945ba7b39" alt="Checkout" width="260" />
  <img src="https://github.com/user-attachments/assets/d1809465-65f1-430e-ab92-ed78eb5234cb" alt="Manage Cards" width="260" />
  <img src="https://github.com/user-attachments/assets/5827d86d-cb4d-4f72-9c48-19ced4ba3b35" alt="Payment Receipt" width="260" />
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/eb205bfd-e8e9-47a6-8655-2e0efbc9c4a7" alt="AVL Deposit to wallet" width="260" />
</p>

This sample app demonstrates three SDK flows:

1. **Anonymous Payment** — `launchAnonymousSDK`
2. **AVL Payment** — `launchAVLSDK`
3. **Card Manager** — `launchCardManagerSDK`

On this page we will walk you through iOS SDK integration steps:

1. Installing FawryPayAnonymousAVL SPM.
2. Initialize and configure the SDK models.
3. Launch Anonymous / AVL / Card Manager flows.
4. Override the SDK colors.
5. Handle payment callbacks and results.

---

## **Step 1: Installing FawryPayAnonymousAVL SPM**

1. In Xcode: **File → Add Package Dependencies…**
2. Add package URL:

```
https://github.com/FawryPay/FawryPayAnonymousAVLSPM
```

3. Add the product **FawryPayAnonymousAVL** to your app target.
4. Import the SDK in your Swift file:

```swift
import FawryPaySDK
```

> Related samples:
> - [Anonymous Sample](https://github.com/FawryPay/iOS-Fawrypay-Anonymous-sample)
> - [AVL Sample](https://github.com/FawryPay/IOS-Fawrypay-AVL-Sample)

---

## **Step 2: Shared Models**

Create instances of the models below and pass the required parameters.

<img src="https://github.com/user-attachments/assets/df1f838d-282b-4701-85a7-61844e4f3372" width="600" alt="Initialize models" />

### **LaunchCustomerModel**

| **PARAMETER** | **TYPE** | **REQUIRED** | **DESCRIPTION** | **EXAMPLE** |
|---|---|---|---|---|
| customerName | String | optional | - | Name Name |
| customerEmail | String | optional | - | email@email.com |
| customerMobile | String | optional | - | 01000000000 |
| customerProfileId | String | optional | Mandatory when using saved cards or card tokenization | 1234 |

### **LaunchMerchantModel**

| **PARAMETER** | **TYPE** | **REQUIRED** | **DESCRIPTION** | **EXAMPLE** |
|---|---|---|---|---|
| merchantCode | String | required | Merchant ID provided during FawryPay account setup | +/IPO2sghiethhN6tMC== |
| merchantRefNum | String | required | Merchant transaction reference (random 10 alphanumeric digits). You can call `AnonymousAVLFrameWorkHelper.sharedInstance.getMerchantReferenceNumber()` to generate it | A1YU7MKI09 |
| secureKey | String | required | Provided by support | 4b8jw3j2-8gjhfrc-4wc4-scde-453dek3d |

### **ChargeItemsParamsModel**

| **PARAMETER** | **TYPE** | **REQUIRED** | **DESCRIPTION** | **EXAMPLE** |
|---|---|---|---|---|
| itemId | String | required | - | item-001 |
| charge_description | String | optional | - | Dummy item |
| price | Double | required | - | 100.00 |
| quantity | Int | required | - | 1 |
| account | [Accounts] | optional | - | - |

### **FawryLaunchModel**

| **PARAMETER** | **TYPE** | **REQUIRED** | **DESCRIPTION** | **EXAMPLE** |
|---|---|---|---|---|
| customer | LaunchCustomerModel | optional | Customer information | - |
| merchant | LaunchMerchantModel | required | Merchant information | - |
| chargeItems | [ChargeItemsParamsModel] | required for Anonymous | Items the user will buy | - |
| signature | String | optional | Custom SHA-256 signature | - |
| allowVoucher | Bool | optional — default `false` | `true` if your account supports voucher codes | - |
| paymentWithCardToken | Bool | required for Anonymous | `true` = pay with saved/tokenized cards; `false` = pay with card details without saving | - |
| paymentMethod | Payment_Method | optional — default `.all` | Limit shown payment methods | `.all` / `.payAtFawry` / `.card` / `.wallet` |
| checkoutModel | LaunchCheckoutModel | required for myFawry | Needed if you use myFawry as a payment method | - |
| enableToknization | Bool | optional | `true` to remember/tokenize cards | - |
| skipReceipt | Bool | optional | Skip receipt after payment | `false` |
| skipCustomerInput | Bool | optional | Skip customer input when mobile/email are already provided | `true` |
| avlInfo | AVLInfo | required for AVL | AVL deposit configuration | - |

**Notes:**

- You can pass either `signature` or `secureKey` (the SDK creates the signature internally). If both are passed, `secureKey` is ignored and `signature` is used.
- Signature formula (SHA-256):

```
merchantCode + merchantRefNum + customerProfileId (or "") + itemId + quantity + Price (e.g. "10.00") + Secure hash key
```

---

## **Step 3: Launch Anonymous Payment**

<img src="https://github.com/user-attachments/assets/dcca4442-a1cb-42e1-b2c0-02ece407f48d" width="700" alt="launchAnonymousSDK" />

```swift
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
    completionBlock: { status in },
    onPreCompletionHandler: { error in },
    errorBlock: { error in },
    onPaymentCompletedHandler: { chargeResponse in },
    onSuccessHandler: { response in }
)
```

### **launchAnonymousSDK parameters**

| **PARAMETER** | **TYPE** | **REQUIRED** | **DESCRIPTION** | **EXAMPLE** |
|---|---|---|---|---|
| on | UIViewController | required | Starting view controller for the SDK | self |
| launchModel | FawryLaunchModel | required | Launch configuration | see example above |
| baseURL | String | required | Staging for testing, production to go live | `https://atfawry.fawrystaging.com` / `https://atfawry.com` |
| appLanguage | String | required | SDK UI language | `AppLanguage.English` |
| currency | Currency | required | Payment currency | `Currency.egp` |
| enable3Ds | Bool | optional — default `false` | Enable 3D Secure | `true` |
| authCaptureModePayment | Bool | optional — default `false` | `true` when refund is enabled | `false` |

---

## **Step 4: Launch AVL Flow**

Create `AVLInfo`, attach it to `FawryLaunchModel`, then call `launchAVLSDK`.

<img src="https://github.com/user-attachments/assets/e7a43d87-650d-4d6d-b1e7-bd5c41f053cc" width="700" alt="AVL model init" />

### **AVLInfo**

| **PARAMETER** | **TYPE** | **REQUIRED** | **DESCRIPTION** | **EXAMPLE** |
|---|---|---|---|---|
| onUsBTC | Int | mandatory | - | 13 |
| offUsBTC | Int | mandatory | - | 11 |
| internationalBANs | [String] | mandatory | BANs related to the bank used for onUs BTC | `["123456", "654321"]` |
| onUsAvlFees | Double | mandatory | Max 2 decimal places | 7.0 |
| offUsAvlFees | Double | mandatory | Max 2 decimal places | 11.0 |
| minValue | Double | optional | Min allowed AVL amount | 40.0 |
| maxValue | Double | optional | Max allowed AVL amount | 100.0 |
| avlValue | Double | optional | Max 2 decimal places | 7.00 |
| billingAcct | String | mandatory | - | `"1234567890"` |
| beneficiaryWalletNumber | String | mandatory | - | `"01000000000"` |
| beneficiaryName | String | optional | - | `"test"` |
| avlAmountDataType | AVLAmountDataType | optional | Accepted data type for AVL amount | `AVLAmountDataType.DOUBLE` |
| shouldShowBeneficiaryName | Bool | optional | - | `true` |
| shouldShowReasonOfTransfer | Bool | optional | - | `true` |
| reasonOfTransfer | String | optional | - | `"deposit to wallet"` |
| screenTitle | String | optional | Title for the deposit-to-wallet screen | `"Deposit to wallet"` |

```swift
let avlInfo = AVLInfo(
    onUsBTC: 13,
    offUsBTC: 11,
    internationalBANs: ["123456", "654321"],
    onUsAvlFees: 7.0,
    offUsAvlFees: 11.0,
    minValue: nil,
    maxValue: nil,
    avlValue: nil,
    billingAcct: "1234567890",
    beneficiaryWalletNumber: "01000000000",
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
    avlInfo: avlInfo
)

AnonymousAVLFrameWorkHelper.sharedInstance.launchAVLSDK(
    on: self,
    launchModel: launchModel,
    baseURL: serverURL,
    appLanguage: AppLanguage.English,
    currency: Currency.egp,
    enable3Ds: true,
    authCaptureModePayment: false,
    completionBlock: { status in },
    onPreCompletionHandler: { error in },
    errorBlock: { error in },
    onPaymentCompletedHandler: { chargeResponse in },
    onSuccessHandler: { response in }
)
```

---

## **Step 5: Launch Card Manager**

<img src="https://github.com/user-attachments/assets/c5008ebb-7dc8-4358-82d6-853192b92a88" width="700" alt="launchCardManager" />

```swift
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
    errorBlock: { error in },
    onAddedNewCard: { card in },
    dismissBlock: { }
)
```

> `customerProfileId` is required when managing saved cards.

---

## **Step 6: Override the SDK colors**

### Anonymous / Checkout styling

1. Add a plist file named **Style**.
2. Add keys: `primaryColorHex`, `secondaryColorHex`, `tertiaryColorHex`, `headerColorHex`.

<img src="https://github.com/user-attachments/assets/89790fb4-51bd-4675-a8c1-72ccce933ca8" width="600" alt="Style plist" />

<img src="https://github.com/user-attachments/assets/5b10196e-4215-4e01-947e-f5e6de153c8c" width="280" alt="Color mapping example" />

### AVL styling

Override color resources used by the deposit-to-wallet screen:

<img src="https://github.com/user-attachments/assets/ea97eca8-e9ab-4c41-aae5-21eb45aed1b7" width="280" alt="AVL color keys" />

<img src="https://github.com/user-attachments/assets/352ea784-d3e8-4a14-ad09-706b2d5dd896" width="280" alt="AVL colors" />

---

## **Callbacks Explanation**

### **launchAnonymousSDK / launchAVLSDK**

- **completionBlock** — flow launched successfully
- **onPreCompletionHandler** — flow did not launch
- **errorBlock** — payment failed (after Done if receipt enabled)
- **onPaymentCompletedHandler** — called on success or failure when payment response is received
- **onSuccessHandler** — payment succeeded (after Done if receipt enabled)

### **launchCardManagerSDK**

- **errorBlock** — error occurred
- **onAddedNewCard** — card added successfully
- **dismissBlock** — card manager dismissed

---

## **Run this sample**

1. Open `AnonymousAVLSampleApp.xcodeproj` in Xcode.
2. Resolve Swift packages (`FawryPayAnonymousAVLSPM`).
3. Update `serverURL`, `merchantCode`, and `secureKey` in `ViewController.swift`.
4. Build and run.
5. Use:
   - **Launch AVL**
   - **Launch Anonymous**
   - **Launch Card Manager**
