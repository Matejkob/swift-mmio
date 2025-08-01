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

// FIXME: This should be an enum or have a reference to an example SVD file
/// All registers of a peripheral are enclosed between the `<registers>` opening
/// and closing tags.
///
/// Clusters define a set of registers. You can either use the `<cluster>` or
/// the `<register>` element.
@XMLElement
public struct SVDRegisters {
  /// Define the sequence of register clusters.
  public var cluster: [SVDCluster]
  /// Define the sequence of registers.
  public var register: [SVDRegister]
}

extension SVDRegisters: Decodable {}

extension SVDRegisters: Encodable {}

extension SVDRegisters: Equatable {}

extension SVDRegisters: Hashable {}

extension SVDRegisters: Sendable {}
