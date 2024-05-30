// swift-tools-version: 5.9
// 2024-05-30 13:21:29
// Version: 2.15.0
// App version: 8.81

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["WebM", "OVPlayerKit", "VKOpus", "OVKit", "VPX", "OVKResources", "Dav1d", "OVKitStatistics"]),
	],
	targets: [
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.1/WebM.xcframework.zip", checksum: "2b13060bace8df592d29311afc04e2a01879f39814aa4dfcf134c9a915d1aeea"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.55/OVPlayerKit.xcframework.zip", checksum: "23684e6e157d587094ba3377f7d7f1906f1c58089d73b8c7f97294ec2c46801f"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.15/OVKit.xcframework.zip", checksum: "2a8467ec974524909af236ea9128a42bf3e0d4ab802822deff034dc8b2e448c1"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.1/VPX.xcframework.zip", checksum: "3c2ff6d879fc09e06b781727f0ced1e5e6433fd213de9e23b9a5eb8874b52657"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.53/OVKResources.xcframework.zip", checksum: "b45c0d6be076f584a25ec0aaa0a6a2029ae31111761d36ee6db723386bd8cd22"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.2/OVKitStatistics.xcframework.zip", checksum: "fa045005bd74ef4c6a73f0337a829031ee6db2ed93b38b3653cca13e8f6b8163"),
	]
)