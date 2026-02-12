// swift-tools-version: 5.9
// 2026-02-12 12:50:11
// Version: 2.53.0
// App version: 8.165

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["VPX", "OVKitStatistics", "OVKit", "OVPlayerKit", "WebM", "VKOpus", "OVKResources", "Dav1d"]),
		.library(name: "OVKitUIComponents", targets: ["OVKitUIComponents"]),
		.library(name: "OVKitUpload", targets: ["OVKitUpload"]),
		.library(name: "OVKitMyTargetPlugin", targets: ["OVKitMyTargetPlugin"]),
	],
	targets: [
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.40/OVKitStatistics.xcframework.zip", checksum: "5edd444abe7cefb78edc84d3765b59d1c0942be8a14d5ee349bc513e25295f8d"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.53/OVKit.xcframework.zip", checksum: "9209ad2f79a75db8ef90697ac203b0cc1324ae0c7e0f99ee1e7fca38784e5061"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.93/OVPlayerKit.xcframework.zip", checksum: "8356b31bd5661a7c2fa3b0128f7a6d7908b40f396c652391e247d3078e6cee5d"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.91/OVKResources.xcframework.zip", checksum: "e6899cc87d583bb3f7b50fd4d2295029958179e79fb44e51d0277b838ee4f091"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "OVKitUIComponents", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUIComponents/1.2/OVKitUIComponents.xcframework.zip", checksum: "69142b66f545102cd54f2d9293a7345cd5bbffb548e9247da5b25c8817234aed"),
		.binaryTarget(name: "OVKitUpload", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUpload/1.2/OVKitUpload.xcframework.zip", checksum: "835b135cd2ce5f6fe5011c1fb433809decc19e91f399726147a9f98f619128c1"),
		.binaryTarget(name: "OVKitMyTargetPlugin", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitMyTargetPlugin/2.17/OVKitMyTargetPlugin.xcframework.zip", checksum: "f6a65e0c923ab149275bb111cce9421223630bb5885a6c9870f8c19c83252c88"),
	]
)