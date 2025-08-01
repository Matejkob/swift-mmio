//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift MMIO open source project
//
// Copyright (c) 2024 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

import Testing

@testable import SVD
@testable import SVD2Swift

extension SVD2SwiftTests {
  // FIXME: Add scalar, and dimArrayIndex to this example device
  private static let testDimensionElementOutput = SVDDevice(
    name: "ExampleDevice",
    description: "An example device",
    addressUnitBits: 8,
    width: 32,
    registerProperties: .init(
      size: 32,
      access: .readWrite),
    peripherals: .init(
      peripheral: [
        .init(
          dimensionElement: .init(
            dim: 1,
            dimIncrement: 0x1000),
          name: "ExamplePeripheral",
          description: "An example peripheral",
          baseAddress: 0x1_0000,
          registers: .init(
            cluster: [
              .init(
                dimensionElement: .init(
                  dim: 2,
                  dimIncrement: 0x2000),
                name: "ExampleCluster1",
                description: "An example cluster",
                addressOffset: 0x2_0000,
                cluster: [
                  .init(
                    dimensionElement: .init(
                      dim: 3,
                      dimIncrement: 0x3000),
                    name: "ExampleCluster2",
                    description: "An example nested cluster",
                    addressOffset: 0x3_0000,
                    register: [
                      .init(
                        dimensionElement: .init(
                          dim: 4,
                          dimIncrement: 0x4000),
                        name: "ExampleRegister",
                        description: "An example register",
                        addressOffset: 0x4_0000,
                        fields: .init(
                          field: [
                            .init(
                              dimensionElement: .init(
                                dim: 5,
                                dimIncrement: 5),
                              name: "ExampleField",
                              bitRange: .lsbMsb(.init(lsb: 2, msb: 3)))
                          ]))
                    ])
                ])
            ],
            register: []))
      ]))

  @Test func dimIndex_output() throws {
    assertSVD2SwiftOutput(
      svdDevice: Self.testDimensionElementOutput,
      expected: [
        "Device.swift": """
        // Generated by svd2swift.

        import MMIO

        /// An example peripheral
        let exampleperipheral = RegisterArray<ExamplePeripheral>(unsafeAddress: 0x10000, stride: 0x1000, count: 1)

        """,

        "ExamplePeripheral.swift": """
        // Generated by svd2swift.

        import MMIO

        /// An example peripheral
        @RegisterBlock
        struct ExamplePeripheral {
          /// An example cluster
          @RegisterBlock(offset: 0x20000, stride: 0x2000, count: 2)
          var examplecluster1: RegisterArray<ExampleCluster1>
        }

        extension ExamplePeripheral {
          /// An example cluster
          @RegisterBlock
          struct ExampleCluster1 {
            /// An example nested cluster
            @RegisterBlock(offset: 0x30000, stride: 0x3000, count: 3)
            var examplecluster2: RegisterArray<ExampleCluster2>
          }
        }

        extension ExamplePeripheral.ExampleCluster1 {
          /// An example nested cluster
          @RegisterBlock
          struct ExampleCluster2 {
            /// An example register
            @RegisterBlock(offset: 0x40000, stride: 0x4000, count: 4)
            var exampleregister: RegisterArray<ExampleRegister>
          }
        }

        extension ExamplePeripheral.ExampleCluster1.ExampleCluster2 {
          /// An example register
          @Register(bitWidth: 32)
          struct ExampleRegister {
            /// ExampleField
            @ReadWrite(bits: 2..<4)
            var examplefield0: ExampleField0

            /// ExampleField
            @ReadWrite(bits: 7..<9)
            var examplefield1: ExampleField1

            /// ExampleField
            @ReadWrite(bits: 12..<14)
            var examplefield2: ExampleField2

            /// ExampleField
            @ReadWrite(bits: 17..<19)
            var examplefield3: ExampleField3

            /// ExampleField
            @ReadWrite(bits: 22..<24)
            var examplefield4: ExampleField4
          }
        }

        """,
      ])
  }
}
