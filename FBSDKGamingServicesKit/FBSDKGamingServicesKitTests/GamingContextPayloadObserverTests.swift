/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

@testable import FBSDKCoreKit
@testable import FBSDKGamingServicesKit
import XCTest

final class GamingContextPayloadObserverTests: XCTestCase {
  // swiftlint:disable implicitly_unwrapped_optional
  var gamingContextDelegate: GamingContextPayloadObserverDelegate!
  var gamingContextObserver: GamingPayloadObserver!
  // swiftlint:enable implicitly_unwrapped_optional

  override func setUp() {
    super.setUp()

    gamingContextDelegate = GamingContextPayloadObserverDelegate()
    gamingContextObserver = GamingPayloadObserver(delegate: gamingContextDelegate)
  }

  override func tearDown() {
    gamingContextDelegate = nil
    gamingContextObserver = nil

    super.tearDown()
  }

  // MARK: - GamingContextObserver

  func testCreatingGamingContextObserver() {
    XCTAssertTrue(
      gamingContextObserver.delegate === gamingContextDelegate,
      "Should store the delegate it was created with"
    )
    XCTAssertTrue(
      ApplicationDelegate.shared.applicationObservers.contains(gamingContextObserver),
      "Should observe the shared application delegate upon creation"
    )
  }

  func testGamingContextObserverOpeningInvalid() throws {
    let url = try XCTUnwrap(URL(string: "file://foo"))
    XCTAssertFalse(
      gamingContextObserver.application(
        UIApplication.shared,
        open: url,
        sourceApplication: nil,
        annotation: nil
      ),
      "Should not successfully open an invalid url"
    )

    XCTAssertFalse(
      gamingContextDelegate.wasGamingContextDelegateCalled,
      "Should not invoke the delegate method parsedGamingContextURLContaining for an invalid url"
    )
  }

  func testGamingContextObserverOpeningURLWithMissingKeys() throws {
    let url = try SampleUnparsedAppLinkURLs.missingKeys()

    XCTAssertFalse(
      gamingContextObserver.application(
        UIApplication.shared,
        open: url,
        sourceApplication: nil,
        annotation: nil
      ),
      "Should not successfully open a url with missing extras"
    )

    XCTAssertFalse(
      gamingContextDelegate.wasGamingContextDelegateCalled,
      "Should not invoke the delegate method parsedGamingContextURLContaining for an invalid url"
    )
  }

  func testOpeningURLWithMissingGameContextTokenID() throws {
    let url = try SampleUnparsedAppLinkURLs.create(contextTokenID: nil)
    XCTAssertFalse(
      gamingContextObserver.application(
        UIApplication.shared,
        open: url,
        sourceApplication: nil,
        annotation: nil
      ),
      "Should not successfully open a url with a missing game request ID"
    )
    XCTAssertFalse(
      gamingContextDelegate.wasGamingContextDelegateCalled,
      "Should not invoke the delegate method parsedGamingContextURLContaining for an invalid url"
    )
  }

  func testGamingContextObserverOpeningURLWithMissingPayload() throws {
    let url = try SampleUnparsedAppLinkURLs.create(payload: nil)
    XCTAssertFalse(
      gamingContextObserver.application(
        UIApplication.shared,
        open: url,
        sourceApplication: nil,
        annotation: nil
      ),
      "Should not successfully open a url with a missing payload"
    )
    XCTAssertFalse(
      gamingContextDelegate.wasGamingContextDelegateCalled,
      "Should not invoke the delegate method parsedGamingContextURLContaining for an invalid url"
    )
  }

  func testOpeningWithValidGamingContextURL() throws {
    let url = try SampleUnparsedAppLinkURLs.validGamingContextUrl()
    XCTAssertTrue(
      gamingContextObserver.application(
        UIApplication.shared,
        open: url,
        sourceApplication: nil,
        annotation: nil
      ),
      "Should successfully open a url with a valid payload"
    )

    XCTAssertTrue(
      gamingContextDelegate.wasGamingContextDelegateCalled,
      "Should invoke the delegate method parsedGamingContextURLContaining for a url with a valid payload"
    )
    XCTAssertEqual(
      gamingContextDelegate.capturedPayload?.payload,
      SampleUnparsedAppLinkURLs.Values.payload,
      "Should invoke the delegate with the expected payload"
    )
  }
}

final class GamingContextPayloadObserverDelegate: NSObject, GamingPayloadDelegate {
  var wasGamingContextDelegateCalled = false
  var capturedPayload: GamingPayload?

  func parsedGamingContextURLContaining(_ payload: GamingPayload) {
    wasGamingContextDelegateCalled = true
    capturedPayload = payload
  }
}
