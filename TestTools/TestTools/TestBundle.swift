/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import FBSDKCoreKit
import FBSDKCoreKit_Basics
import Foundation

@objcMembers
public final class TestBundle: NSObject, InfoDictionaryProviding {
  private var stubbedInfoDictionary: [String: Any]?
  var lastCapturedKey: String?
  public var capturedKeys = [String]()
  public var didAccessInfoDictionary = false

  public var infoDictionary: [String: Any]? {
    get {
      didAccessInfoDictionary = true
      return stubbedInfoDictionary
    }
    set {
      stubbedInfoDictionary = newValue
    }
  }

  public override convenience init() {
    self.init(infoDictionary: [:])
  }

  public init(infoDictionary: [String: Any] = [:]) {
    stubbedInfoDictionary = infoDictionary
  }

  public var bundleIdentifier: String?

  public func object(forInfoDictionaryKey key: String) -> Any? {
    lastCapturedKey = key
    capturedKeys.append(key)
    return infoDictionary?[key] as Any?
  }

  public func reset() {
    capturedKeys = []
    lastCapturedKey = nil
    stubbedInfoDictionary = nil
    didAccessInfoDictionary = false
  }
}
