/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

@objcMembers
class TestTouch: UITouch {
  var stubbedView: UIView?

  override var view: UIView? {
    stubbedView
  }
}
