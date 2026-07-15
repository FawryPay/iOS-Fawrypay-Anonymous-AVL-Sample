
  
#

# **FawryPay-AnonymousAVL iOS SDK**

Accept popular payment methods with a single client-side implementation.

## **Before You Start**

Use this integration if you want your Android application to:

- Accept cards and other payment methods.  
- Save and display cards for reuse.

Make sure you have an active FawryPay account, or [**create an account**]([https://atfawry.fawrystaging.com/merchant/register).](https://atfawry.fawrystaging.com/merchant/register). "https://atfawry.fawrystaging.com/merchant/register).")

### **How iOS SDK Looks Like**  
file:///Users/sameh/Downloads/fawrypay_screen_background_color.png

[**Download**](https://github.com/FawryPay/IOS-Fawrypay-AVL-Sample) and test our sample application.

  
------------------------------------------------------------------------  
### **How it works**  
<img width="1320" height="2868" alt="AVLNew" src="https://github.com/user-attachments/assets/eb205bfd-e8e9-47a6-8655-2e0efbc9c4a7" />

On this page, we will walk you through the iOS SDK integration steps:

1. Add FawryPaySDK SPM.  
2. Initialize and Configure FawryPaySDK.  
3. Override the SDK colors.  
4. Return payment processing information and inform your client of the payment result.
## **Step 1: Installing FawryPaySDK**  
This document illustrates how our gateway can be integrated into your iOS application in simple and easy steps. Please follow the steps in order to integrate the FawryPay iOS SDK in your application.

## **Install SPM**  

1. [**Link iOS Anonymous AVL SPM **](https://github.com/FawryPay/FawryPayAnonymousAVLSPM) 
2. add package dependecies version (1.0.0)

## **Step 2: Initialize AVL FLOW**  
1. Create an instance of  
- LaunchCustomerModel  
- LaunchMerchantModel  
- FawryLaunchModel
- AVLInfo

and pass the required parameters (Required and optional parameters are determined below).  
<img width="876" height="616" alt="image" src="[https://github.com/user-attachments/assets/e7a43d87-650d-4d6d-b1e7-bd5c41f053cc"](https://github.com/user-attachments/assets/e7a43d87-650d-4d6d-b1e7-bd5c41f053cc%22 "https://github.com/user-attachments/assets/e7a43d87-650d-4d6d-b1e7-bd5c41f053cc%22") />

LaunchCustomerModel  
| **PARAMETER** | **TYPE** | **REQUIRED** | **DESCRIPTION** | **EXAMPLE** |  
|---------------|---------------|---------------|---------------|---------------|  
| customerName | String | optional | \- | Name Name |  
| customerEmail | String | optional | \- | [email\@email.com](mailto:email@email.com) |  
| customerMobile | String | optional | \- | +0100000000 |  
| customerProfileId | String | optional (required in case of using card tokenization) | \- | 1234 |

**AVLInfo** 
| **PARAMETER** | **TYPE** | **REQUIRED** | **DESCRIPTION** | **EXAMPLE** |  
|---------------|---------------|---------------|---------------|---------------|  
| offUsBTC| Int | mandatory | \- | 4433 |  
| onUsBTC| Int | mandatory | \- | 3344 |  
| internationalBANs| ArrayList [String] | mandatory |BANs related to the bank to use the onUsBTC| arrayListOf("51234 5","5506900 | |  
| onUsAvlFees | Double (should be maximum 2 digits after the decimal point, if the value is more than 2 digits after the decimal point it will be trimmed to 2 digits after the decimal point) | mandatory | \- | 5.0 |  
| offUsAvlFees | Double (should be maximum 2 digits after the decimal point, if the value is more than 2 digits after the decimal point it will be trimmed to 2 digits after the decimal point) | mandatory | \- | 7.0 |  
| minValue | Double | optional | \- | |  
| maxValue | Double | optional | \- |  
avlValue | Double (should be maximum 2 digits after the decimal point, if the value is more than 2 digits after the decimal point it will be trimmed to 2 digits after the decimal point) | mandatory | \- | 7.00 |  
beneficiaryWalletNumber| String | mandatory | \- | “01234567890” |  
| billingAcct | String | mandatory | \- | “01234567890” |  
beneficiaryName| String | optional | \- | “test” |  
| avlAmountDataType| AVLAmountDataType| optional | \It specifies which data type should be accepted in the avl amount | AVLAmountDataType.DOUBLE |  
| shouldShowBeneficiaryName| Boolean| optional | \- | true |  
| shouldShowReasonOfTransfer| Boolean| optional | \- | true |  
| reasonOfTransfer| String | optional | \- | “deposit to wallet” |  
| screenTitle| String | optional | \you can use this attribute to change the screen title of Deposite to wallet | “Deposite to wallet” |  


**LaunchMerchantModel**  
| **PARAMETER** | **TYPE** | **REQUIRED** | **DESCRIPTION** | **EXAMPLE** |  
|---------------|---------------|---------------|---------------|---------------|  
| merchantCode | String | required | Merchant ID provided during FawryPay account setup. | +/IPO2sghiethhN6tMC== | |  
| secureKey | String | required | provided by support | 4b8jw3j2-8gjhfrc-4wc4-scde-453dek3d |

**FawryLaunchModel** 
| **PARAMETER** | **TYPE** | **REQUIRED** | **DESCRIPTION** | **EXAMPLE** |  
|-------------------|--------------------------|--------------|---------------|---------------|  
| customer| LaunchCustomerModel | optional | Customer information. | \- |  
| merchant| LaunchMerchantModel | required | Merchant information. | \- |  
| skipReceipt | Boolean | optional - default value = false| to skip receipt after payment trial| \- |  
| avlInfo | AVLInfo | mandatory | \- | \- |  
| paymentWithCardToken| Boolean | optional | \- | false |

2. Calling Mode:  
- Payment Mode: Call launchAVL from LaunchFawrySdk.launchAVL

| **PARAMETER** | **TYPE** | **REQUIRED** | **DESCRIPTION** | **EXAMPLE** |  
|---------------|---------------|---------------|---------------|---------------|  
| on | UIViewController | required | The UIViewController which will be the starting point of the SDK.| \- |  
| launchModel| FawryLaunchModel| required | Has info that needed to launch the SDK| Example in step 3 |  
| baseURL | String | required | Provided by the support team. Use staging URL for testing and switch for production to go live.| (https://atfawry.fawrystaging.com) (staging) (https://atfawry.com) (production)|  
| appLanguage | String| required | SDK language which will affect SDK's interface languages.|AppLanguage.English|  
| enable3Ds              | Bool             | optional - default value = false | to allow 3D secure payment make it "true"                                                              | true                                                                           |
| completionBlock| AVLCallbacks| required | callbacks to receive the responses for the payment transaction |\-|

## **Step 3: Initialize card manager flow**  
1. Create an instance of  
- LaunchCustomerModel  
- LaunchMerchantModel  
- FawryLaunchModel

LaunchCustomerModel  
| **PARAMETER** | **TYPE** | **REQUIRED** | **DESCRIPTION** | **EXAMPLE** |  
|---------------|---------------|---------------|---------------|---------------|  
| customerName | String | optional | \- | Name Name |  
| customerEmail | String | optional | \- | [email\@email.com](mailto:email@email.com) |  
| customerMobile | String | optional | \- | +0100000000 |  
| customerProfileId | String | required | \- | 1234 |

LaunchMerchantModel  
| **PARAMETER** | **TYPE** | **REQUIRED** | **DESCRIPTION** | **EXAMPLE** |  
|---------------|---------------|---------------|---------------|---------------|  
| merchantCode | String | required | Merchant ID provided during FawryPay account setup. | provided merchantCode |  
| secretCode | String | required | provided by support | provided merchant secret key |

FawryLaunchModel  
| **PARAMETER** | **TYPE** | **REQUIRED** | **DESCRIPTION** | **EXAMPLE** |  
|-------------------|--------------------------|--------------|---------------|---------------|  
| customer| LaunchCustomerModel | optional | Customer information. | \- |  
| merchant| LaunchMerchantModel | required | Merchant information. | \- |

2. Calling Mode:  
- Payment Mode: Call launchCardManagerFlow from LaunchFawrySdk.launchCardManagerFlow

| **PARAMETER** | **TYPE** | **REQUIRED** | **DESCRIPTION** | **EXAMPLE** |  
|---------------|---------------|---------------|---------------|---------------|  
| activity | Activity | required | The activity which will be the starting point of the SDK.| \- |  
| _fawryLaunch Model| FawryLaunchModel| required | Has info that needed to launch the SDK| Example in step 3 |  
| _baseUrl | String | required | Provided by the support team. Use staging URL for testing and switch for production to go live.| (https://atfawry.fawrystaging.com) (staging) (https://atfawry.com) (production)|  
| _languages | Languages| required | SDK language which will affect SDK's interface languages.|Languages.ENGLISH|  
| _callback| CardManagerCallbacks| required | callbacks to receive the responses from the flow |\-|

## **Step 4: Override the SDK colors**  
If you want to change colors: -  
You need to know the ID of the color you want to change then add a color in your colors file in the host app with the same id but with the value you want  
<img width="300" alt="AVL colors" src="[https://github.com/user-attachments/assets/352ea784-d3e8-4a14-ad09-706b2d5dd896"](https://github.com/user-attachments/assets/352ea784-d3e8-4a14-ad09-706b2d5dd896%22 "https://github.com/user-attachments/assets/352ea784-d3e8-4a14-ad09-706b2d5dd896%22") />

If you changed these colors it will change the main screen colors.  
For example:  
<!-- -->  
<color name="fawrypay_screen_header_text_color">#053F5C</color>  
<color name="fawrypay_amount_card_background_color">#EFF7FA</color>  
<color name="fawrypay_labels_color">#003247</color>  
<color name="fawrypay_screen_background_color">#FFFFFF</color>  
<color name="fawrypay_dimmed_button_color">#DDDFDF</color>  
<color name="fawrypay_enabled_button_color">#016891</color>

and for logo you can add a png file in the drawable package and name it fawrypay_logo.png and for fonts you can add fonts in your package with the names:  
<!-- -->  
fawrypay_cairo_semi_bold  
fawrypay_fawry_pro_bold  
fawrypay_cairo_bold  
fawrypay_fawry_pro_bold
<img width="1968" height="1252" alt="image" src="https://github.com/user-attachments/assets/4bff4fec-385c-483b-bbb2-fd6376d8626b" />
<img width="1320" height="2868" alt="fawrypay_screen_background_color" src="https://github.com/user-attachments/assets/ea97eca8-e9ab-4c41-aae5-21eb45aed1b7" />


## **Step 5: Callbacks Explanation:**  

  There are 5 callbacks:
    - **completionBlock: { FawrySDKStatusCode? in } **
        called when flow launched successfully.
    -   **onPreCompletionHandler: { FawryError? in }**\
        called when flow NOT launched.
    -   **errorBlock: { FawryError? in }**
        -   if you enabled the receipt and payment failed, this callback will be called after clicking the done button in the receipt.
        -   if you disabled the receipt and payment failed, this callback will be called upon the finish of the payment screen.
    -   **onPaymentCompletedHandler: { Any ? in }**\
        will be called only whether the payment passed or not. And it's called upon receiving the response of the payment either success or fail.
    -   **onSuccessHandler: {Any ? in }**
        -   if you enabled the receipt and payment succeeded, this callback will be called after clicking the done button in the receipt.
        -   if you disabled the receipt and payment succeeded, this callback will be called upon the finish of the payment screen and the success of the payment.
