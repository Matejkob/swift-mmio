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

@XMLElement
public struct SVDEnumerationCaseDataDefault {
  public var isDefault: Bool
}

extension SVDEnumerationCaseDataDefault: Decodable {}

extension SVDEnumerationCaseDataDefault: Encodable {}

extension SVDEnumerationCaseDataDefault: Equatable {}

extension SVDEnumerationCaseDataDefault: Hashable {}

extension SVDEnumerationCaseDataDefault: Sendable {}
