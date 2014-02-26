//
//  EEEMacros.h
//  fileee
//
//  Created by Christoph on 3/21/13.
//
//

//Debug Logging
#ifdef DEBUG
#    define DLog(...) NSLog(__VA_ARGS__)
#else
#    define DLog(...) /* */
#endif

//User interface idiom
#define UIIdiomIsPhone                      [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define UIIdiomIsPad                        [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
#define UIScreenIsIphone5                   (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double) 568) < DBL_EPSILON)
#define UIScreenIsRetina                    (([[UIScreen mainScreen] scale] >= 2)?YES:NO)
#define valueForScreen(iphone4, iphone5)    (UIScreenIsIphone5 ? iphone5 : iphone4)

//Units
#define NSLocaleIsMetric [[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue]

//OS Version
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)