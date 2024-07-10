// swift-tools-version: 5.9
// 2024-07-10 17:11:41
// Version: 2.19.0
// App version: 8.86

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["OVPlayerKit", "VPX", "WebM", "OVKitStatistics", "VKOpus", "OVKResources", "Dav1d", "OVKit"]),
	],
	targets: [
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.59/OVPlayerKit.xcframework.zip", checksum: "a388393939804f0a83c193574337f4461e01c2cfb023e83bcfa360a547304c6b"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2/VPX.xcframework.zip", checksum: "34fbd586d33a83a95942a507a39e7b2856b12c6a1e1f91de3400548e28ac39e3"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2/WebM.xcframework.zip", checksum: "a6d0946a01036e3f09bc09b737021b778351bfc243bd48b315273adc79b73a50"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.6/OVKitStatistics.xcframework.zip", checksum: "1f592af1969c35771afd6f379164029c88a1c62ca54b7e93995da7daf2c282bf"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.57/OVKResources.xcframework.zip", checksum: "779c2f212cb6efca1b0c01828143a24a389c014b4c963e5be0283beaff5594bd"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.19/OVKit.xcframework.zip", checksum: "1bc6edc95c292b63ee1fb81169d6dcbe9b17bd4d7b9be1b20deaa21b0e64e037"),
	]
)