// swift-tools-version: 5.9
// 2024-03-25 18:01:23
// Version: 2.5.0
// App version: 8.71

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["OVKit", "OVKResources", "Dav1d", "VKOpus", "VPX", "OVPlayerKit", "WebM"]),
	],
	targets: [
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.5/OVKit.xcframework.zip", checksum: "7e50670f7de8e41edb3aeb81d21139e0910731c5adcbb97e76811a8b8ad11124"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.43/OVKResources.xcframework.zip", checksum: "c928c2872223822db404d9e5c7217a4cbafbb7fe6c60a59f196ccee671d0b9ec"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.1/VPX.xcframework.zip", checksum: "3c2ff6d879fc09e06b781727f0ced1e5e6433fd213de9e23b9a5eb8874b52657"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.45/OVPlayerKit.xcframework.zip", checksum: "dedef35a0e9cfc8aa561483b76f6e6d60830f00792a152d93db310796d4697a1"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.1/WebM.xcframework.zip", checksum: "2b13060bace8df592d29311afc04e2a01879f39814aa4dfcf134c9a915d1aeea"),
	]
)