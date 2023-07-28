//
//  File.swift
//  
//
//  Created by Carson Rau on 6/27/23.
//

import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntax

public struct AddDescription: MemberMacro, ConformanceMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingConformancesOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [(TypeSyntax, GenericWhereClauseSyntax?)] {
        return [
            ("CustomStringConvertible", nil)
        ]
    }
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            fatalError("This attribute is only applicable to enumeration types!")
        }
        let members = enumDecl.memberBlock.members
        let caseDecls = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
        let elements = caseDecls.flatMap { $0.elements }
        // TODO: implement public var description: String { get { switch self { ... } } }
        return []
    }
}
