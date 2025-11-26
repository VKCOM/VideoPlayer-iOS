// swift-tools-version: 5.9
// 2025-11-26 14:05:45
// Version: 2.52.3
// App version: 8.156

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["OVKResources", "OVPlayerKit", "OVKitStatistics", "OVKit", "Dav1d", "VKOpus", "WebM", "VPX"]),
		.library(name: "OVKitUpload", targets: ["OVKitUpload"]),
		.library(name: "OVKitUIComponents", targets: ["OVKitUIComponents"]),
		.library(name: "OVKitMyTargetPlugin", targets: ["OVKitMyTargetPlugin"]),
	],
	targets: [
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.90.3/OVKResources.xcframework.zip", checksum: "a211c3365f217a9d82905a8746a6496b939890cb03ce561df13a04b79a7b4c78"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.92.3/OVPlayerKit.xcframework.zip", checksum: "0d770cd8f0b91cd5294ce904f29291123ea0ddbc55160693fc51c93c4fffaaae"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.39.3/OVKitStatistics.xcframework.zip", checksum: "d0cb6e514fb5f5bac0ca6a407602e647bb14563d9819eebdca938b65683bb5cc"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.52.3/OVKit.xcframework.zip", checksum: "dac0b87e6a44948984a5c5b8ac938650e33f262a35f85692b4796be9f70f76ff"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "OVKitUpload", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUpload/1.1.3/OVKitUpload.xcframework.zip", checksum: "146a848fa3b6a7e0f325157591d89fc5255d53e165d8318fe0239ff43cce7607"),
		.binaryTarget(name: "OVKitUIComponents", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUIComponents/1.1.3/OVKitUIComponents.xcframework.zip", checksum: "5efed053af8095b3380914376653deb66f60dc1a8aea5bc9d637a1ceee81daae"),
		.binaryTarget(name: "OVKitMyTargetPlugin", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitMyTargetPlugin/2.16.3/OVKitMyTargetPlugin.xcframework.zip", checksum: "6d09882fac68c2661b9bc2584bf883a5bab69e3e3a3d24b1512261066585b7ea"),
	]
)