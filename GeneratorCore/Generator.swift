//
//  Generator.swift
//  GeneratorCore
//
//  Created by Guilherme Rambo on 15/05/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import Foundation
import JavaScriptCore

private final class _Stub {}

public enum CardType: String {
    case visa
    case mastercard
    case amex
    case discover
}

public enum DocumentType {
    case cpf
    case cnpj
    case creditCard(CardType)

    public var title: String {
        switch self {
        case .cpf:
            return "CPF"
        case .cnpj:
            return "CNPJ"
        case .creditCard(let type):
            switch type {
            case .visa:
                return "Credit Card (Visa)"
            case .mastercard:
                return "Credit Card (MasterCard)"
            case .amex:
                return "Credit Card (Amex)"
            case .discover:
                return "Credit Card (Discover)"
            }
        }
    }

    public static var all: [DocumentType] {
        return [
            .cpf,
            .cnpj,
            .creditCard(.visa),
            .creditCard(.mastercard),
            .creditCard(.amex),
            .creditCard(.discover)
        ]
    }

    fileprivate var scriptName: String {
        switch self {
        case .cpf: return "cpf"
        case .cnpj: return "cnpj"
        case .creditCard: return "creditCard"
        }
    }

    fileprivate var fileURL: URL {
        guard let url = Bundle(for: _Stub.self).url(forResource: scriptName, withExtension: "js") else {
            fatalError("Required script \(scriptName) is missing from GeneratorCore")
        }

        return url
    }

    fileprivate var script: String {
        do {
            return try String(contentsOf: fileURL)
        } catch {
            fatalError("Failed to load required script \(scriptName) from GeneratorCore")
        }
    }
}

public enum GeneratorError: Error {
    case context
    case evaluation
}

public final class Generator {

    public init() {
        
    }

    public func generate(type: DocumentType) throws -> String {
        guard let context = JSContext() else { throw GeneratorError.context }

        _ = context.evaluateScript(type.script)

        var param = ""

        if case .creditCard(let issuer) = type {
            param = "\"" + issuer.rawValue + "\""
        }

        guard let result = context.evaluateScript("generate(\(param))")?.toString() else {
            throw GeneratorError.evaluation
        }

        return result
    }

}
