// swift-tools-version: 5.9
// 2024-09-03 16:20:49
// Version: 2.28.0
// App version: 8.94

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["VPX", "OVKitStatistics", "VKOpus", "OVPlayerKit", "OVKResources", "OVKit", "Dav1d", "WebM"]),
	],
	targets: [
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2/VPX.xcframework.zip", checksum: "34fbd586d33a83a95942a507a39e7b2856b12c6a1e1f91de3400548e28ac39e3"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.15/OVKitStatistics.xcframework.zip", checksum: "65899ff0c90b56050bbac054cbcd52f5699431c97bd0ff7fd32648751f83fc05"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.68/OVPlayerKit.xcframework.zip", checksum: "2ba1bc6b661f14876f4a66a12a32e9cab4d7775ef83444607696f2b6da6bd0ea"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.66/OVKResources.xcframework.zip", checksum: "c20956af4b98ab5e9158a8dbfa92050007112e0cc7119b52aa1e57ca3f4b108c"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.28/OVKit.xcframework.zip", checksum: "6e42eef3d616d664065d31bca9d9e55aa935d58fe7785c44368bba232778c4a7"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2/WebM.xcframework.zip", checksum: "a6d0946a01036e3f09bc09b737021b778351bfc243bd48b315273adc79b73a50"),
	]
)