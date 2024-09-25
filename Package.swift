// swift-tools-version: 5.9
// 2024-09-25 16:58:19
// Version: 2.32.0
// App version: 8.98

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["OVKResources", "OVPlayerKit", "VKOpus", "OVKit", "OVKitStatistics", "WebM", "VPX", "Dav1d"]),
	],
	targets: [
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.70/OVKResources.xcframework.zip", checksum: "fe53f47e9d8b8f1c1ababb28b25d33cd71c201da0c60652f6079bc99a3b4d89d"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.72/OVPlayerKit.xcframework.zip", checksum: "709325035dfa560eb805923fece00634a91b7df84ed48062402d85b4bb2a96b4"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.32/OVKit.xcframework.zip", checksum: "7443a82478efca4480d0d410109393ca86680f6706dbcffd34ca5dc94b83a2a2"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.19/OVKitStatistics.xcframework.zip", checksum: "f95fb69f97fab69ef1b2ed402da8b9b89b0d81622335de789bec79e35f4fdce2"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2/WebM.xcframework.zip", checksum: "a6d0946a01036e3f09bc09b737021b778351bfc243bd48b315273adc79b73a50"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2/VPX.xcframework.zip", checksum: "34fbd586d33a83a95942a507a39e7b2856b12c6a1e1f91de3400548e28ac39e3"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
	]
)