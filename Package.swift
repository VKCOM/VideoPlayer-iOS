// swift-tools-version: 5.9
// 2025-05-15 14:56:54
// Version: 2.47.0
// App version: 8.129

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["Dav1d", "VKOpus", "VPX", "OVKResources", "OVKitStatistics", "OVKit", "OVPlayerKit", "WebM"]),
		.library(name: "OVKitMyTargetPlugin", targets: ["OVKitMyTargetPlugin"]),
	],
	targets: [
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.85/OVKResources.xcframework.zip", checksum: "0a6573663a815066a569a1f89a5132137b0b086a56399d1139fbf0c3b66fb8cc"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.34/OVKitStatistics.xcframework.zip", checksum: "48ff2b35e3839a65ad105876dcc656fdcd3dd8f37151c336c4365a11b702efce"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.47/OVKit.xcframework.zip", checksum: "87120a6a08784ddaaaca745dde86bd48032010757d779ce8b06fdcba3eb5e658"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.87/OVPlayerKit.xcframework.zip", checksum: "64dcb681ce75cd659a5b6e80827f110ff8609ab5270699614b55ec92b4a07c57"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "OVKitMyTargetPlugin", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitMyTargetPlugin/2.12/OVKitMyTargetPlugin.xcframework.zip", checksum: "9ef8c9d7419be3818708998d424593f1fa16cf8c504b6e35724b18cfd1087a0f"),
	]
)