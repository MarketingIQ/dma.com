/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import FBSDKCoreKit

class TestImpressionLoggerFactory: ImpressionLoggerFactoryProtocol {
  let impressionLogger = TestImpressionLogger()
  var capturedEventName: AppEvents.Name?

  func makeImpressionLogger(withEventName eventName: AppEvents.Name) -> ImpressionLogging {
    capturedEventName = eventName

    return impressionLogger
  }
}
