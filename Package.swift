// swift-tools-version: 5.9
// 2025-11-06 10:58:10
// Version: 2.52.0
// App version: 8.154

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["Dav1d", "VKOpus", "WebM", "OVKResources", "OVKit", "OVPlayerKit", "OVKitStatistics", "VPX"]),
		.library(name: "OVKitUpload", targets: ["OVKitUpload"]),
		.library(name: "OVKitMyTargetPlugin", targets: ["OVKitMyTargetPlugin"]),
		.library(name: "OVKitUIComponents", targets: ["OVKitUIComponents"]),
	],
	targets: [
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.90/OVKResources.xcframework.zip", checksum: "a743a0091d7ac1c930bb5b6f45310fc86fa3591bebc1f91f456db417f155f8e5"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.52/OVKit.xcframework.zip", checksum: "b22fa38785c4b5f8fc4e649f8c56abc659f9e38c849017d012f6a86401f911d5"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.92/OVPlayerKit.xcframework.zip", checksum: "59275446ab7dcb3b28e69088c9895c40f677dca88c0bee961b6680f84cd8b749"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.39/OVKitStatistics.xcframework.zip", checksum: "baf7ad34a209a1891b5d0ac6527b1670c3e687cdb930e1efb80f6b6c9432087a"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "OVKitUpload", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUpload/1.1/OVKitUpload.xcframework.zip", checksum: "51809a70effab8c252b720e3c95ff6ce99fff00a03663e5e81cac477e9f397ed"),
		.binaryTarget(name: "OVKitMyTargetPlugin", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitMyTargetPlugin/2.16/OVKitMyTargetPlugin.xcframework.zip", checksum: "dfa8f9aa6716e932ea4207400427d34106b05938a034eb7b8c49b181fbbe612e"),
		.binaryTarget(name: "OVKitUIComponents", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUIComponents/1.1/OVKitUIComponents.xcframework.zip", checksum: "a72369403990594afd4768983b2c8ec21c68adad96230d72156411ecb6bc2f33"),
	]
)