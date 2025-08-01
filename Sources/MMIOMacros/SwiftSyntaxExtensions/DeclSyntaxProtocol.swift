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

import SwiftSyntax
import SwiftSyntaxMacros

protocol DiagnosableDeclSyntaxProtocol: DeclSyntaxProtocol {
  static var declTypeName: String { get }
  var introducerKeyword: TokenSyntax { get }
}

extension AccessorDeclSyntax: DiagnosableDeclSyntaxProtocol {
  static let declTypeName = "accessor"
  var introducerKeyword: TokenSyntax { self.accessorSpecifier }
}

extension ActorDeclSyntax: DiagnosableDeclSyntaxProtocol {
  static let declTypeName = "actor"
  var introducerKeyword: TokenSyntax { self.actorKeyword }
}

extension AssociatedTypeDeclSyntax: DiagnosableDeclSyntaxProtocol {
  static let declTypeName = "associated type"
  var introducerKeyword: TokenSyntax { self.associatedtypeKeyword }
}

extension ClassDeclSyntax: DiagnosableDeclSyntaxProtocol {
  static let declTypeName = "class"
  var introducerKeyword: TokenSyntax { self.classKeyword }
}

extension DeinitializerDeclSyntax: DiagnosableDeclSyntaxProtocol {
  static let declTypeName = "deinitializer"
  var introducerKeyword: TokenSyntax { self.deinitKeyword }
}

extension EditorPlaceholderDeclSyntax: DiagnosableDeclSyntaxProtocol {
  static let declTypeName = "editor placeholder"
  var introducerKeyword: TokenSyntax { self.placeholder }
}

extension EnumCaseDeclSyntax: DiagnosableDeclSyntaxProtocol {
  static let declTypeName = "enum case"
  var introducerKeyword: TokenSyntax { self.caseKeyword }
}

extension EnumDeclSyntax: DiagnosableDeclSyntaxProtocol {
  static let declTypeName = "enum case"
  var introducerKeyword: TokenSyntax { self.enumKeyword }
}

extension ExtensionDeclSyntax: DiagnosableDeclSyntaxProtocol {
  static let declTypeName = "extension"
  var introducerKeyword: TokenSyntax { self.extensionKeyword }
}

extension FunctionDeclSyntax: DiagnosableDeclSyntaxProtocol {
  static let declTypeName = "function"
  var introducerKeyword: TokenSyntax { self.funcKeyword }
}

extension IfConfigDeclSyntax: DiagnosableDeclSyntaxProtocol {
  static let declTypeName = "if config"
  var introducerKeyword: TokenSyntax {
    self.clauses.first?.poundKeyword ?? .poundToken()
  }
}

extension ImportDeclSyntax: DiagnosableDeclSyntaxProtocol {
  static let declTypeName = "import"
  var introducerKeyword: TokenSyntax { self.importKeyword }
}

extension InitializerDeclSyntax: DiagnosableDeclSyntaxProtocol {
  static let declTypeName = "initializer"
  var introducerKeyword: TokenSyntax { self.initKeyword }
}

extension MacroDeclSyntax: DiagnosableDeclSyntaxProtocol {
  static let declTypeName = "macro"
  var introducerKeyword: TokenSyntax { self.macroKeyword }
}

extension MacroExpansionDeclSyntax: DiagnosableDeclSyntaxProtocol {
  static let declTypeName = "macro expansion"
  var introducerKeyword: TokenSyntax { self.macroName }
}

extension MissingDeclSyntax: DiagnosableDeclSyntaxProtocol {
  static let declTypeName = "missing"
  var introducerKeyword: TokenSyntax { self.placeholder }
}

extension OperatorDeclSyntax: DiagnosableDeclSyntaxProtocol {
  static let declTypeName = "operator"
  var introducerKeyword: TokenSyntax { self.operatorKeyword }
}

extension PoundSourceLocationSyntax: DiagnosableDeclSyntaxProtocol {
  static let declTypeName = "pound source location"
  var introducerKeyword: TokenSyntax { self.poundSourceLocation }
}

extension PrecedenceGroupDeclSyntax: DiagnosableDeclSyntaxProtocol {
  static let declTypeName = "precedence group"
  var introducerKeyword: TokenSyntax { self.precedencegroupKeyword }
}

extension ProtocolDeclSyntax: DiagnosableDeclSyntaxProtocol {
  static let declTypeName = "protocol"
  var introducerKeyword: TokenSyntax { self.protocolKeyword }
}

extension StructDeclSyntax: DiagnosableDeclSyntaxProtocol {
  static let declTypeName = "struct"
  var introducerKeyword: TokenSyntax { self.structKeyword }
}

extension SubscriptDeclSyntax: DiagnosableDeclSyntaxProtocol {
  static let declTypeName = "subscript"
  var introducerKeyword: TokenSyntax { self.subscriptKeyword }
}

extension TypeAliasDeclSyntax: DiagnosableDeclSyntaxProtocol {
  static let declTypeName = "type alias"
  var introducerKeyword: TokenSyntax { self.typealiasKeyword }
}

extension VariableDeclSyntax: DiagnosableDeclSyntaxProtocol {
  static let declTypeName = "variable"
  var introducerKeyword: TokenSyntax { self.bindingSpecifier }
}

extension DeclSyntaxProtocol {
  func requireAs<Other>(
    _ other: Other.Type,
    _ context: MacroContext<some ParsableMacro, some MacroExpansionContext>
  ) throws -> Other where Other: DiagnosableDeclSyntaxProtocol {
    if let decl = self.as(Other.self) { return decl }

    let node: any SyntaxProtocol =
      (self as? any DiagnosableDeclSyntaxProtocol)?.introducerKeyword ?? self

    throw context.error(
      at: node,
      message: .expectedDecl(Other.self))
  }
}

extension ErrorDiagnostic {
  static func expectedDecl(_ decl: any DiagnosableDeclSyntaxProtocol.Type)
    -> Self
  {
    .init(
      """
      '\(Macro.signature)' can only be applied to \(decl.declTypeName) \
      declarations
      """)
  }
}
