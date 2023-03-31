/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

final class TestAppLinkTargetFactory: AppLinkTargetCreating {
  func createAppLinkTarget(
    url: URL?,
    appStoreId: String?,
    appName: String
  ) -> AppLinkTargetProtocol {
    TestAppLinkTarget(
      url: url,
      appStoreId: appStoreId,
      appName: appName
    )
  }
}
