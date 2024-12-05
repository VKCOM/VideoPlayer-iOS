// swift-tools-version: 5.9
// 2024-12-05 17:36:32
// Version: 2.42.0
// App version: 8.108

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["OVPlayerKit", "VPX", "VKOpus", "WebM", "Dav1d", "OVKitStatistics", "OVKResources", "OVKit"]),
	],
	targets: [
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.82/OVPlayerKit.xcframework.zip", checksum: "09f3667f8415c0189eaa32aa5d52ccf504b92049d1bd9a39ac2c1e7bd4b3bc47"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.29/OVKitStatistics.xcframework.zip", checksum: "d41618e5a45329c8e321ed056f99723b252f92e5cea61e1ca5692eaccc6790e3"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.80/OVKResources.xcframework.zip", checksum: "5818d6a77ce38c685b42cadc031cfe61c85bb0d5166ebb3117c67f966501bb04"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.42/OVKit.xcframework.zip", checksum: "a2c3612c922e48d3dc06b8577917e148e80cd21da087a7f215cc14ad20425806"),
	]
)