//
//  Validator.swift
//  AelfApp
//
//  Replacement for the external Validator library
//  Provides form validation functionality compatible with the original API
//

import Foundation

// MARK: - Validation Error Protocol

/// Protocol for validation errors
public protocol ValidationError: Error {
    var message: String { get }
}

// MARK: - Validation Rule Protocol

/// Protocol for validation rules
public protocol ValidationRule {
    associatedtype InputType
    func validate(input: InputType) -> Bool
    var error: ValidationError { get }
}

// MARK: - Validation Pattern Protocol

/// Protocol for pattern-based validation
public protocol ValidationPattern {
    var pattern: String { get }
}

// MARK: - Validation Rule Set

/// A collection of validation rules
public struct ValidationRuleSet<T> {
    private var rules: [AnyValidationRule<T>] = []
    
    public init() {}
    
    public mutating func add<R: ValidationRule>(rule: R) where R.InputType == T {
        rules.append(AnyValidationRule(rule))
    }
    
    public func validate(input: T) -> ValidationResult {
        var errors: [ValidationError] = []
        for rule in rules {
            if !rule.validate(input: input) {
                errors.append(rule.error)
            }
        }
        return errors.isEmpty ? .valid : .invalid(errors)
    }
}

// MARK: - Type-erased Validation Rule

/// Type-erased wrapper for validation rules
public struct AnyValidationRule<T> {
    private let _validate: (T) -> Bool
    public let error: ValidationError
    
    public init<R: ValidationRule>(_ rule: R) where R.InputType == T {
        self._validate = rule.validate
        self.error = rule.error
    }
    
    public func validate(input: T) -> Bool {
        return _validate(input)
    }
}

// MARK: - Validation Result

/// Result of a validation operation
public enum ValidationResult {
    case valid
    case invalid([ValidationError])
    
    public var isValid: Bool {
        switch self {
        case .valid:
            return true
        case .invalid:
            return false
        }
    }
    
    public var errors: [ValidationError]? {
        switch self {
        case .valid:
            return nil
        case .invalid(let errors):
            return errors
        }
    }
}

// MARK: - Validatable Protocol

/// Protocol for types that can be validated
public protocol Validatable {
    func validate<R: ValidationRule>(rule: R) -> ValidationResult where R.InputType == Self
    func validate(rules: ValidationRuleSet<Self>) -> ValidationResult
}

extension Validatable {
    public func validate<R: ValidationRule>(rule: R) -> ValidationResult where R.InputType == Self {
        if rule.validate(input: self) {
            return .valid
        }
        return .invalid([rule.error])
    }
    
    public func validate(rules: ValidationRuleSet<Self>) -> ValidationResult {
        return rules.validate(input: self)
    }
}

// Make String validatable
extension String: Validatable {}

// MARK: - Built-in Validation Rules

/// Validation rule for string length
public struct ValidationRuleLength: ValidationRule {
    public typealias InputType = String
    
    public let min: Int
    public let max: Int
    public let error: ValidationError
    
    public init(min: Int = 0, max: Int = Int.max, error: ValidationError) {
        self.min = min
        self.max = max
        self.error = error
    }
    
    public func validate(input: String) -> Bool {
        return input.count >= min && input.count <= max
    }
}

/// Validation rule for regex patterns
public struct ValidationRulePattern: ValidationRule {
    public typealias InputType = String
    
    private let pattern: ValidationPattern
    public let error: ValidationError
    
    public init(pattern: ValidationPattern, error: ValidationError) {
        self.pattern = pattern
        self.error = error
    }
    
    public func validate(input: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern.pattern, options: []) else {
            return false
        }
        let range = NSRange(input.startIndex..., in: input)
        return regex.firstMatch(in: input, options: [], range: range) != nil
    }
}

/// Validation rule for equality
public struct ValidationRuleEquality<T: Equatable>: ValidationRule {
    public typealias InputType = T
    
    public let target: T
    public let error: ValidationError
    
    public init(target: T, error: ValidationError) {
        self.target = target
        self.error = error
    }
    
    public func validate(input: T) -> Bool {
        return input == target
    }
}

/// Validation rule for required (non-empty) values
public struct ValidationRuleRequired: ValidationRule {
    public typealias InputType = String
    
    public let error: ValidationError
    
    public init(error: ValidationError) {
        self.error = error
    }
    
    public func validate(input: String) -> Bool {
        return !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

/// Validation rule using a custom condition
public struct ValidationRuleCondition<T>: ValidationRule {
    public typealias InputType = T
    
    private let condition: (T) -> Bool
    public let error: ValidationError
    
    public init(error: ValidationError, condition: @escaping (T) -> Bool) {
        self.error = error
        self.condition = condition
    }
    
    public func validate(input: T) -> Bool {
        return condition(input)
    }
}

