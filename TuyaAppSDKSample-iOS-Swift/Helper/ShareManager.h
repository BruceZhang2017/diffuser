//
//  ShareManager.h
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareManager : NSObject

+ (void)shareFileHandler: (UIActivityViewControllerCompletionWithItemsHandler)handler;

@end

NS_ASSUME_NONNULL_END

