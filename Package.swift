// swift-tools-version: 5.9
// 2026-03-26 09:29:42
// Version: 2.53.6
// App version: 8.165

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["VKOpus", "OVKit", "OVPlayerKit", "VPX", "OVKResources", "Dav1d", "WebM", "OVKitStatistics"]),
		.library(name: "OVKitUpload", targets: ["OVKitUpload"]),
		.library(name: "OVKitUIComponents", targets: ["OVKitUIComponents"]),
		.library(name: "OVKitMyTargetPlugin", targets: ["OVKitMyTargetPlugin"]),
	],
	targets: [
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0.1/VKOpus.xcframework.zip", checksum: "0cc832ed878ad0bc6caec82e262c4dfc8be1161076111c8ac93057a95d2ce7a5"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.53.6/OVKit.xcframework.zip", checksum: "1016d5a42aba7bb1c9519f4ca574ee13c005efaa7075a3c1c571adfce5f5d338"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.93.6/OVPlayerKit.xcframework.zip", checksum: "cb3cef3a58c423371e8bf326fa7c116f905af1d1255eda6f7b46c46004ed5a67"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.91.6/OVKResources.xcframework.zip", checksum: "55f46dd7bf61a631d7da48fc724f037fdc060fbf6ecca6712d8f12f94e310d6b"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.40.6/OVKitStatistics.xcframework.zip", checksum: "7047319f3d81e916a09736d1561c4177cc582207be8c3a0625ebfded62959a8f"),
		.binaryTarget(name: "OVKitUpload", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUpload/1.2.6/OVKitUpload.xcframework.zip", checksum: "63f0b4d9acf690abf61c9a83b206610a4fbe73e773b49e77c7a9ac90794735a1"),
		.binaryTarget(name: "OVKitUIComponents", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUIComponents/1.2.6/OVKitUIComponents.xcframework.zip", checksum: "770137a40c8713da8f76605eb4f46a4481e154ed8d6440cfc327af5a902e57ef"),
		.binaryTarget(name: "OVKitMyTargetPlugin", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitMyTargetPlugin/2.17.6/OVKitMyTargetPlugin.xcframework.zip", checksum: "0eb6bf2ebb81af8ff04d70651d4260bdeb3a3fd65b1515386deb7a3dc8fc79c9"),
	]
)