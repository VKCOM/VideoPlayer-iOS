// swift-tools-version: 5.9
// 2025-01-30 15:36:18
// Version: 2.44.0
// App version: 8.114

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["VKOpus", "VPX", "OVKResources", "OVKit", "OVKitStatistics", "WebM", "Dav1d", "OVPlayerKit"]),
	],
	targets: [
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.82/OVKResources.xcframework.zip", checksum: "69cdb4982e7fb9f5d8a62a374f0bc4b5a48a94b406391e6f9f646fa85551eae8"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.44/OVKit.xcframework.zip", checksum: "314662d0631029a01851ba7029259b8a52cd5b1537f3f1d159a9c89e7be4119f"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.31/OVKitStatistics.xcframework.zip", checksum: "7b36cd1da64932692a83e68dbbb49c2e1d4f98b75dbc345452ddd422a99172cd"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.84/OVPlayerKit.xcframework.zip", checksum: "25a4982562d1486b8ffa8515c896fdf507c4f615d58001c9b549b1479c29705f"),
	]
)