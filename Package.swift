// swift-tools-version: 5.9
// 2026-07-07 14:26:22
// Version: 2.54.0
// App version: 8.183

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["Dav1d", "VKOpus", "OVPlayerKit", "OVKitStatistics", "OVKResources", "VPX", "OVKit", "WebM"]),
		.library(name: "OVKitVPXPlugin", targets: ["OVKitVPXPlugin"]),
		.library(name: "OVKitOpusPlugin", targets: ["OVKitOpusPlugin"]),
		.library(name: "OVKitMyTargetPlugin", targets: ["OVKitMyTargetPlugin"]),
		.library(name: "OVKitUpload", targets: ["OVKitUpload"]),
		.library(name: "OVKitUIComponents", targets: ["OVKitUIComponents"]),
	],
	targets: [
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0.1/VKOpus.xcframework.zip", checksum: "0cc832ed878ad0bc6caec82e262c4dfc8be1161076111c8ac93057a95d2ce7a5"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.94/OVPlayerKit.xcframework.zip", checksum: "061ff5e990bbb737b59836d2a30ba190581ccb6a4ade0099d21b4d070457d88e"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.41/OVKitStatistics.xcframework.zip", checksum: "06a7d7a7803bc406b96d01a5d34a3e9810d7ba91a3a66724ce45ea2ac7b4364c"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.92/OVKResources.xcframework.zip", checksum: "b891d156c811e51c55508467cd64d06422a68cedfca1b5a04f7f95a4cb71b72e"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.54/OVKit.xcframework.zip", checksum: "e7ff25db1d5397928d22799baacc1552682ce3f4ebe02081ebfd7500badee895"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "OVKitVPXPlugin", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitVPXPlugin/1.0/OVKitVPXPlugin.xcframework.zip", checksum: "9eb134e2171100b622643d55b533d60ed59938f2bfb167059b6e2effd667d235"),
		.binaryTarget(name: "OVKitOpusPlugin", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitOpusPlugin/1.0/OVKitOpusPlugin.xcframework.zip", checksum: "9fd35d36f4e52c659c29d2a5805443c834a4c0d18859c738cad7d5ec42927a94"),
		.binaryTarget(name: "OVKitMyTargetPlugin", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitMyTargetPlugin/2.18/OVKitMyTargetPlugin.xcframework.zip", checksum: "c4e3e49f706c83f0dedb917541158f06d95fae3ef086bfdc6a22bff7996fef53"),
		.binaryTarget(name: "OVKitUpload", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUpload/1.3/OVKitUpload.xcframework.zip", checksum: "8999a31ebbbca06d01e495d9b91183f2f3377a5cae4078533d934462e5346586"),
		.binaryTarget(name: "OVKitUIComponents", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUIComponents/1.3/OVKitUIComponents.xcframework.zip", checksum: "e562dba99a0918d69d9b67ef1626c8e0bdd921814ec62fa4b5525650e671ea0f"),
	]
)