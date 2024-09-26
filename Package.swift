// swift-tools-version: 5.9
// 2024-09-26 13:46:34
// Version: 2.32.1
// App version: 8.98

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["OVKResources", "OVPlayerKit", "OVKit", "OVKitStatistics", "Dav1d", "VPX", "WebM", "VKOpus"]),
	],
	targets: [
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.70.1/OVKResources.xcframework.zip", checksum: "f2622ef55944733622839ea881f4f85d2df612c4d6377b9483a180fe0a10425e"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.72.1/OVPlayerKit.xcframework.zip", checksum: "b14881af1618c9b71c0fc1cc78870848481a522c5b24f4462f43fedd5f80f5ca"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.32.1/OVKit.xcframework.zip", checksum: "949c33a51846a6090546c82aad7c5235f5e77194a897f4e40b180b90e6141aeb"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.19.1/OVKitStatistics.xcframework.zip", checksum: "bcbc6261a3b9c87ea57851fa6d48ecdc0b4feb7f3ab948ae3ac31ae627b2d49a"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2/VPX.xcframework.zip", checksum: "34fbd586d33a83a95942a507a39e7b2856b12c6a1e1f91de3400548e28ac39e3"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2/WebM.xcframework.zip", checksum: "a6d0946a01036e3f09bc09b737021b778351bfc243bd48b315273adc79b73a50"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
	]
)