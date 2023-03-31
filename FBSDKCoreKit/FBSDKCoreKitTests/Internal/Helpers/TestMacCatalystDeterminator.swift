/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import FBSDKCoreKit
import Foundation

@objcMembers
final class TestMacCatalystDeterminator: _MacCatalystDetermining {
  var stubbedIsMacCatalystApp = false

  var fb_isMacCatalystApp: Bool { // swiftlint:disable:this identifier_name
    stubbedIsMacCatalystApp
  }
}
