//
//  STPCategoryLoader.m
//  Stripe
//
//  Created by Jack Flintermann on 10/19/15.
//  Copyright © 2015 Stripe, Inc. All rights reserved.
//

#ifdef STP_STATIC_LIBRARY_BUILD

#import "STPCategoryLoader.h"

#import "NSArray+Stripe_BoundSafe.h"
#import "NSBundle+Stripe_AppName.h"
#import "NSCharacterSet+Stripe.h"
#import "NSDecimalNumber+Stripe_Currency.h"
#import "NSDictionary+Stripe.h"
#import "NSMutableURLRequest+Stripe.h"
#import "NSString+Stripe.h"
#import "NSURLComponents+Stripe.h"
#import "PKPayment+Stripe.h"
#import "PKPaymentAuthorizationViewController+Stripe_Blocks.h"
#import "STPAPIClient+ApplePay.h"
#import "STPAspects.h"
#import "StripeError.h"
#import "UIBarButtonItem+Stripe.h"
#import "UIImage+Stripe.h"
#import "UINavigationBar+Stripe_Theme.h"
#import "UINavigationController+Stripe_Completion.h"
#import "UITableViewCell+Stripe_Borders.h"
#import "UIToolbar+Stripe_InputAccessory.h"
#import "UIView+Stripe_FirstResponder.h"
#import "UIViewController+Stripe_KeyboardAvoiding.h"
#import "UIViewController+Stripe_NavigationItemProxy.h"
#import "UIViewController+Stripe_ParentViewController.h"
#import "UIViewController+Stripe_Promises.h"

@implementation STPCategoryLoader

+ (void)loadCategories {
    linkAspectsCategory();
    linkNSArrayBoundSafeCategory();
    linkNSBundleAppNameCategory();
    linkNSDecimalNumberCurrencyCategory();
    linkNSDictionaryCategory();
    linkNSErrorCategory();
    linkNSMutableURLRequestCategory();
    linkNSStringCategory();
    linkNSURLComponentsCategory();
    linkPKPaymentAuthorizationViewControllerBlocksCategory();
    linkPKPaymentCategory();
    linkSTPAPIClientApplePayCategory();
    linkUIBarButtonItemCategory();
    linkUIImageCategory();
    linkUINavigationBarThemeCategory();
    linkUINavigationControllerCompletionCategory();
    linkUITableViewCellBordersCategory();
    linkUIToolbarInputAccessoryCategory();
    linkUIViewControllerKeyboardAvoidingCategory();
    linkUIViewControllerNavigationItemProxyCategory();
    linkUIViewControllerParentViewControllerCategory();
    linkUIViewControllerPromisesCategory();
    linkUIViewFirstResponderCategory();
    linkNSCharacterSetCategory();
}

@end

#endif
