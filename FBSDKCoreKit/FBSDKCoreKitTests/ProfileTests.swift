/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

@testable import FBSDKCoreKit

import TestTools
import XCTest

final class ProfileTests: XCTestCase {
  // swiftlint:disable implicitly_unwrapped_optional
  var dataStore: UserDefaultsSpy!
  var notificationCenter: TestNotificationCenter!
  var settings: TestSettings!
  var urlHoster: TestURLHoster!
  var profile: Profile!
  var testGraphRequest: TestGraphRequest!
  var result: [String: Any]!
  var imageURL: URL!
  // swiftlint:enable implicitly_unwrapped_optional

  let stubbedURL = URL(string: "testProfile.com")! // swiftlint:disable:this force_unwrapping
  let accessTokenKey = "access_token"
  let pictureModeKey = "type"
  let widthKey = "width"
  let heightKey = "height"
  let sdkVersion = "100"
  let validClientToken = "Foo"

  static let validSquareSize = CGSize(width: 100, height: 100)
  static let validNonSquareSize = CGSize(width: 10, height: 20)

  override func setUp() {
    super.setUp()

    dataStore = UserDefaultsSpy()
    notificationCenter = TestNotificationCenter()
    settings = TestSettings()
    urlHoster = TestURLHoster(url: stubbedURL)
    profile = SampleUserProfiles.createValid()
    testGraphRequest = TestGraphRequest()

    result = [
      "id": profile.userID,
      "first_name": profile.firstName as Any,
      "middle_name": profile.middleName as Any,
      "last_name": profile.lastName as Any,
      "name": profile.name as Any,
      "link": profile.linkURL as Any,
      "email": profile.email as Any,
    ]

    Settings.shared.graphAPIVersion = sdkVersion
    TestAccessTokenWallet.reset()
    Profile.resetCurrentProfileCache()
    Profile.configure(
      dataStore: dataStore,
      accessTokenProvider: TestAccessTokenWallet.self,
      notificationCenter: notificationCenter,
      settings: settings,
      urlHoster: urlHoster
    )
  }

  override func tearDown() {
    super.tearDown()

    Profile.reset()
    TestAccessTokenWallet.reset()
    Profile.resetCurrentProfileCache()
  }

  private func makeImageURL(
    mode: Profile.PictureMode = .normal,
    size: CGSize = ProfileTests.validSquareSize
  ) throws {
    imageURL = try XCTUnwrap(
      profile.imageURL(
        forMode: mode,
        size: size
      )
    )
  }

  func testCreatingImageURL() throws {
    try makeImageURL()
    XCTAssertEqual(urlHoster.capturedHostPrefix, "graph")
    XCTAssertEqual(urlHoster.capturedPath, "\(profile.userID)/picture")
    XCTAssertNotNil(urlHoster.capturedQueryParameters)
    XCTAssertEqual(imageURL, urlHoster.stubbedURL)
  }

  // MARK: - Creating Image URL

  func testCreatingImageURLWithNoAccessTokenNoClientToken() throws {
    try makeImageURL()
    let queryItems = try XCTUnwrap(urlHoster.capturedQueryParameters)
    XCTAssertEqual(
      queryItems[pictureModeKey],
      "normal",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[widthKey],
      "100",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[heightKey],
      "100",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
  }

  func testCreatingImageURLWithClientTokenNoAccessToken() throws {
    settings.clientToken = validClientToken
    try makeImageURL()

    let queryItems = try XCTUnwrap(urlHoster.capturedQueryParameters)
    XCTAssertEqual(
      queryItems[pictureModeKey],
      "normal",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[widthKey],
      "100",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[heightKey],
      "100",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[accessTokenKey],
      "Foo",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
  }

  func testCreatingImageURLWithAccessTokenNoClientToken() throws {
    TestAccessTokenWallet.currentAccessToken = SampleAccessTokens.validToken
    try makeImageURL()

    let queryItems = try XCTUnwrap(urlHoster.capturedQueryParameters)
    XCTAssertEqual(
      queryItems[pictureModeKey],
      "normal",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[widthKey],
      "100",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[heightKey],
      "100",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[accessTokenKey],
      SampleAccessTokens.validToken.tokenString,
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
  }

  func testCreatingImageURLWithAccessTokenAndClientToken() throws {
    TestAccessTokenWallet.currentAccessToken = SampleAccessTokens.validToken
    settings.clientToken = validClientToken
    try makeImageURL()

    let queryItems = try XCTUnwrap(urlHoster.capturedQueryParameters)
    XCTAssertEqual(
      queryItems[pictureModeKey],
      "normal",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[widthKey],
      "100",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[heightKey],
      "100",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[accessTokenKey],
      SampleAccessTokens.validToken.tokenString,
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
  }

  func testCreatingEnumWithSmallMode() throws {
    try makeImageURL(mode: .small, size: Self.validNonSquareSize)

    let queryItems = try XCTUnwrap(urlHoster.capturedQueryParameters)
    XCTAssertEqual(
      queryItems[pictureModeKey],
      "small",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[widthKey],
      "10",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[heightKey],
      "20",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
  }

  func testCreatingEnumWithAlbumMode() throws {
    try makeImageURL(mode: .album, size: Self.validNonSquareSize)

    let queryItems = try XCTUnwrap(urlHoster.capturedQueryParameters)
    XCTAssertEqual(
      queryItems[pictureModeKey],
      "album",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[widthKey],
      "10",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[heightKey],
      "20",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
  }

  func testCreatingEnumWithLargeMode() throws {
    try makeImageURL(mode: .large, size: Self.validNonSquareSize)

    let queryItems = try XCTUnwrap(urlHoster.capturedQueryParameters)
    XCTAssertEqual(
      queryItems[pictureModeKey],
      "large",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[widthKey],
      "10",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[heightKey],
      "20",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
  }

  func testCreatingEnumWithSquareMode() throws {
    try makeImageURL(mode: .square, size: Self.validNonSquareSize)

    let queryItems = try XCTUnwrap(urlHoster.capturedQueryParameters)
    XCTAssertEqual(
      queryItems[pictureModeKey],
      "square",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[widthKey],
      "10",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[heightKey],
      "20",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
  }

  // MARK: - Size Validations

  func testCreatingImageURLWithNoSize() throws {
    try makeImageURL(mode: .square, size: .zero)

    let queryItems = try XCTUnwrap(urlHoster.capturedQueryParameters)
    XCTAssertEqual(
      queryItems[pictureModeKey],
      "square",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[widthKey],
      "0",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[heightKey],
      "0",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
  }

  func testCreatingSquareImageURLWithNonSquareSize() throws {
    try makeImageURL(mode: .square, size: Self.validNonSquareSize)

    let queryItems = try XCTUnwrap(urlHoster.capturedQueryParameters)
    XCTAssertEqual(
      queryItems[pictureModeKey],
      "square",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[widthKey],
      "10",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[heightKey],
      "20",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
  }

  func testCreatingSquareImageURLWithNegativeSize() throws {
    try makeImageURL(mode: .square, size: CGSize(width: -10, height: -10))

    let queryItems = try XCTUnwrap(urlHoster.capturedQueryParameters)
    XCTAssertEqual(
      queryItems[pictureModeKey],
      "square",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[widthKey],
      "-10",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
    XCTAssertEqual(
      queryItems[heightKey],
      "-10",
      "Should add the expected query items to a url when creating a url for fetching a profile image"
    )
  }

  // MARK: - Profile Loading

  func testGraphPathForProfileLoadWithLinkPermission() {
    verfiyGraphPath(
      expectedPath: "me?fields=id,first_name,middle_name,last_name,name,link",
      permissions: ["user_link"]
    )
  }

  func testGraphPathForProfileLoadWithNoPermission() {
    verfiyGraphPath(
      expectedPath: "me?fields=id,first_name,middle_name,last_name,name",
      permissions: []
    )
  }

  func testGraphPathForProfileLoadWithEmailPermission() {
    verfiyGraphPath(
      expectedPath: "me?fields=id,first_name,middle_name,last_name,name,email",
      permissions: ["email"]
    )
  }

  func testGraphPathForProfileLoadWithFriendsPermission() {
    verfiyGraphPath(
      expectedPath: "me?fields=id,first_name,middle_name,last_name,name,friends",
      permissions: ["user_friends"]
    )
  }

  func testGraphPathForProfileLoadWithBirthdayPermission() {
    verfiyGraphPath(
      expectedPath: "me?fields=id,first_name,middle_name,last_name,name,birthday",
      permissions: ["user_birthday"]
    )
  }

  func testGraphPathForProfileLoadWithAgeRangePermission() {
    verfiyGraphPath(
      expectedPath: "me?fields=id,first_name,middle_name,last_name,name,age_range",
      permissions: ["user_age_range"]
    )
  }

  func testGraphPathForProfileLoadWithHometownPermission() {
    verfiyGraphPath(
      expectedPath: "me?fields=id,first_name,middle_name,last_name,name,hometown",
      permissions: ["user_hometown"]
    )
  }

  func testGraphPathForProfileLoadWithLocationPermission() {
    verfiyGraphPath(
      expectedPath: "me?fields=id,first_name,middle_name,last_name,name,location",
      permissions: ["user_location"]
    )
  }

  func testGraphPathForProfileLoadWithGenderPermission() {
    verfiyGraphPath(
      expectedPath: "me?fields=id,first_name,middle_name,last_name,name,gender",
      permissions: ["user_gender"]
    )
  }

  func testLoadingProfile() throws {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd/yyyy"
    var capturedProfile: Profile?
    var capturedError: Error?

    Profile.load(
      token: SampleAccessTokens.validToken,
      request: testGraphRequest
    ) {
      capturedProfile = $0
      capturedError = $1
    }

    let completion = try XCTUnwrap(testGraphRequest.capturedCompletionHandler)
    completion(nil, sampleGraphResult(), nil)
    XCTAssertNil(capturedError)
    let profile = try XCTUnwrap(capturedProfile, "capturedProfile should not be nil")
    let expectedProfile = SampleUserProfiles.createValid()
    XCTAssertEqual(profile.firstName, expectedProfile.firstName)
    XCTAssertEqual(profile.middleName, expectedProfile.middleName)
    XCTAssertEqual(profile.lastName, expectedProfile.lastName)
    XCTAssertEqual(profile.name, expectedProfile.name)
    XCTAssertEqual(profile.userID, expectedProfile.userID)
    XCTAssertEqual(profile.linkURL, expectedProfile.linkURL)
    XCTAssertEqual(profile.email, expectedProfile.email)
    XCTAssertEqual(profile.friendIDs, expectedProfile.friendIDs)
    XCTAssertEqual(
      formatter.string(from: profile.birthday ?? Date()),
      "01/01/1990"
    )
    XCTAssertEqual(profile.ageRange, expectedProfile.ageRange)
    XCTAssertEqual(profile.hometown, expectedProfile.hometown)
    XCTAssertEqual(profile.gender, expectedProfile.gender)
    XCTAssertEqual(profile.location, expectedProfile.location)
  }

  func testLoadingProfileWithInvalidLink() throws {
    result["link"] = "   "

    var capturedProfile: Profile?
    var capturedError: Error?

    Profile.load(
      token: SampleAccessTokens.validToken,
      request: testGraphRequest
    ) {
      capturedProfile = $0
      capturedError = $1
    }

    let completion = try XCTUnwrap(testGraphRequest.capturedCompletionHandler)
    completion(nil, result, nil)
    XCTAssertNil(capturedError)
    let profile = try XCTUnwrap(capturedProfile, "capturedProfile should not be nil")
    XCTAssertNil(profile.linkURL)
  }

  func testProfileNilWithNilAccessToken() {
    var capturedProfile: Profile?
    var capturedError: Error?

    Profile.load(
      token: nil,
      request: testGraphRequest
    ) {
      capturedProfile = $0
      capturedError = $1
    }
    XCTAssertEqual(
      testGraphRequest.startCallCount,
      0,
      "Should not fetch a profile if there is no access token"
    )
    XCTAssertNil(capturedProfile)
    XCTAssertNil(capturedError)
  }

  func testLoadingProfileWithNoFriends() throws {
    result["friends"] = ["data": []]
    var capturedProfile: Profile?
    var capturedError: Error?

    Profile.load(
      token: SampleAccessTokens.validToken,
      request: testGraphRequest
    ) {
      capturedProfile = $0
      capturedError = $1
    }

    let completion = try XCTUnwrap(testGraphRequest.capturedCompletionHandler)
    completion(nil, result, nil)
    XCTAssertNil(capturedError)
    let profile = try XCTUnwrap(capturedProfile, "capturedProfile should not be nil")
    XCTAssertNil(profile.friendIDs)
  }

  func testLoadingProfileWithInvalidFriends() throws {
    result["friends"] = "   "
    var capturedProfile: Profile?
    var capturedError: Error?

    Profile.load(
      token: SampleAccessTokens.validToken,
      request: testGraphRequest
    ) {
      capturedProfile = $0
      capturedError = $1
    }

    let completion = try XCTUnwrap(testGraphRequest.capturedCompletionHandler)
    completion(nil, result, nil)
    XCTAssertNil(capturedError)
    let profile = try XCTUnwrap(capturedProfile, "capturedProfile should not be nil")
    XCTAssertNil(profile.friendIDs)
  }

  func testLoadingProfileWithInvalidBirthday() throws {
    result["birthday"] = 123
    var capturedProfile: Profile?
    var capturedError: Error?

    Profile.load(
      token: SampleAccessTokens.validToken,
      request: testGraphRequest
    ) {
      capturedProfile = $0
      capturedError = $1
    }

    let completion = try XCTUnwrap(testGraphRequest.capturedCompletionHandler)
    completion(nil, result, nil)
    XCTAssertNil(capturedError)
    let profile = try XCTUnwrap(capturedProfile, "capturedProfile should not be nil")
    XCTAssertNil(profile.birthday)
  }

  func testLoadingProfileWithInvalidAgeRange() throws {
    result["ageRange"] = "ageRange"
    var capturedProfile: Profile?
    var capturedError: Error?

    Profile.load(
      token: SampleAccessTokens.validToken,
      request: testGraphRequest
    ) {
      capturedProfile = $0
      capturedError = $1
    }

    let completion = try XCTUnwrap(testGraphRequest.capturedCompletionHandler)
    completion(nil, result, nil)
    XCTAssertNil(capturedError)
    let profile = try XCTUnwrap(capturedProfile, "capturedProfile should not be nil")
    XCTAssertNil(profile.ageRange)
  }

  func testLoadingProfileWithInvalidHometown() throws {
    result["hometown"] = "hometown"
    var capturedProfile: Profile?
    var capturedError: Error?

    Profile.load(
      token: SampleAccessTokens.validToken,
      request: testGraphRequest
    ) {
      capturedProfile = $0
      capturedError = $1
    }

    let completion = try XCTUnwrap(testGraphRequest.capturedCompletionHandler)
    completion(nil, result, nil)
    XCTAssertNil(capturedError)
    let profile = try XCTUnwrap(capturedProfile, "capturedProfile should not be nil")
    XCTAssertNil(profile.hometown)
  }

  func testLoadingProfileWithInvalidLocation() throws {
    result["location"] = "location"
    var capturedProfile: Profile?
    var capturedError: Error?

    Profile.load(
      token: SampleAccessTokens.validToken,
      request: testGraphRequest
    ) {
      capturedProfile = $0
      capturedError = $1
    }

    let completion = try XCTUnwrap(testGraphRequest.capturedCompletionHandler)
    completion(nil, result, nil)
    XCTAssertNil(capturedError)
    let profile = try XCTUnwrap(capturedProfile, "capturedProfile should not be nil")
    XCTAssertNil(profile.location)
  }

  func testLoadingProfileWithInvalidGender() throws {
    result["gender"] = [:]
    var capturedProfile: Profile?
    var capturedError: Error?

    Profile.load(
      token: SampleAccessTokens.validToken,
      request: testGraphRequest
    ) {
      capturedProfile = $0
      capturedError = $1
    }

    let completion = try XCTUnwrap(testGraphRequest.capturedCompletionHandler)
    completion(nil, result, nil)
    XCTAssertNil(capturedError)
    let profile = try XCTUnwrap(capturedProfile, "capturedProfile should not be nil")
    XCTAssertNil(profile.gender)
  }

  func testProfileNotRefreshedIfNotStale() throws {
    Profile.current = profile
    var capturedProfile: Profile?
    var capturedError: Error?

    Profile.load(
      token: nil,
      request: testGraphRequest
    ) {
      capturedProfile = $0
      capturedError = $1
    }
    XCTAssertEqual(
      testGraphRequest.startCallCount,
      0,
      "Should not fetch a profile if it is not stale"
    )
    XCTAssertNil(capturedError)
    let profile = try XCTUnwrap(capturedProfile, "capturedProfile should not be nil")
    let expectedProfile = SampleUserProfiles.createValid()
    XCTAssertEqual(profile.firstName, expectedProfile.firstName)
    XCTAssertEqual(profile.middleName, expectedProfile.middleName)
    XCTAssertEqual(profile.lastName, expectedProfile.lastName)
    XCTAssertEqual(profile.name, expectedProfile.name)
    XCTAssertEqual(profile.userID, expectedProfile.userID)
    XCTAssertEqual(profile.linkURL, expectedProfile.linkURL)
    XCTAssertEqual(profile.email, expectedProfile.email)
  }

  func testLoadingProfileWithLimitedProfileWithoutToken() throws {
    let expected = SampleUserProfiles.validLimited
    Profile.current = expected
    let request = TestGraphRequest()
    var capturedProfile: Profile?
    var capturedError: Error?

    Profile.load(
      token: nil,
      request: testGraphRequest
    ) {
      capturedProfile = $0
      capturedError = $1
    }

    XCTAssertEqual(
      request.startCallCount,
      0,
      "Should not fetch a profile if there is no access token"
    )
    XCTAssertNil(capturedError)
    let profile = try XCTUnwrap(capturedProfile, "capturedProfile should not be nil")
    XCTAssertEqual(
      profile,
      expected,
      "Should return the current profile synchronously"
    )
  }

  func testLoadingProfileWithLimitedProfileWithToken() {
    Profile.current = SampleUserProfiles.validLimited
    let request = TestGraphRequest()
    Profile.load(
      token: SampleAccessTokens.validToken,
      request: request
    ) { _, _ in
      XCTFail("Should not invoke the completion")
    }
    XCTAssertEqual(
      request.startCallCount,
      1,
      "Should fetch a profile if it is limited and there is an access token"
    )
  }

  func testLoadingProfileWithExpiredNonLimitedProfileWithToken() {
    let expected = SampleUserProfiles.createValid(isExpired: true)
    Profile.current = expected
    let request = TestGraphRequest()
    Profile.load(
      token: SampleAccessTokens.validToken,
      request: request
    ) { _, _ in
      XCTFail("Should not invoke the completion")
    }
    XCTAssertEqual(
      request.startCallCount,
      1,
      "Should fetch a profile if it is expired and there is an access token"
    )
  }

  func testLoadingProfileWithCurrentlyLoadingProfile() {
    let expected = SampleUserProfiles.createValid(isExpired: true)
    Profile.current = expected
    let request = TestGraphRequest()
    let connection = TestGraphRequestConnection()
    request.stubbedConnection = connection
    Profile.load(
      token: SampleAccessTokens.validToken,
      request: request
    ) { _, _ in
      XCTFail("Should not invoke the completion")
    }
    Profile.load(
      token: SampleAccessTokens.validToken,
      request: request
    ) { _, _ in
      XCTFail("Should not invoke the completion")
    }
    XCTAssertEqual(
      connection.cancelCallCount,
      1,
      "Should cancel an existing connection if a new connection is started before it completes"
    )
  }

  func testProfileParseBlockInvokedOnSuccessfulGraphRequest() throws {
    let result: [String: String] = [:]
    var capturedProfileRef: AutoreleasingUnsafeMutablePointer<Profile>?
    var capturedResult: Any?
    Profile.load(
      with: SampleAccessTokens.validToken,
      graphRequest: testGraphRequest,
      completion: { _, _ in },
      parseBlock: {
        capturedResult = $0
        capturedProfileRef = $1
      }
    )
    let completion = try XCTUnwrap(testGraphRequest.capturedCompletionHandler)
    completion(nil, result, nil)
    XCTAssertNotNil(capturedProfileRef)
    XCTAssertNotNil(capturedResult)
  }

  func testProfileParseBlockShouldHaveNonNullPointer() throws {
    let result: [String: String] = [:]
    var capturedProfileRef: AutoreleasingUnsafeMutablePointer<Profile>?
    var capturedResult: Any?
    Profile.load(
      with: SampleAccessTokens.validToken,
      graphRequest: testGraphRequest,
      completion: { _, _ in },
      parseBlock: {
        capturedResult = $0
        capturedProfileRef = $1
      }
    )
    let completion = try XCTUnwrap(testGraphRequest.capturedCompletionHandler)
    completion(nil, result, nil)
    XCTAssertNotNil(capturedProfileRef)
    XCTAssertNotNil(capturedResult)
  }

  func testProfileParseBlockReturnsNilIfResultIsEmpty() throws {
    let result: [String: String] = [:]
    Profile.load(token: SampleAccessTokens.validToken, request: testGraphRequest, completion: nil)

    let completion = try XCTUnwrap(testGraphRequest.capturedCompletionHandler)
    completion(nil, result, nil)
    XCTAssertNil(Profile.current)
  }

  func testProfileParseBlockReturnsNilIfResultHasNoID() throws {
    let result = [
      "first_name": "firstname",
      "middle_name": "middlename",
      "last_name": "lastname",
      "name": "name",
    ]
    Profile.load(token: SampleAccessTokens.validToken, request: testGraphRequest, completion: nil)
    let completion = try XCTUnwrap(testGraphRequest.capturedCompletionHandler)
    completion(nil, result, nil)
    XCTAssertNil(Profile.current)
  }

  func testProfileParseBlockReturnsNilIfResultHasEmptyID() throws {
    result["id"] = ""
    Profile.load(token: SampleAccessTokens.validToken, request: testGraphRequest, completion: nil)
    let completion = try XCTUnwrap(testGraphRequest.capturedCompletionHandler)
    completion(nil, result, nil)
    XCTAssertNil(Profile.current)
  }

  func testLoadProfileWithRandomData() throws {
    for _ in 0 ..< 100 {
      let randomizedResult = Fuzzer.randomize(json: sampleGraphResult())
      var completed = false
      Profile.load(
        token: SampleAccessTokens.validToken,
        request: testGraphRequest
      ) { _, _ in
        completed = true
      }
      let completion = try XCTUnwrap(testGraphRequest.capturedCompletionHandler)
      completion(nil, randomizedResult, nil)
      XCTAssert(completed, "Completion handler should be invoked synchronously")
    }
  }

  // MARK: Update Notifications

  func testClearingMissingProfile() {
    Profile.setCurrent(nil, shouldPostNotification: true)
    XCTAssertTrue(
      notificationCenter.capturedPostNames.isEmpty,
      "Clearing an empty current profile should not post a notification"
    )
  }

  func testClearingProfile() {
    Profile.setCurrent(profile, shouldPostNotification: false)
    notificationCenter.capturedPostNames = []

    Profile.setCurrent(nil, shouldPostNotification: true)

    XCTAssertFalse(
      notificationCenter.capturedPostNames.isEmpty,
      "Clearing the current profile should post a notification"
    )
  }

  func testSettingProfile() {
    Profile.setCurrent(profile, shouldPostNotification: true)

    XCTAssertFalse(
      notificationCenter.capturedPostNames.isEmpty,
      "Setting the current profile to `nil` should post a notification"
    )
  }

  func testSettingSameProfile() {
    Profile.setCurrent(profile, shouldPostNotification: true)
    notificationCenter.capturedPostNames = []

    Profile.setCurrent(profile, shouldPostNotification: true)

    XCTAssertTrue(
      notificationCenter.capturedPostNames.isEmpty,
      "Setting the current profile to the same profile should not post a notification"
    )
  }

  func testUpdatingProfile() {
    Profile.setCurrent(profile, shouldPostNotification: true)
    notificationCenter.capturedPostNames = []

    let newProfile = SampleUserProfiles.createValid(
      userID: "different",
      name: "different",
      imageURL: nil,
      isExpired: true,
      isLimited: true
    )
    Profile.setCurrent(newProfile, shouldPostNotification: true)

    XCTAssertFalse(
      notificationCenter.capturedPostNames.isEmpty,
      "Replacing the current profile should post a notification"
    )
  }

  // MARK: Storage

  func testEncodingAndDecoding() throws {
    let profile = SampleUserProfiles.validLimited
    let decodedObject = try CodabilityTesting.encodeAndDecode(profile)

    // Test Objects
    XCTAssertEqual(decodedObject, profile, .isCodable)
    XCTAssertNotIdentical(decodedObject, profile, .isCodable)

    // Test Properites
    XCTAssertEqual(decodedObject.userID, profile.userID, .isCodable)
    XCTAssertEqual(decodedObject.firstName, profile.firstName, .isCodable)
    XCTAssertEqual(decodedObject.middleName, profile.middleName, .isCodable)
    XCTAssertEqual(decodedObject.lastName, profile.lastName, .isCodable)
    XCTAssertEqual(decodedObject.name, profile.name, .isCodable)
    XCTAssertEqual(decodedObject.linkURL, profile.linkURL, .isCodable)
    XCTAssertEqual(decodedObject.refreshDate, profile.refreshDate, .isCodable)
    XCTAssertEqual(decodedObject.imageURL, profile.imageURL, .isCodable)
    XCTAssertEqual(decodedObject.email, profile.email, .isCodable)
    XCTAssertEqual(decodedObject.friendIDs, profile.friendIDs, .isCodable)
    XCTAssertEqual(decodedObject.birthday, profile.birthday, .isCodable)
    XCTAssertEqual(decodedObject.ageRange, profile.ageRange, .isCodable)
    XCTAssertEqual(decodedObject.hometown, profile.hometown, .isCodable)
    XCTAssertEqual(decodedObject.location, profile.location, .isCodable)
    XCTAssertEqual(decodedObject.gender, profile.gender, .isCodable)
  }

  func testDefaultDataStore() {
    Profile.reset()
    XCTAssertNil(
      Profile.dataStore,
      "Should not have a default data store"
    )
  }

  func testConfiguringWithDataStore() {
    XCTAssertTrue(
      Profile.dataStore === dataStore,
      "Should be able to set a persistent data store"
    )
  }

  func testConfiguringWithNotificationCenter() {
    XCTAssertTrue(
      Profile.notificationCenter === notificationCenter,
      "Should be able to set a Notification Posting"
    )
  }

  func testDefaultAccessTokenProvider() {
    Profile.reset()
    XCTAssertNil(
      Profile.accessTokenProvider,
      "Should not have a default access token provider"
    )
  }

  func testConfiguringWithTokenProvider() {
    XCTAssertTrue(
      Profile.accessTokenProvider is TestAccessTokenWallet.Type,
      "Should be able to set a token wallet"
    )
  }

  func testDefaultSettings() {
    Profile.reset()
    XCTAssertNil(
      Profile.settings,
      "Should not have default settings"
    )
  }

  func testConfiguringWithSettings() {
    XCTAssertTrue(
      Profile.settings === settings,
      "Should be able to set settings"
    )
  }

  func testHashability() {
    let profile = SampleUserProfiles.createValid()
    let profile2 = SampleUserProfiles.createValid(userID: name)

    XCTAssertEqual(
      profile.hash,
      profile.hash,
      "Hashed profiles should be consistent"
    )
    XCTAssertNotEqual(
      profile.hash,
      profile2.hash,
      "Hashed profiles should be unique"
    )
  }

  func testFetchingCachedProfile() {
    _ = Profile.fetchCachedProfile()

    XCTAssertEqual(
      dataStore.capturedObjectRetrievalKey,
      "com.facebook.sdk.FBSDKProfile.currentProfile",
      "Fetching a cached profile should query the data store with the expected retrieval key"
    )
  }

  func sampleGraphResult() -> [String: Any] {
    [
      "id": profile.userID,
      "first_name": profile.firstName as Any,
      "middle_name": profile.middleName as Any,
      "last_name": profile.lastName as Any,
      "name": profile.name as Any,
      "link": profile.linkURL as Any,
      "email": profile.email as Any,
      "friends": [
        "data": [
          [
            "name": "user1",
            "id": profile.friendIDs?[0],
          ],
          [
            "name": "user2",
            "id": profile.friendIDs?[1],
          ],
        ],
      ],
      "birthday": "01/01/1990",
      "age_range": [
        "min": profile.ageRange?.min,
      ],
      "hometown": [
        "id": profile.hometown?.id,
        "name": profile.hometown?.name,
      ],
      "location": [
        "id": profile.location?.id,
        "name": profile.location?.name,
      ],
      "gender": profile.gender as Any,
    ]
  }

  func verfiyGraphPath(
    expectedPath: String,
    permissions: [String],
    file: StaticString = #file,
    line: UInt = #line
  ) {
    let token = SampleAccessTokens.create(withPermissions: permissions)
    let graphPath = Profile.graphPath(for: token)
    XCTAssertEqual(graphPath, expectedPath, file: file, line: line)
  }

  func decodeObjectCheck(
    decodedObject: String,
    objectType: Any,
    failureMessage: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    let coder = TestCoder()
    _ = Profile(coder: coder)
    XCTAssertTrue(
      coder.decodedObject[decodedObject].self as? Any.Type == objectType as? Any.Type,
      failureMessage,
      file: file,
      line: line
    )
  }
}

// MARK: - Assumptions

fileprivate extension String {
  static let isCodable = "Profile should be encodable and decodable"
}
