//
// TYLoginRegionModel.h
// TuyaSmartBaseKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#ifndef TYRegionModel_h
#define TYRegionModel_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// @brief TYRegionModel is an object of server region.
@interface TYRegionModel : NSObject

/// Region name.
@property (nonatomic, strong) NSString *name;

/// Region code.
@property (nonatomic, strong) NSString *region;

/// Default or not.
@property (nonatomic, assign) BOOL isDefault;

@end

NS_ASSUME_NONNULL_END

#endif /* TYRegionModel_h */
