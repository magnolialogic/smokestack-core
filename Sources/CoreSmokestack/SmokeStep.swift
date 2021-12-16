/*
 *  SmokeStep.swift
 *  https://github.com/magnolialogic/smokestack-core
 *
 *  © 2021-Present @magnolialogic
 */

import Foundation

public struct SmokeStep: Codable, Equatable {
	public enum Trigger: String, Codable {
		case time = "Time"
		case temp = "Temp"
	}

	public var mode: SmokeMode
	public var trigger: Trigger
	public var limit: Int
	public var targetGrill: Measurement<UnitTemperature>

	public init(mode: SmokeMode, trigger: Trigger, limit: Int, targetGrill: Int) {
		self.mode = mode
		self.trigger = trigger
		self.limit = limit
		self.targetGrill = Measurement<UnitTemperature>(value: Double(targetGrill), unit: .fahrenheit)
	}
	
	enum CodingKeys: CodingKey {
		case limit
		case mode
		case targetGrill
		case trigger
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.limit = try values.decode(Int.self, forKey: .limit)
		self.mode = SmokeMode(rawValue: try values.decode(String.self, forKey: .mode))!
		self.targetGrill = Measurement<UnitTemperature>(value: try values.decode(Double.self, forKey: .targetGrill), unit: .fahrenheit)
		self.trigger = Trigger(rawValue: try values.decode(String.self, forKey: .trigger))!
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(limit, forKey: .limit)
		try container.encode(mode.rawValue, forKey: .mode)
		try container.encode(Int(targetGrill.value), forKey: .targetGrill)
		try container.encode(trigger.rawValue, forKey: .trigger)
	}
}

extension SmokeStep: CustomStringConvertible {
	public var description: String {
		return "Step(mode: \(mode), trigger: \(trigger), limit: \(limit), targetGrill: \(targetGrill))"
	}
}

extension SmokeStep {
	public func jsonDescription() -> String {
		return "{\"mode\":\"\(mode.rawValue)\",\"trigger\":\"\(trigger.rawValue)\",\"limit\":\(limit),\"targetGrill\":\(Int(targetGrill.value))}"
	}
#if !os(Linux) // DateComponentsFormatter() not available on Linux, this is only used in iOS
	public func summary() -> String {
		let durationFormatter = DateComponentsFormatter()
		durationFormatter.allowedUnits = [.hour, .minute, .second]
		durationFormatter.unitsStyle = .positional

		return "\(mode == .smoke ? "Smoke" : "Cook at " + String(Int(targetGrill.value)) + "°F") \(trigger == .time ? "for \(durationFormatter.string(from: TimeInterval(limit))!)" : "until probe reaches " + String(limit) + "°F")"
	}
#endif
}
