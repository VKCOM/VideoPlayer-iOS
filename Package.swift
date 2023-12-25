// swift-tools-version: 5.9
// 2023-12-25 14:17:04
// Version: 1.80.0
// App version: 8.61

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["VKOpus", "OVPlayerKit", "WebM", "OVKResources", "OVKit", "VPX", "Dav1d"]),
	],
	targets: [
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.35/OVPlayerKit.xcframework.zip", checksum: "0bd2565adaaf2898e3a7d481de0d036847b18e8c2cd1ed48f6e7cba2ef323d35"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.1/WebM.xcframework.zip", checksum: "2b13060bace8df592d29311afc04e2a01879f39814aa4dfcf134c9a915d1aeea"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.33/OVKResources.xcframework.zip", checksum: "ecade71672a9ca721e3f5285c68ae01928f22cf3fc39be4675a2e21f88b1afba"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/4.21/OVKit.xcframework.zip", checksum: "c4932680034dd573e869164d30f40e15f4c10803ea3100bb116ea91705ade1ff"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.1/VPX.xcframework.zip", checksum: "3c2ff6d879fc09e06b781727f0ced1e5e6433fd213de9e23b9a5eb8874b52657"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
	]
)