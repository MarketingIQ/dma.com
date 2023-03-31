/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

@testable import FBSDKCoreKit
import XCTest

@objcMembers
// swiftlint:disable:next line_length
final class TestAppEventsUtility: NSObject, _AppEventDropDetermining, _AppEventParametersExtracting, _AppEventsUtilityProtocol, _LoggingNotifying {
  var shouldDropAppEvents = false
  var unixTimeNow = TimeInterval(0)
  var stubbedIsIdentifierValid = false
  var stubbedTokenStringToUse: String?

  func activityParametersDictionary(
    forEvent eventCategory: String,
    shouldAccessAdvertisingID: Bool,
    userID: String?,
    userData: String?
  ) -> NSMutableDictionary {
    ["event": eventCategory]
  }

  func ensure(onMainThread methodName: String, className: String) {}

  func convert(toUnixTime date: Date?) -> TimeInterval {
    0
  }

  func validateIdentifier(_ identifier: String?) -> Bool {
    stubbedIsIdentifierValid
  }

  func tokenStringToUse(for token: AccessToken?, loggingOverrideAppID: String?) -> String? {
    stubbedTokenStringToUse
  }

  func flushReason(toString flushReason: AppEvents.FlushReason) -> String {
    ""
  }

  func logAndNotify(_ message: String) {}

  func logAndNotify(_ message: String, allowLogAsDeveloperError: Bool) {}
}
