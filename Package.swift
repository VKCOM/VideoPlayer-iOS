// swift-tools-version: 5.9
// 2025-06-24 14:09:54
// Version: 2.49.0
// App version: 8.134

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["VPX", "OVPlayerKit", "OVKitStatistics", "Dav1d", "WebM", "VKOpus", "OVKit", "OVKResources"]),
		.library(name: "OVKitMyTargetPlugin", targets: ["OVKitMyTargetPlugin"]),
	],
	targets: [
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.89/OVPlayerKit.xcframework.zip", checksum: "f27c9ca096b6de4c6475e7c0a7ffa2dcf95535a69bd1558d711260a524fba5f6"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.36/OVKitStatistics.xcframework.zip", checksum: "ebfe0b51dfb8be834388af69e97ab19e4eea5c708b97caa1cc48f3985da6cd8f"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.49/OVKit.xcframework.zip", checksum: "9d3dace18ccc0b758661c7be87b35c906f451391be41ea1790da34a82fd8dcb5"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.87/OVKResources.xcframework.zip", checksum: "dc17181416c4cc9b5c31260473710b94b35f1441cf257384abe584676b6ae3e7"),
		.binaryTarget(name: "OVKitMyTargetPlugin", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitMyTargetPlugin/2.13/OVKitMyTargetPlugin.xcframework.zip", checksum: "b517b2e4a995bd99fe22a88eb2e5f7fae83dedbe8a0a6c0be3d3940d1622baa7"),
	]
)