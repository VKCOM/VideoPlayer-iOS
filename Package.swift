// swift-tools-version: 5.9
// 2026-02-18 16:57:34
// Version: 2.53.2
// App version: 8.165

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["OVKResources", "VPX", "OVPlayerKit", "OVKit", "Dav1d", "VKOpus", "OVKitStatistics", "WebM"]),
		.library(name: "OVKitUpload", targets: ["OVKitUpload"]),
		.library(name: "OVKitMyTargetPlugin", targets: ["OVKitMyTargetPlugin"]),
		.library(name: "OVKitUIComponents", targets: ["OVKitUIComponents"]),
	],
	targets: [
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.91.2/OVKResources.xcframework.zip", checksum: "79f0383f93cd64811a4985821a8a9073c1a74251d4f970c373d8091067a9feb0"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.93.2/OVPlayerKit.xcframework.zip", checksum: "5fef0d51be805ea2b90e59758aef9a3f77654d46fb3b78f93153fc553c30a307"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.53.2/OVKit.xcframework.zip", checksum: "76d7de61140cfc513bcdb4d6be25db226456682572bd7e686a65c80d3c2fddd2"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.40.2/OVKitStatistics.xcframework.zip", checksum: "b399e880656ac478b4faed545b13e53c06f9eaad9d919a7adca3e211a28b1473"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "OVKitUpload", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUpload/1.2.2/OVKitUpload.xcframework.zip", checksum: "32b5b4e3877cf1de7d8ac3fa2d81eac294ba99b826742c7a25bc886587a1d686"),
		.binaryTarget(name: "OVKitMyTargetPlugin", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitMyTargetPlugin/2.17.2/OVKitMyTargetPlugin.xcframework.zip", checksum: "a3fef0d5a29bc66f11d6142739cc09cf2ce2a107e5a3b56afa3d81112af18370"),
		.binaryTarget(name: "OVKitUIComponents", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUIComponents/1.2.2/OVKitUIComponents.xcframework.zip", checksum: "5c81cf63fae773828afc8340fc986829be84e7a8e46983f84f307e290ea2fe4c"),
	]
)