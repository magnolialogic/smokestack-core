/*
 *  SmokeError.swift
 *  https://github.com/magnolialogic/smokestack-core
 *
 *  © 2021-Present @magnolialogic
 */

import Foundation

public enum SmokeError: Error {
	// Keychain errors
	case keychainSecItemAdd(OSStatus)
	case keychainSecItemCopy(OSStatus)
}

extension SmokeError: LocalizedError {
	public var errorDescription: String? {
		switch self {
		case .keychainSecItemAdd(let status):
			let format = NSLocalizedString("Failed to add to keychain: %@", comment: "")
			return String(format: format, status)
		case .keychainSecItemCopy(let status):
			let format = NSLocalizedString("Failed to read from keychain: %@", comment: "")
			return String(format: format, status)
		}
	}
}
