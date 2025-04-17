// swift-tools-version: 5.9
// 2025-04-17 13:16:35
// Version: 2.46.0
// App version: 8.125

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["OVKitStatistics", "OVKResources", "VPX", "VKOpus", "OVKit", "Dav1d", "OVPlayerKit", "WebM"]),
	],
	targets: [
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.33/OVKitStatistics.xcframework.zip", checksum: "c37868c9b930837c7c2b12328a3527a3c697d2e8c75b6e1b3888d05606919df2"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.84/OVKResources.xcframework.zip", checksum: "65dc8ff5d7557fe2ae6655008eebed3633775cc323015794ba764ebe62802675"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.46/OVKit.xcframework.zip", checksum: "4fc0b0cbbe26429f14c33dd4824d4eaaf749411ae1ace67c04f7eaec75213acf"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.86/OVPlayerKit.xcframework.zip", checksum: "6b1b950e19040bb50bc66fa8bb6534c73f94ca66d9a672b35dc5bc4e3e1aa1e8"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
	]
)