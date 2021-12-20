/*
 *  SmokeProgram.swift
 *  https://github.com/magnolialogic/smokestack-core
 *
 *  © 2021-Present @magnolialogic
 */

import Foundation

public struct SmokeProgram: Codable, Identifiable {
	public var id: String
	public var index: Int
	public var steps: [SmokeStep]
	
	public init(steps: [SmokeStep]) {
		self.id = UUID().uuidString
		self.index = 0
		self.steps = steps
	}
	
	enum CodingKeys: CodingKey {
		case id
		case index
		case steps
	}
}

extension SmokeProgram: Equatable {
	public static func == (lhs: SmokeProgram, rhs: SmokeProgram) -> Bool {
		return lhs.id == rhs.id && lhs.index == rhs.index && lhs.steps == rhs.steps
	}
}
