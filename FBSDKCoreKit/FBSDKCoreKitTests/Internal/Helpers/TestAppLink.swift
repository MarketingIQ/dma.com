/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

final class TestAppLink: AppLinkProtocol {
  var sourceURL: URL?
  var targets = [AppLinkTargetProtocol]()
  var webURL: URL?
  var isBackToReferrer = false
}
