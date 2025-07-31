// swift-tools-version: 5.9
// 2025-07-31 14:00:27
// Version: 2.50.0
// App version: 8.140

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["OVKitStatistics", "VPX", "Dav1d", "OVPlayerKit", "WebM", "OVKit", "VKOpus", "OVKResources"]),
		.library(name: "OVKitMyTargetPlugin", targets: ["OVKitMyTargetPlugin"]),
	],
	targets: [
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.37/OVKitStatistics.xcframework.zip", checksum: "9f3285774be2c789bc226f5f7c2a36ab3a246e7ac1ddee7237c96a63721846ed"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.90/OVPlayerKit.xcframework.zip", checksum: "700e400cdc6579f94ee30381627a89cd41eef25810c6f3191afaa9a624b1ce14"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.50/OVKit.xcframework.zip", checksum: "7f610e9411d9c0cb9c04ce9fc05b7682189a973fb745b8bba64dae2a9e2aec54"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.88/OVKResources.xcframework.zip", checksum: "834d5f79717ff80203878ce492c06946c23e162405d6412a4f00451d9f2af30c"),
		.binaryTarget(name: "OVKitMyTargetPlugin", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitMyTargetPlugin/2.14/OVKitMyTargetPlugin.xcframework.zip", checksum: "a4094b15038830be3dff390b2cd4b41e7446bce06cf6217572c5dd3065e062b8"),
	]
)