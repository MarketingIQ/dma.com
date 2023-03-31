/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(RulesFromKeyProvider)
@protocol FBSDKRulesFromKeyProvider

- (nullable NSDictionary<NSString *, id> *)getRulesForKey:(NSString *)useCase;

@end

NS_ASSUME_NONNULL_END
