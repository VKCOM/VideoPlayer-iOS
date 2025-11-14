// swift-tools-version: 5.9
// 2025-11-14 12:23:58
// Version: 2.52.1
// App version: 8.156

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["OVKitStatistics", "WebM", "OVKResources", "OVPlayerKit", "OVKit", "Dav1d", "VPX", "VKOpus"]),
		.library(name: "OVKitUIComponents", targets: ["OVKitUIComponents"]),
		.library(name: "OVKitUpload", targets: ["OVKitUpload"]),
		.library(name: "OVKitMyTargetPlugin", targets: ["OVKitMyTargetPlugin"]),
	],
	targets: [
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.39.1/OVKitStatistics.xcframework.zip", checksum: "4df06262008a40996876e2eff3b2ea24684a73e66768f361bac79dbc74212b9c"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.90.1/OVKResources.xcframework.zip", checksum: "27f58282d0947820ea53b307807b3abc9e9576b6d559e14f629aec5d513618f3"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.92.1/OVPlayerKit.xcframework.zip", checksum: "4688cea14eea16062cde98e0a5dfdbc3191253de08edd915a2dbe67b7905319f"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.52.1/OVKit.xcframework.zip", checksum: "491b96f1c905ebfb3859042ebb1ad7ef5f2ade63269989dc7c12cd011a5b2db0"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "OVKitUIComponents", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUIComponents/1.1.1/OVKitUIComponents.xcframework.zip", checksum: "6f60735ce0aa1a163fb7e0b6718bac5a2868109300729553772f53bf42ce7c8c"),
		.binaryTarget(name: "OVKitUpload", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUpload/1.1.1/OVKitUpload.xcframework.zip", checksum: "e2fe9f324e6ddadcfc3b94967454a3db2e4bd9a17e7916930374de4bc7ea09be"),
		.binaryTarget(name: "OVKitMyTargetPlugin", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitMyTargetPlugin/2.16.1/OVKitMyTargetPlugin.xcframework.zip", checksum: "e86254beea38996129d027159cfd11124e6c5c73bd961ebd2033cbf26fcb7e01"),
	]
)