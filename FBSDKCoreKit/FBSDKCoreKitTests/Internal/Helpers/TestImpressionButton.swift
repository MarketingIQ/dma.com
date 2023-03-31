/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import FBSDKCoreKit
import TestTools
import XCTest

import Foundation

class TestImpressionButton: ImpressionLoggingButton, FBButtonImpressionLogging {
  var analyticsParameters: [String: Any]? = ["foo": "bar"]
  var impressionTrackingEventName = AppEvents.Name("testImpressionTrackingEventName")
  var impressionTrackingIdentifier = "testImpressionTrackingIdentifier"
}
