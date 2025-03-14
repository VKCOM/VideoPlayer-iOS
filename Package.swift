// swift-tools-version: 5.9
// 2025-03-14 17:35:41
// Version: 2.45.0
// App version: 8.120

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["OVPlayerKit", "VPX", "OVKitStatistics", "OVKit", "VKOpus", "OVKResources", "WebM", "Dav1d"]),
	],
	targets: [
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.85/OVPlayerKit.xcframework.zip", checksum: "0835aed1a1b24dfb4586b0f416fe24dcaf285b1dd2d3962d0da5d70f935ef8e5"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.32/OVKitStatistics.xcframework.zip", checksum: "54d5d6a7f15177597ba422b0d2c770d9426c7fd367d371f2245bca43dd196959"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.45/OVKit.xcframework.zip", checksum: "b88d5d6793d91afcca592c574c1f29ce78404019436af604f63b629ab1d5bd9e"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.83/OVKResources.xcframework.zip", checksum: "de1fc97c11cbd81c2dd3626a4f490161e28a58b8a8787d9e41e058fe9438355c"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
	]
)