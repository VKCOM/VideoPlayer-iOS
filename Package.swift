// swift-tools-version: 5.9
// 2024-12-17 18:08:37
// Version: 2.43.0
// App version: 8.110

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["OVKResources", "VPX", "VKOpus", "WebM", "Dav1d", "OVKitStatistics", "OVKit", "OVPlayerKit"]),
	],
	targets: [
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.81/OVKResources.xcframework.zip", checksum: "9a7815680defc9266c551766f7e2d87265a8c875cd1770ac21ab8581ed3e0c2c"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.30/OVKitStatistics.xcframework.zip", checksum: "af94e473a7cb8277072882ed23b28b5729ef88f60d59e716b1e34b7680f3a40c"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.43/OVKit.xcframework.zip", checksum: "62f443b2bd6109bead98283fd2415961be53ac794e6d0b5aaaf0f82a5b0c1801"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.83/OVPlayerKit.xcframework.zip", checksum: "7d63d60bb4eaab5884f5fe86d073d1abb88a962df1706155a3de7f37d96b7728"),
	]
)