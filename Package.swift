// swift-tools-version: 5.9
// 2025-12-08 13:18:22
// Version: 2.52.4
// App version: 8.156

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["OVKitStatistics", "OVKResources", "OVPlayerKit", "VPX", "WebM", "Dav1d", "VKOpus", "OVKit"]),
		.library(name: "OVKitMyTargetPlugin", targets: ["OVKitMyTargetPlugin"]),
		.library(name: "OVKitUIComponents", targets: ["OVKitUIComponents"]),
		.library(name: "OVKitUpload", targets: ["OVKitUpload"]),
	],
	targets: [
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.39.4/OVKitStatistics.xcframework.zip", checksum: "1d0ab2f6cd4b0b44787817daf29d687044d99f8b0f01dfcfad5854bf6b2f2a09"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.90.4/OVKResources.xcframework.zip", checksum: "ca91ea6de96138a284a587d520462d889cf3eaa1d38b42b105e76b63e4b5b387"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.92.4/OVPlayerKit.xcframework.zip", checksum: "25e51ad8b756dcbeedf10e16da9fad3573e0025e25006b91bb9d13c539a06a71"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.52.4/OVKit.xcframework.zip", checksum: "e4b7cb13632003d67a7988707531125ff537e43537bea59fc541d51335df8e0d"),
		.binaryTarget(name: "OVKitMyTargetPlugin", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitMyTargetPlugin/2.16.4/OVKitMyTargetPlugin.xcframework.zip", checksum: "7f9424eb4dc771d3e15af3ea818803cdea45cefa5217154be4401af58e36cd98"),
		.binaryTarget(name: "OVKitUIComponents", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUIComponents/1.1.4/OVKitUIComponents.xcframework.zip", checksum: "2fb07daac82e960ffc9a01923c1aa4ae028fd8ad56081508ec5d50ac73605c86"),
		.binaryTarget(name: "OVKitUpload", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUpload/1.1.4/OVKitUpload.xcframework.zip", checksum: "0baab1594d5b79e8d8098d654d43251d4b4a7ea72943eb29a1d388b9f603a1a6"),
	]
)