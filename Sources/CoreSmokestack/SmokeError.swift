/*
 *  SmokeError.swift
 *  https://github.com/magnolialogic/smokestack-core
 *
 *  © 2021-Present @magnolialogic
 */

import Foundation

public enum SmokerInterrupt: String {
	case state = "state"
	case program = "program"
}

public enum SmokestackCodable: String {
	case smokeState = "SmokeState"
	case smokeStatePatch = "SmokeState.PatchContent"
	case smokeProgram = "SmokeProgram"
	case smokeReport = "SmokeReport"
}

public enum SmokestackRedisKey: String {
	case state = "state"
	case statePending = "state:pending"
	case program = "program"
	case programPending = "program:pending"
	case firmwareVersion = "version:firmware"
}

public enum SmokeError: Error {
	// Keychain errors
	case keychainSecItemAdd(OSStatus)
	case keychainSecItemCopy(OSStatus)
	
	// Vapor errors
	case invalidPatchContent(String)
	case failedValidation(SmokestackCodable)
	
	// Redis errors
	case invalidRedisPendingKey(for: SmokerInterrupt)
	case failedGetForKey(SmokestackRedisKey)
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
			
		case .invalidPatchContent(let key):
			let format = NSLocalizedString("Can't patch state for key '%@'", comment: "")
			return String(format: format, key)
		case .failedValidation(let codable):
			let format = NSLocalizedString("Failed to validate %@", comment: "")
			return String(format: format, codable.rawValue)
			
		case .invalidRedisPendingKey(let interrupt):
			let format = NSLocalizedString("%@:pending set when no key named '%@' exists", comment: "")
			return String(format: format, interrupt.rawValue, interrupt.rawValue)
		case .failedGetForKey(let key):
			let format = NSLocalizedString("Failed to read Redis key '%@'", comment: "")
			return String(format: format, key.rawValue)
		}
	}
}
