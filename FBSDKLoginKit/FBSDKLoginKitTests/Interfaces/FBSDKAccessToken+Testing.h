/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

@import FBSDKCoreKit;

NS_ASSUME_NONNULL_BEGIN

@interface FBSDKAccessToken (Testing)

+ (void)setCurrentAccessToken:(nullable FBSDKAccessToken *)token
          shouldDispatchNotif:(BOOL)shouldDispatchNotif;

+ (void)resetClassDependencies;
+ (void)resetCurrentAccessTokenCache;

@end

NS_ASSUME_NONNULL_END
