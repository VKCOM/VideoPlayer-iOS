// swift-tools-version: 5.9
// 2025-11-20 12:41:59
// Version: 2.52.2
// App version: 8.156

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["WebM", "VPX", "VKOpus", "OVKResources", "OVKit", "OVPlayerKit", "Dav1d", "OVKitStatistics"]),
		.library(name: "OVKitUpload", targets: ["OVKitUpload"]),
		.library(name: "OVKitMyTargetPlugin", targets: ["OVKitMyTargetPlugin"]),
		.library(name: "OVKitUIComponents", targets: ["OVKitUIComponents"]),
	],
	targets: [
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.90.2/OVKResources.xcframework.zip", checksum: "e5cb9055a01c27834e4687acf9ba3784820fd4f724cb488578c926d4da4e5c20"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.52.2/OVKit.xcframework.zip", checksum: "72c1f733641de1fcd423459bfb598dbce87e071d28dae4ee73a2718db2914252"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.92.2/OVPlayerKit.xcframework.zip", checksum: "8f953840dd89cd178aaf1e713cf3a8ac96e121f606dc0381a1e7531d720db77a"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.39.2/OVKitStatistics.xcframework.zip", checksum: "c22ae5bc679fbad4b06a7b0b244813c3322224a0fbc5defb67ce21a55a0b137b"),
		.binaryTarget(name: "OVKitUpload", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUpload/1.1.2/OVKitUpload.xcframework.zip", checksum: "2c0351982534f8a9dbf03ca053d5660b37818356e31610ee74edc3eb67416722"),
		.binaryTarget(name: "OVKitMyTargetPlugin", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitMyTargetPlugin/2.16.2/OVKitMyTargetPlugin.xcframework.zip", checksum: "797fb0fdbaf11057262010727a0cd4c7df45c1646c134e10849e21982d54ce96"),
		.binaryTarget(name: "OVKitUIComponents", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUIComponents/1.1.2/OVKitUIComponents.xcframework.zip", checksum: "5b65fe4866447652b00361f29d62c852d3fba3c51de77d5fafecd7b91e052b8b"),
	]
)