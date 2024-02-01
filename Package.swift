// swift-tools-version: 5.9
// 2024-02-01 19:24:54
// Version: 1.84.0
// App version: 8.65

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["OVKResources", "Dav1d", "OVKitMyTargetPlugin", "VPX", "WebM", "OVPlayerKit", "VKOpus", "OVKit", "OVKitChromecastPlugin"]),
	],
	targets: [
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.37/OVKResources.xcframework.zip", checksum: "c036f38edcb8c00b80f7257f54385e467f7016d3b96e657e7108d69d133db43e"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "OVKitMyTargetPlugin", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitMyTargetPlugin/2.10/OVKitMyTargetPlugin.xcframework.zip", checksum: "1350ac5b0b9c9ff7b1f5f2f8b8e54530eb7b1cb6e78db8d57c5662ace3efe166"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.1/VPX.xcframework.zip", checksum: "3c2ff6d879fc09e06b781727f0ced1e5e6433fd213de9e23b9a5eb8874b52657"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.1/WebM.xcframework.zip", checksum: "2b13060bace8df592d29311afc04e2a01879f39814aa4dfcf134c9a915d1aeea"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.39/OVPlayerKit.xcframework.zip", checksum: "e5ca08f7f86508e24e4944ea2d37dfbed7c1ce24bd89fff19801280018c2d0ca"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/4.24/OVKit.xcframework.zip", checksum: "4a8029d50435d9878966f6df15c8b0c9113abd475fbafbe7e59d76e7c921d0c8"),
		.binaryTarget(name: "OVKitChromecastPlugin", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitChromecastPlugin/1.0/OVKitChromecastPlugin.xcframework.zip", checksum: "756b07f30c6886948137f787c3bf73549609fd5f59001802f0aa7c71a7dacef0"),
	]
)