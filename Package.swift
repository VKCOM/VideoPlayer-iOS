// swift-tools-version: 5.9
// 2024-05-13 14:13:15
// Version: 2.12.0
// App version: 8.78

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["OVKitStatistics", "WebM", "Dav1d", "OVKResources", "VPX", "VKOpus", "OVKit", "OVPlayerKit"]),
	],
	targets: [
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.0/OVKitStatistics.xcframework.zip", checksum: "fef7b80f53ec86a28953dbc3ea7bf5483151425365a135da59415319e7a36e18"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.1/WebM.xcframework.zip", checksum: "2b13060bace8df592d29311afc04e2a01879f39814aa4dfcf134c9a915d1aeea"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.50/OVKResources.xcframework.zip", checksum: "f02a18603de6d2ce54009ec52561e218bf3da5d652a375c8e80342d091a5040f"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.1/VPX.xcframework.zip", checksum: "3c2ff6d879fc09e06b781727f0ced1e5e6433fd213de9e23b9a5eb8874b52657"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.12/OVKit.xcframework.zip", checksum: "36027f0e8fca563132660688b221ac9b655d5a0090a0a85e27b5b8964eb3eeb5"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.52/OVPlayerKit.xcframework.zip", checksum: "71a60cd0b72d12d7376695d7f1ebe59b8cdef0cce6902ff686a0f0e957e684a6"),
	]
)