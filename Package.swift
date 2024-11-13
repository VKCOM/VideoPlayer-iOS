// swift-tools-version: 5.9
// 2024-10-29 13:44:19
// Version: 2.36.0
// App version: 8.102

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["Dav1d", "OVKResources", "OVKit", "OVKitStatistics", "OVPlayerKit", "WebM", "VKOpus", "VPX"]),
	],
	targets: [
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.74/OVKResources.xcframework.zip", checksum: "1d97c68fc4b511ce26cbfddda7854868a73499eb1d2ad0ba2f1f6f698b3af0f9"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.36/OVKit.xcframework.zip", checksum: "1a5ca834b55b26fc78d949da3d284b565e001216aea2c862fd80086e98d3c164"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.23/OVKitStatistics.xcframework.zip", checksum: "0a3165e00fa866a0764577eb9aeefc7b93322a8681239a2d51509464d9b55c34"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.76/OVPlayerKit.xcframework.zip", checksum: "015c6f9c647c1da9436c70f68fe3d2902c1af9c512f33942e032e2fa7a6da127"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
	]
)
