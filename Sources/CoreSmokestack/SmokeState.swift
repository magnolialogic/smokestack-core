/*
 *  SmokeState.swift
 *  https://github.com/magnolialogic/smokestack-core
 *
 *  © 2021-Present @magnolialogic
 */

import Foundation
import MLCommon

public final class SmokeState: Codable {
	let logChanges = Bundle.main.bundleIdentifier == "net.magnolialogic.smokestack"
	
	public var mode: SmokeMode {
		didSet {
			if logChanges { MLLogger.console("\(mode)") }
		}
	}
	
	public var probeConnected: Bool {
		didSet {
			if logChanges { MLLogger.console("\(probeConnected)") }
		}
	}
	
	public var online: Bool {
		didSet {
			if logChanges { MLLogger.console("\(online)") }
		}
	}
	
	public var power: Bool {
		didSet {
			if logChanges { MLLogger.console("\(power)") }
		}
	}
	
	public var temps = [SmokeSensor: Measurement<UnitTemperature>]() {
		willSet {
			if logChanges {
				var changeSummary = ""
				if let grillCurrent = newValue[.grillCurrent], grillCurrent != self.temps[.grillCurrent] {
					changeSummary += "grillCurrent: \(grillCurrent.formatted())"
				}
				if let grillTarget = newValue[.grillTarget], grillTarget != self.temps[.grillTarget] {
					changeSummary += ", grillTarget: \(grillTarget.formatted())"
				}
				if let probeCurrent = newValue[.probeCurrent], probeCurrent != self.temps[.probeCurrent] {
					changeSummary += ", probeCurrent: \(probeCurrent.formatted())"
				}
				if let probeTarget = newValue[.probeTarget], probeTarget != self.temps[.probeTarget] {
					changeSummary += ", probeTarget: \(probeTarget.formatted())"
				}
				MLLogger.console(changeSummary)
			}
		}
	}
	
	public static let shared = SmokeState()
	
	private init(mode: SmokeMode = .off) {
		self.mode = mode
		self.probeConnected = false
		self.online = false
		self.power = false
	}
	
	enum CodingKeys: CodingKey {
		case mode
		case probeConnected
		case online
		case power
		case temps
	}
	
	public init(from decoder: Decoder) throws {
		let decodedState = try RawSmokeState.init(from: decoder)
		self.mode = SmokeMode(rawValue: decodedState.mode)!
		self.probeConnected = decodedState.probeConnected
		self.online = decodedState.online
		self.power = decodedState.power
		for temp in decodedState.temps {
			self.temps[SmokeSensor(rawValue: temp.key)!] = Measurement(value: Double(temp.value), unit: .fahrenheit)
		}
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(mode.rawValue, forKey: .mode)
		try container.encode(probeConnected, forKey: .probeConnected)
		try container.encode(online, forKey: .online)
		try container.encode(power, forKey: .power)
		var rawTemps = [String: Int]()
		for temp in temps {
			rawTemps[temp.key.rawValue] = Int(temp.value.value)
		}
		try container.encode(rawTemps, forKey: .temps)
	}
}

// MARK: - Protocol conformance

extension SmokeState: Equatable {
	public static func == (lhs: SmokeState, rhs: SmokeState) -> Bool {
		return lhs.mode == rhs.mode && lhs.probeConnected == rhs.probeConnected && lhs.online == rhs.online && lhs.power == rhs.power && lhs.temps == rhs.temps
	}
}

// MARK: - Raw types for JSON codables

fileprivate struct RawSmokeState: Codable {
	let mode: String
	let probeConnected: Bool
	let online: Bool
	let power: Bool
	let temps: [String: Int]
}

fileprivate struct RawSmokeStatePatch: Codable {
	let mode: String?
	let probeConnected: Bool?
	let online: Bool?
	let power: Bool?
	let temps: [String: Int]?
}

// MARK: - Cross-platform methods

extension SmokeState {
	public func applyTemperatureUpdate(_ temps: SmokeTemperatureUpdate, to state: SmokeState) -> SmokeState {
		if let grillCurrent = temps.grillCurrent {
			state.temps[.grillCurrent] = Measurement(value: grillCurrent.doubleValue, unit: .fahrenheit)
		}
		if let grillTarget = temps.grillTarget {
			state.temps[.grillTarget] = Measurement(value: grillTarget.doubleValue, unit: .fahrenheit)
		}
		if let probeCurrent = temps.probeCurrent {
			state.temps[.probeCurrent] = Measurement(value: probeCurrent.doubleValue, unit: .fahrenheit)
		}
		if let probeTarget = temps.probeTarget {
			state.temps[.probeTarget] = Measurement(value: probeTarget.doubleValue, unit: .fahrenheit)
		}
		
		return state
	}
}

// MARK: - Patch

extension SmokeState {
	public struct PatchContent: Codable {
		public var mode: String?
		public var probeConnected: Bool?
		public var online: Bool?
		public var power: Bool?
		public var targetGrill: Int?
		public var targetProbe: Int?
		public var temps: [SmokeSensor : Measurement<UnitTemperature>]?
		
		public init(
			mode: String? = nil,
			probeConnected: Bool? = nil,
			online: Bool? = nil,
			power: Bool? = nil,
			temps: [SmokeSensor : Measurement<UnitTemperature>]? = nil
		) {
			self.mode = mode
			self.probeConnected = probeConnected
			self.online = online
			self.power = power
			self.temps = temps
		}
		
		enum CodingKeys: CodingKey {
			case mode
			case probeConnected
			case online
			case power
			case temps
		}
		
		public init(from decoder: Decoder) throws {
			let decodedState = try RawSmokeStatePatch.init(from: decoder)
			if let mode = decodedState.mode {
				self.mode = mode
			}
			
			if let probeConnected = decodedState.probeConnected {
				self.probeConnected = probeConnected
			}
			
			if let online = decodedState.online {
				self.online = online
			}
			
			if let power = decodedState.power {
				self.power = power
			}
			
			if let temps = decodedState.temps {
				var decodedTemps = [SmokeSensor: Measurement<UnitTemperature>]()
				for temp in temps {
					decodedTemps[SmokeSensor(rawValue: temp.key)!] = Measurement(value: Double(temp.value), unit: .fahrenheit)
				}
				self.temps = decodedTemps
			}
		}
		
		public func encode(to encoder: Encoder) throws {
			var container = encoder.container(keyedBy: CodingKeys.self)
			try? container.encode(mode, forKey: .mode)
			try? container.encode(probeConnected, forKey: .probeConnected)
			try? container.encode(online, forKey: .online)
			try? container.encode(power, forKey: .power)
			var rawTemps = [String: Int]()
			if let temps = temps {
				for temp in temps {
					rawTemps[temp.key.rawValue] = Int(temp.value.value)
				}
			}
			try? container.encode(rawTemps, forKey: .temps)
		}
	}
	
	@discardableResult public func apply(update: Codable, to state: SmokeState) -> SmokeState {
		let mirror = Mirror(reflecting: update)
		for child in mirror.children {
			if let label = child.label {
				switch label {
				case "mode":
					if let value = child.value as? String,
					   state.mode.rawValue != value {
						state.mode = SmokeMode(rawValue: value)!
					}
				case "probeConnected":
					if let value = child.value as? Bool,
					   state.probeConnected != value {
						state.probeConnected = value
					}
				case "online":
					if let value = child.value as? Bool,
					   state.online != value {
						state.online = value
					}
				case "power":
					if let value = child.value as? Bool,
					   state.power != value {
						state.power = value
					}
				case "temps":
					if let value = child.value as? [SmokeSensor: Measurement<UnitTemperature>] {
						for temp in value {
							switch temp.key {
							case .grillCurrent:
								state.temps[.grillCurrent] = temp.value
							case .grillTarget:
								state.temps[.grillTarget] = temp.value
							case .probeCurrent:
								state.temps[.probeCurrent] = temp.value
							case .probeTarget:
								state.temps[.probeTarget] = temp.value
							}
						}
					}
				default:
					break
				}
			}
		}
		
		return state
	}
}
