//
//  BIP39Mnemonic.swift
//  AelfApp
//
//  Wrapper for HdWalletKit library
//  Provides BIP39 mnemonic and Base58 functionality for AElf wallet
//
//  Using HdWalletKit from horizontalsystems (UnstoppableWallet team)
//  https://github.com/horizontalsystems/hd-wallet-kit-ios
//

import Foundation
import HdWalletKit
import CryptoKit

// MARK: - Mnemonic Wrapper

/// Wrapper struct for HdWalletKit's Mnemonic functionality
/// Maintains API compatibility with existing code
public struct Mnemonic {
    
    public enum Strength: Int {
        case `default` = 128    // 12 words
        case low = 160          // 15 words
        case medium = 192       // 18 words
        case high = 224         // 21 words
        case veryHigh = 256     // 24 words
        
        var hdWalletStrength: HdWalletKit.Mnemonic.Strength {
            switch self {
            case .default: return .default
            case .low: return .low
            case .medium: return .medium
            case .high: return .high
            case .veryHigh: return .veryHigh
            }
        }
    }
    
    public enum Language {
        case english
        case japanese
        case korean
        case spanish
        case simplifiedChinese
        case traditionalChinese
        case french
        case italian
        
        var hdWalletLanguage: HdWalletKit.Mnemonic.Language {
            switch self {
            case .english: return .english
            case .japanese: return .japanese
            case .korean: return .korean
            case .spanish: return .spanish
            case .simplifiedChinese: return .simplifiedChinese
            case .traditionalChinese: return .traditionalChinese
            case .french: return .french
            case .italian: return .italian
            }
        }
    }
    
    /// Generate a new mnemonic phrase using HdWalletKit
    public static func generate(strength: Strength = .default, language: Language = .english) throws -> [String] {
        return try HdWalletKit.Mnemonic.generate(strength: strength.hdWalletStrength, language: language.hdWalletLanguage)
    }
    
    /// Validate a mnemonic phrase using HdWalletKit
    public static func isValid(_ mnemonic: [String], strength: Strength = .default) -> Bool {
        do {
            try HdWalletKit.Mnemonic.validate(words: mnemonic, strength: strength.hdWalletStrength)
            return true
        } catch {
            return false
        }
    }
    
    /// Get seed from mnemonic
    public static func seed(mnemonic: [String], passphrase: String = "") -> Data {
        return HdWalletKit.Mnemonic.seed(mnemonic: mnemonic, passphrase: passphrase)
    }
}

// MARK: - Base58 Encoding/Decoding

/// Base58 encoding/decoding (Bitcoin style)
public struct Base58 {
    
    private static let alphabet = Array("123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz")
    private static let alphabetString = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
    
    /// Decode a Base58 string to bytes
    public static func decode(_ string: String) -> Data? {
        var bytes = [UInt8]()
        
        for char in string {
            guard let index = alphabetString.firstIndex(of: char) else {
                return nil
            }
            bytes.append(UInt8(alphabetString.distance(from: alphabetString.startIndex, to: index)))
        }
        
        // Convert base58 to bytes
        var result = [UInt8]()
        for b in bytes {
            var carry = Int(b)
            for j in 0..<result.count {
                carry += Int(result[j]) * 58
                result[j] = UInt8(carry & 0xff)
                carry >>= 8
            }
            while carry > 0 {
                result.append(UInt8(carry & 0xff))
                carry >>= 8
            }
        }
        
        // Handle leading zeros
        for char in string {
            if char == "1" {
                result.append(0)
            } else {
                break
            }
        }
        
        return Data(result.reversed())
    }
    
    /// Encode bytes to a Base58 string
    public static func encode(_ data: Data) -> String {
        var bytes = [UInt8](data)
        var result = [UInt8]()
        
        for b in bytes {
            var carry = Int(b)
            for j in 0..<result.count {
                carry += Int(result[j]) << 8
                result[j] = UInt8(carry % 58)
                carry /= 58
            }
            while carry > 0 {
                result.append(UInt8(carry % 58))
                carry /= 58
            }
        }
        
        // Handle leading zeros
        for b in bytes {
            if b == 0 {
                result.append(0)
            } else {
                break
            }
        }
        
        return String(result.reversed().map { alphabet[Int($0)] })
    }
}

// MARK: - Crypto Utilities

/// Crypto utilities for AElf wallet
public struct Crypto {
    
    /// Double SHA256 hash
    public static func sha256sha256(_ data: Data) -> Data {
        let first = SHA256.hash(data: data)
        let second = SHA256.hash(data: Data(first))
        return Data(second)
    }
}
