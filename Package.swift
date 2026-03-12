// swift-tools-version: 5.9
// 2026-03-12 10:30:23
// Version: 2.53.4
// App version: 8.165

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["VKOpus", "WebM", "OVPlayerKit", "OVKResources", "Dav1d", "VPX", "OVKitStatistics", "OVKit"]),
		.library(name: "OVKitUpload", targets: ["OVKitUpload"]),
		.library(name: "OVKitMyTargetPlugin", targets: ["OVKitMyTargetPlugin"]),
		.library(name: "OVKitUIComponents", targets: ["OVKitUIComponents"]),
	],
	targets: [
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0.1/VKOpus.xcframework.zip", checksum: "0cc832ed878ad0bc6caec82e262c4dfc8be1161076111c8ac93057a95d2ce7a5"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.93.4/OVPlayerKit.xcframework.zip", checksum: "397f028d2be6723cd4bb3e58d4955f2a8488d011d9e61d8ccc36f25b9a7689b3"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.91.4/OVKResources.xcframework.zip", checksum: "84c135b447c028e16a970180afe154ff096b029c41d79f5f84d88a9de054c942"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.40.4/OVKitStatistics.xcframework.zip", checksum: "a4e4c753361f22983b8b147863d6c432e3057b819a748d45f0baea0811518a60"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.53.4/OVKit.xcframework.zip", checksum: "90b9cf92d123f6ed7b32cc45fab65a9fb7671fc0179e4d5e87e48b497e638d60"),
		.binaryTarget(name: "OVKitUpload", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUpload/1.2.4/OVKitUpload.xcframework.zip", checksum: "401378233ac3d5d73887ae988a2315470353b6735a63e4c97a50a9e56d094496"),
		.binaryTarget(name: "OVKitMyTargetPlugin", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitMyTargetPlugin/2.17.4/OVKitMyTargetPlugin.xcframework.zip", checksum: "e05f2357c46f3a0566af429d56dfb82f5a7f9f0f2d0eecc6d7d7b861d15e07ee"),
		.binaryTarget(name: "OVKitUIComponents", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUIComponents/1.2.4/OVKitUIComponents.xcframework.zip", checksum: "11903f651f9ae733c1b6a9ff80c16d72e3111be8d09f142c3eea1142943319fd"),
	]
)