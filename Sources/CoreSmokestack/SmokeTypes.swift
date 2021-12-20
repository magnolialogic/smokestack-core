/*
 *  SmokeTypes.swift
 *  https://github.com/magnolialogic/smokestack-core
 *
 *  © 2021-Present @magnolialogic
 */

import Foundation

public enum SmokeSensorKey: String, Codable {
	case grillCurrent = "grillCurrent"
	case grillTarget = "grillTarget"
	case probeCurrent = "probeCurrent"
	case probeTarget = "probeTarget"
}

public enum SmokeSensorType {
	case grill
	case probe
}

public struct SmokeSensorLatest: Codable, Equatable {
	public var current: Measurement<UnitTemperature>?
	public var target: Measurement<UnitTemperature>?
}

public class SmokeTemperatures: Codable, Equatable {
	public var grill = SmokeSensorLatest()
	public var probe = SmokeSensorLatest()
	
	public static func == (lhs: SmokeTemperatures, rhs: SmokeTemperatures) -> Bool {
		return lhs.grill == rhs.grill && lhs.probe == rhs.probe
	}
}

public struct SmokeTemperatureUpdate: Codable {
	public var grill: Int
	public var probe: Int?
	
	public init(grill: Int, probe: Int? = nil) {
		self.grill = grill
		self.probe = probe
	}
	
	enum codingKeys: CodingKey {
		case grill
		case probe
	}
}
