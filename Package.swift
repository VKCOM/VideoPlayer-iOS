// swift-tools-version: 5.9
// 2025-05-29 15:04:36
// Version: 2.48.0
// App version: 8.131

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["VKOpus", "OVKitStatistics", "Dav1d", "OVKResources", "WebM", "OVKit", "OVPlayerKit", "VPX"]),
		.library(name: "OVKitMyTargetPlugin", targets: ["OVKitMyTargetPlugin"]),
	],
	targets: [
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.35/OVKitStatistics.xcframework.zip", checksum: "d3f2eddfc755916191193a8c81155e643efb191e18f101b3bc9315ee73f3dfe3"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.86/OVKResources.xcframework.zip", checksum: "f9230bbc7e71522737ec7895d75404afe0574be8530952a122aa90a1b395b134"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.48/OVKit.xcframework.zip", checksum: "42acc597113a6b1365919905d39411cd331f23ea0291756eaa0386b09fafb78b"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.88/OVPlayerKit.xcframework.zip", checksum: "a898823c79c85b09cf3677311af0c4fbbf870bfa6918fd04a59ea4171ca4e966"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "OVKitMyTargetPlugin", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitMyTargetPlugin/2.12/OVKitMyTargetPlugin.xcframework.zip", checksum: "9ef8c9d7419be3818708998d424593f1fa16cf8c504b6e35724b18cfd1087a0f"),
	]
)