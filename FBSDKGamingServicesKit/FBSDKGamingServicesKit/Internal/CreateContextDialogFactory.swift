/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import FBSDKCoreKit

struct CreateContextDialogFactory: CreateContextDialogMaking {
  private var tokenProvider: _AccessTokenProviding.Type

  init(tokenProvider: _AccessTokenProviding.Type) {
    self.tokenProvider = tokenProvider
  }

  func makeCreateContextDialog(
    content: CreateContextContent,
    windowFinder: _WindowFinding,
    delegate: ContextDialogDelegate
  ) throws -> Showable? {
    guard tokenProvider.current != nil else {
      throw ContextDialogPresenterError.invalidAccessToken
    }

    return CreateContextDialog(
      content: content,
      windowFinder: windowFinder,
      delegate: delegate
    )
  }
}
