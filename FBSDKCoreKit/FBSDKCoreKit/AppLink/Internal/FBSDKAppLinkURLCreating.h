/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

#if !TARGET_OS_TV

#import <Foundation/Foundation.h>

#import "FBSDKAppLinkURL.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(AppLinkURLCreating)
@protocol FBSDKAppLinkURLCreating

- (id<FBSDKAppLinkURL>)createAppLinkURLWithURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END

#endif
