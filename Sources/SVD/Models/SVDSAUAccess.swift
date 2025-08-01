//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift MMIO open source project
//
// Copyright (c) 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

public import XML

public enum SVDSAUAccess: String {
  /// Secure callable.
  case secureCallable = "c"
  /// Non-secure.
  case nonSecure = "n"
}

extension SVDSAUAccess: Decodable {}

extension SVDSAUAccess: Encodable {}

extension SVDSAUAccess: Equatable {}

extension SVDSAUAccess: Hashable {}

extension SVDSAUAccess: Sendable {}

extension SVDSAUAccess: XMLElementInitializable {}
