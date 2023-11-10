// swift-tools-version: 5.9
// 2023-11-10 14:36:30
// Version: 1.74.0

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["VKOpus", "WebM", "OVKResources", "Dav1d", "OVKit", "OVPlayerKit", "VPX"]),
	],
	targets: [
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.1/WebM.xcframework.zip", checksum: "2b13060bace8df592d29311afc04e2a01879f39814aa4dfcf134c9a915d1aeea"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.27/OVKResources.xcframework.zip", checksum: "4b9e357ff86cbb4cfa8ec02995c24fc1536e502a88de1dc1a868e12c567da89a"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/1.0/Dav1d.xcframework.zip", checksum: "f6e463822845c831f61d97989dead3e359dc74b75a5b367fbad285bfbdc8efc5"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/4.12/OVKit.xcframework.zip", checksum: "f02b8c69f0e9b06fe28a16b9f06a5d1374fbf65c401a717d63287e5f29927b66"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.27/OVPlayerKit.xcframework.zip", checksum: "92453e7de1ac70a4eee86a32540e9633b12985ee21f9d74eada4e644671768b9"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.1/VPX.xcframework.zip", checksum: "3c2ff6d879fc09e06b781727f0ced1e5e6433fd213de9e23b9a5eb8874b52657"),
	]
)