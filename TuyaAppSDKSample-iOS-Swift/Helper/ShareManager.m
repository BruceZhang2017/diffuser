//
//  ShareManager.m
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "ShareManager.h"
#import <UIKit/UIKit.h>

@implementation ShareManager

+ (void)shareFileHandler: (UIActivityViewControllerCompletionWithItemsHandler)handler{

    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
      NSString * sourcePath = [documentPath stringByAppendingPathComponent:@"diffuser.log"];//  源文件路径
    //文件链接

    NSURL*urlToShare = [NSURL fileURLWithPath:sourcePath];

    //文件二进制数据

    NSData*data = [NSData dataWithContentsOfFile: sourcePath];

    NSArray*activityItems =@[data, urlToShare];

    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];

    //不出现在活动项目

    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];

    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:activityVC animated:YES completion:nil];

    // 分享之后的回调

    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType,BOOL completed,NSArray*_Nullable returnedItems,NSError*_Nullable activityError) {

        handler(activityType, completed, returnedItems, activityError);

    };

}

@end
