// swift-tools-version: 5.9
// 2024-09-17 13:26:43
// Version: 2.30.0
// App version: 8.96

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["OVKit", "OVKResources", "VKOpus", "OVKitStatistics", "VPX", "WebM", "Dav1d", "OVPlayerKit"]),
	],
	targets: [
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.30/OVKit.xcframework.zip", checksum: "80afe559e433214295a4fa3d6c792e441cfaf3a1c64bb20f062cde95f3f1dd36"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.68/OVKResources.xcframework.zip", checksum: "a360af56783fce02207a997c196ca4b375596b8f73183d121f9d70372116a625"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.17/OVKitStatistics.xcframework.zip", checksum: "4df308f42dfdf1986ad9ef29c268b4fcfc30acb13a239c3d1c5056a86b4e7bb1"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2/VPX.xcframework.zip", checksum: "34fbd586d33a83a95942a507a39e7b2856b12c6a1e1f91de3400548e28ac39e3"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2/WebM.xcframework.zip", checksum: "a6d0946a01036e3f09bc09b737021b778351bfc243bd48b315273adc79b73a50"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.70/OVPlayerKit.xcframework.zip", checksum: "cb6f70339dbe3177110b69d86ec35a0bb1ac354e3d0fa67522cf94bca2052d81"),
	]
)