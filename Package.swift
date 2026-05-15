// swift-tools-version: 5.9
// 2026-05-15 10:27:45
// Version: 2.53.7
// App version: 8.165

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["OVPlayerKit", "OVKit", "OVKResources", "VPX", "OVKitStatistics", "VKOpus", "Dav1d", "WebM"]),
		.library(name: "OVKitMyTargetPlugin", targets: ["OVKitMyTargetPlugin"]),
		.library(name: "OVKitUpload", targets: ["OVKitUpload"]),
		.library(name: "OVKitUIComponents", targets: ["OVKitUIComponents"]),
	],
	targets: [
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.93.7/OVPlayerKit.xcframework.zip", checksum: "d2de7bdad2f367cf3ab602bb925c494268a2e05e798c75efe9782e8d3934b8eb"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.53.7/OVKit.xcframework.zip", checksum: "2ee142b68011cb972e5691914894d0a9bf8d16eb4e6176ea2c483960f6077d80"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.91.7/OVKResources.xcframework.zip", checksum: "c932d69650a783adc5d5bcef1d54fe78bc92b281d55be8a6560434324be3a854"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.40.7/OVKitStatistics.xcframework.zip", checksum: "d577039c5e53db2c74070b5bfb16e02b1ec8b2aa1e7fcd807d3a5e390dca31e3"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0.1/VKOpus.xcframework.zip", checksum: "0cc832ed878ad0bc6caec82e262c4dfc8be1161076111c8ac93057a95d2ce7a5"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "OVKitMyTargetPlugin", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitMyTargetPlugin/2.17.7/OVKitMyTargetPlugin.xcframework.zip", checksum: "9cd65913f8720368a693735d92508ccdb4eef69ce09de0983440d56bb1f23456"),
		.binaryTarget(name: "OVKitUpload", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUpload/1.2.7/OVKitUpload.xcframework.zip", checksum: "05b88759c1e06d7adf09e67c168b40b638121ea7609424ccb650e9beba4be608"),
		.binaryTarget(name: "OVKitUIComponents", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUIComponents/1.2.7/OVKitUIComponents.xcframework.zip", checksum: "992e9801361e580dff9cfdb21a72f417bf924c4a313022218969f94144640ca3"),
	]
)