/*
 *  SmokeMode.swift
 *  https://github.com/magnolialogic/smokestack-core
 *
 *  © 2021-Present @magnolialogic
 */

public enum SmokeMode: String, Codable, CaseIterable {
	case idle = "Idle"
	case start = "Start"
	case smoke = "Smoke"
	case hold = "Hold"
	case shutdown = "Shutdown"
	case off = "Off"
}
