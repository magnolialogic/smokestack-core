/*
 *  SmokeAPNSInterrupt.swift
 *  https://github.com/magnolialogic/smokestack-core
 *
 *  © 2021-Present @magnolialogic
 */

import Foundation

public struct SmokeReport: Codable {
	public let id: String
	public var temps: SmokeTemperatureUpdate?
	public var state: SmokeState?
	public var statePatch: SmokeState.PatchContent?
	public var program: SmokeProgram?
	public var programIndex: Int?
	public var timerFired: Bool?
	public var softwareVersion: String?
	public var firmwareVersion: String?
	
	public init(
		temps: SmokeTemperatureUpdate? = nil,
		state: SmokeState? = nil,
		statePatch: SmokeState.PatchContent? = nil,
		program: SmokeProgram? = nil,
		programIndex: Int? = nil,
		timerFired: Bool? = nil,
		softwareVersion: String? = nil,
		firmwareVersion: String? = nil
	) {
		self.id = UUID().uuidString
		self.temps = temps
		self.state = state
		self.statePatch = statePatch
		self.program = program
		self.programIndex = programIndex
		self.timerFired = timerFired
		self.softwareVersion = softwareVersion
		self.firmwareVersion = firmwareVersion
	}
	
	enum CodingKeys: CodingKey {
		case id
		case temps
		case state
		case statePatch
		case program
		case programIndex
		case timerFired
		case softwareVersion
		case firmwareVersion
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(String.self, forKey: .id)
		self.temps = try? container.decode(SmokeTemperatureUpdate.self, forKey: .temps)
		self.state = try? container.decode(SmokeState.self, forKey: .state)
		self.statePatch = try? container.decode(SmokeState.PatchContent.self, forKey: .statePatch)
		self.program = try? container.decode(SmokeProgram.self, forKey: .program)
		self.programIndex = try? container.decode(Int.self, forKey: .programIndex)
		self.timerFired = try? container.decode(Bool.self, forKey: .timerFired)
		self.softwareVersion = try? container.decode(String.self, forKey: .softwareVersion)
		self.firmwareVersion = try? container.decode(String.self, forKey: .firmwareVersion)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		if temps != nil { try container.encode(temps, forKey: .temps) }
		if state != nil { try container.encode(state, forKey: .state) }
		if statePatch != nil { try container.encode(statePatch, forKey: .statePatch) }
		if program != nil { try container.encode(program, forKey: .program) }
		if programIndex != nil { try container.encode(programIndex, forKey: .programIndex) }
		if timerFired != nil { try container.encode(timerFired, forKey: .timerFired) }
		if softwareVersion != nil { try container.encode(softwareVersion, forKey: .softwareVersion) }
		if firmwareVersion != nil { try container.encode(firmwareVersion, forKey: .firmwareVersion) }
	}
}

extension SmokeReport {
	public func summary() -> String {
		let mirror = Mirror(reflecting: self)
		var summary = "id: \(self.id), "
		for child in mirror.children.filter ({ !(($0.value as AnyObject) is NSNull) }) {
			if let label = child.label, label != "id" {
				summary += "\(label): \(child.value as AnyObject), "
			}
		}		
		summary.removeLast(2)
		return summary
	}
}
