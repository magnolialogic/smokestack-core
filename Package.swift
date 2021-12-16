// swift-tools-version:5.5

import PackageDescription

let package = Package(
	name: "smokestack-core",
	platforms: [
		.macOS(.v12),
		.iOS(.v15)
	],
	products: [
		.library(name: "CoreSmokestack", targets: ["CoreSmokestack"]),
	],
	dependencies: [
		.package(url: "https://github.com/magnolialogic/ml-common.git", .branch("main"))
	],
	targets: [
		.target(
			name: "CoreSmokestack",
			dependencies: [
				.product(name: "MLCommon", package: "ml-common")
			])
	]
)
