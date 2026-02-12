// swift-tools-version: 5.9
// 2026-02-12 14:17:23
// Version: 2.53.1
// App version: 8.165

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["WebM", "Dav1d", "OVKitStatistics", "VPX", "OVKit", "OVKResources", "VKOpus", "OVPlayerKit"]),
		.library(name: "OVKitMyTargetPlugin", targets: ["OVKitMyTargetPlugin"]),
		.library(name: "OVKitUIComponents", targets: ["OVKitUIComponents"]),
		.library(name: "OVKitUpload", targets: ["OVKitUpload"]),
	],
	targets: [
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.40.1/OVKitStatistics.xcframework.zip", checksum: "0c3f28da442ea08165e2d00b87ab170168788c2eaf438048447cf00f59aa8390"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.53.1/OVKit.xcframework.zip", checksum: "b5067b47c79f3cea189ea9b9c47b2f1c769e4f4b37c4830b6519bd75e1b7c06f"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.91.1/OVKResources.xcframework.zip", checksum: "5da307b10934fb4eed4662c7f8ce4b45bb20e65d1505634ad9f2c63cd28fd48e"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.93.1/OVPlayerKit.xcframework.zip", checksum: "183820255f5364b2ae4f37eb18b5eacf60b4b6d0fcdc78a62266eff7f8eb12f3"),
		.binaryTarget(name: "OVKitMyTargetPlugin", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitMyTargetPlugin/2.17.1/OVKitMyTargetPlugin.xcframework.zip", checksum: "0613d6999d41d71526e6cbc40f578106ba19f6c66c731b11c5f403042b7a6462"),
		.binaryTarget(name: "OVKitUIComponents", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUIComponents/1.2.1/OVKitUIComponents.xcframework.zip", checksum: "823b98c279edc0996aa4ad7bc1e7e9f4bca522c9cbeb649d2e2d56ba4634c55a"),
		.binaryTarget(name: "OVKitUpload", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUpload/1.2.1/OVKitUpload.xcframework.zip", checksum: "23fb353c9741ffd09ee6d2274246878c4159f1817e8c1f371abcae268823d565"),
	]
)