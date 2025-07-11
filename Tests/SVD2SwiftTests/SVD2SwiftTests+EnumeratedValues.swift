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

import Testing

@testable import SVD
@testable import SVD2Swift

extension SVD2SwiftTests {
  private static let testEnumeratedValuesBasicDevice = SVDDevice(
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
          name: "ExamplePeripheral",
          description: "An example peripheral",
          baseAddress: 0x1000,
          registers: .init(
            cluster: [],
            register: [
              .init(
                name: "ExampleRegister",
                description: "An example register",
                addressOffset: 0x20,
                fields: .init(
                  field: [
                    .init(
                      name: "A",
                      bitRange: .lsbMsb(.init(lsb: 2, msb: 6)),
                      enumeratedValues: .init(
                        usage: .readWrite,
                        enumeratedValue: [
                          .init(data: .value(0x0, mask: .max))
                        ]))
                  ]))
            ]))
      ]))

  private static let testEnumeratedValuesAdvancedDevice = SVDDevice(
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
          name: "ExamplePeripheral",
          description: "An example peripheral",
          baseAddress: 0x1000,
          registers: .init(
            cluster: [],
            register: [
              .init(
                name: "ExampleRegister",
                description: "An example register",
                addressOffset: 0x20,
                fields: .init(
                  field: [
                    .init(
                      name: "A",
                      bitRange: .lsbMsb(.init(lsb: 2, msb: 6)),
                      enumeratedValues: .init(
                        name: "ExampleEnumeratedValues",
                        usage: .readWrite,
                        enumeratedValue: [
                          .init(
                            name: "NamedExample0",
                            description: "An example enumerated value 0",
                            data: .value(0x0, mask: .max)),
                          .init(
                            name: "NamedExample1",
                            data: .value(0x1, mask: .max)),
                          .init(
                            description: "An example enumerated value 2",
                            data: .value(0x2, mask: .max)),
                          .init(
                            data: .value(0x3, mask: .max)),
                          .init(
                            name: "ExampleDontCareBits",
                            description: "An example with dont-care bits",
                            data: .value(0b11100, mask: 0b11100)),
                        ]))
                  ]))
            ]))
      ]))

  @Test func enumeratedValues_basic() throws {
    assertSVD2SwiftOutput(
      svdDevice: Self.testEnumeratedValuesBasicDevice,
      expected: [
        "Device.swift": """
        // Generated by svd2swift.

        import MMIO

        /// An example peripheral
        let exampleperipheral = ExamplePeripheral(unsafeAddress: 0x1000)

        """,

        "ExamplePeripheral.swift": """
        // Generated by svd2swift.

        import MMIO

        /// An example peripheral
        @RegisterBlock
        struct ExamplePeripheral {
          /// An example register
          @RegisterBlock(offset: 0x20)
          var exampleregister: Register<ExampleRegister>
        }

        extension ExamplePeripheral {
          /// An example register
          @Register(bitWidth: 32)
          struct ExampleRegister {
            /// A
            @ReadWrite(bits: 2..<7, as: AValues.self)
            var a: A
          }
        }

        extension ExamplePeripheral.ExampleRegister {
          struct AValues: BitFieldProjectable, RawRepresentable {
            static let bitWidth = 5

            /// 0b00000
            static let _0b00000 = Self(rawValue: 0x0)

            var rawValue: UInt8

            @inlinable @inline(__always)
            init(rawValue: Self.RawValue) {
              self.rawValue = rawValue
            }
          }
        }

        """,
      ])
  }

  @Test func enumeratedValues_advanced() throws {
    assertSVD2SwiftOutput(
      svdDevice: Self.testEnumeratedValuesAdvancedDevice,
      expected: [
        "Device.swift": """
        // Generated by svd2swift.

        import MMIO

        /// An example peripheral
        let exampleperipheral = ExamplePeripheral(unsafeAddress: 0x1000)

        """,

        "ExamplePeripheral.swift": """
        // Generated by svd2swift.

        import MMIO

        /// An example peripheral
        @RegisterBlock
        struct ExamplePeripheral {
          /// An example register
          @RegisterBlock(offset: 0x20)
          var exampleregister: Register<ExampleRegister>
        }

        extension ExamplePeripheral {
          /// An example register
          @Register(bitWidth: 32)
          struct ExampleRegister {
            /// A
            @ReadWrite(bits: 2..<7, as: ExampleEnumeratedValues.self)
            var a: A
          }
        }

        extension ExamplePeripheral.ExampleRegister {
          struct ExampleEnumeratedValues: BitFieldProjectable, RawRepresentable {
            static let bitWidth = 5

            struct Pattern {
              var rawValue: UInt8
              var mask: UInt8
            }

            static func ~= (pattern: Pattern, value: Self) -> Bool {
              (value.rawValue & pattern.mask) == pattern.rawValue
            }

            /// An example enumerated value 0
            static let NamedExample0 = Self(rawValue: 0x0)

            /// NamedExample1
            static let NamedExample1 = Self(rawValue: 0x1)

            /// An example enumerated value 2
            static let _0b00010 = Self(rawValue: 0x2)

            /// 0b00011
            static let _0b00011 = Self(rawValue: 0x3)

            /// An example with dont-care bits
            static let ExampleDontCareBits = Pattern(rawValue: 0x1c, mask: 0x1c)

            /// An example with dont-care bits
            static func ExampleDontCareBits(_ rawValue: UInt8 = ExampleDontCareBits.value) -> Self {
              let value = Self(rawValue: rawValue)
              precondition(ExampleDontCareBits ~= value, "Invalid bits set in rawValue")
              return value
            }

            var rawValue: UInt8

            @inlinable @inline(__always)
            init(rawValue: Self.RawValue) {
              self.rawValue = rawValue
            }
          }
        }

        """,
      ])
  }
}
