/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

#if !TARGET_OS_TV

#import <Foundation/Foundation.h>

@protocol FBSDKSwizzling;
@protocol FBSDKEventLogging;
@class FBSDKEventBinding;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(EventBindingManager)
@interface FBSDKEventBindingManager : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithSwizzler:(Class<FBSDKSwizzling>)swizzling
                     eventLogger:(id<FBSDKEventLogging>)eventLogger;
- (void)updateBindings:(NSArray *)bindings;
- (NSArray<FBSDKEventBinding *> *)parseArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END

#endif
