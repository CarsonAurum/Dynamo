//
//  Stringify.swift
//
//
//  Created by Carson Rau on 6/27/23.
//

import SwiftSyntax
import SwiftCompilerPlugin
import SwiftSyntaxMacros

public struct StringifyMacro: ExpressionMacro {
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) -> ExprSyntax {
    guard let argument = node.argumentList.first?.expression else {
      fatalError("compiler bug: the macro does not have any arguments")
    }
    return "(\(argument), \(literal: argument.description))"
  }
}
