/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "FBSDKGraphRequest+Internal.h"

NS_ASSUME_NONNULL_BEGIN

@interface FBSDKGraphRequest (Testing)

@property (nullable, nonatomic, strong) id<FBSDKGraphRequestConnectionFactory> graphRequestConnectionFactory;

#if DEBUG
+ (void)resetClassDependencies;
#endif

@end

NS_ASSUME_NONNULL_END
