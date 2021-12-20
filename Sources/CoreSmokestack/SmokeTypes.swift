/*
 *  SmokeTypes.swift
 *  https://github.com/magnolialogic/smokestack-core
 *
 *  © 2021-Present @magnolialogic
 */

import Foundation

public enum SmokeSensor: String, Codable {
	case grillCurrent = "grillCurrent"
	case grillTarget = "grillTarget"
	case probeCurrent = "probeCurrent"
	case probeTarget = "probeTarget"
}

public struct SmokeTemperatureUpdate: Codable {
	public var grillCurrent: Int?
	public var grillTarget: Int?
	public var probeCurrent: Int?
	public var probeTarget: Int?
	
	public init(grillCurrent: Int? = nil, grillTarget: Int? = nil, probeCurrent: Int? = nil, probeTarget: Int? = nil) {
		self.grillCurrent = grillCurrent
		self.grillTarget = grillTarget
		self.probeCurrent = probeCurrent
		self.probeTarget = probeTarget
	}
	
	enum codingKeys: CodingKey {
		case grillCurrent
		case grillTarget
		case probeCurrent
		case probeTarget
	}
}
