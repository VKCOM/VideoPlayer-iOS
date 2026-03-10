// swift-tools-version: 5.9
// 2026-03-10 11:04:15
// Version: 2.53.3
// App version: 8.165

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["OVKit", "Dav1d", "WebM", "OVPlayerKit", "VKOpus", "VPX", "OVKResources", "OVKitStatistics"]),
		.library(name: "OVKitUIComponents", targets: ["OVKitUIComponents"]),
		.library(name: "OVKitUpload", targets: ["OVKitUpload"]),
		.library(name: "OVKitMyTargetPlugin", targets: ["OVKitMyTargetPlugin"]),
	],
	targets: [
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.53.3/OVKit.xcframework.zip", checksum: "373ce9e463b4dc3c79ff113937b02402e25100c4c789cc107b0f1d667966dc9c"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.93.3/OVPlayerKit.xcframework.zip", checksum: "570d06d3dc651fec709e81825b5bc118c304e49d7bdd1451a7b9d53ec80829da"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0.1/VKOpus.xcframework.zip", checksum: "0cc832ed878ad0bc6caec82e262c4dfc8be1161076111c8ac93057a95d2ce7a5"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.91.3/OVKResources.xcframework.zip", checksum: "00d2551e4e3f1a22050c72863d771ed5266ddb181b8bbde0a62737d21e55c942"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.40.3/OVKitStatistics.xcframework.zip", checksum: "1051084bc33edfd692e92abccf012a75bcaed23048c78e6111432386524b3792"),
		.binaryTarget(name: "OVKitUIComponents", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUIComponents/1.2.3/OVKitUIComponents.xcframework.zip", checksum: "edcd8e4171ad36d03989b3b9e7bbf86c0195c388c6937442fe4820a53228da7d"),
		.binaryTarget(name: "OVKitUpload", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUpload/1.2.3/OVKitUpload.xcframework.zip", checksum: "b433789cb3e4f5dcf3078184336a71f1de5b274be93bfe75b7f6933cbfe99d14"),
		.binaryTarget(name: "OVKitMyTargetPlugin", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitMyTargetPlugin/2.17.3/OVKitMyTargetPlugin.xcframework.zip", checksum: "061be557de6a2f8eff14a0b6da08cd2d990eb159211cccaddf0288d29ca0b6cd"),
	]
)