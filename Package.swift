// swift-tools-version: 5.9
// 2025-10-20 13:46:50
// Version: 2.51.1
// App version: 8.152

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["OVPlayerKit", "WebM", "VKOpus", "OVKit", "VPX", "OVKitStatistics", "Dav1d", "OVKResources"]),
		.library(name: "OVKitUpload", targets: ["OVKitUpload"]),
		.library(name: "OVKitMyTargetPlugin", targets: ["OVKitMyTargetPlugin"]),
		.library(name: "OVKitUIComponents", targets: ["OVKitUIComponents"]),
	],
	targets: [
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.91.1/OVPlayerKit.xcframework.zip", checksum: "cc5117d944c55f21736ee56324f128d0ad8eb64c90308e2f8c2b67a518560199"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0/VKOpus.xcframework.zip", checksum: "6ac2419048a1479f94d1d9ce434735fad9190dae2b087bad0f1581530013508f"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.51.1/OVKit.xcframework.zip", checksum: "2a983f3e24affa6100e3849392ad91cce3d1128f22bfb496413f4a78a9e3b43f"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.38.1/OVKitStatistics.xcframework.zip", checksum: "bc0a344d85e8730eea0ca9349421296f61e2572205bab71e4a0e325599d150bc"),
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.89.1/OVKResources.xcframework.zip", checksum: "ff3e63cfa5a83677c86a5ada2a0c37b958101fc74b4a349a87dad5af4ca04671"),
		.binaryTarget(name: "OVKitUpload", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUpload/1.0.1/OVKitUpload.xcframework.zip", checksum: "836815544ab180e4a8e524262f6cb323a4054182d27d78083f4a233f3e6c8eb1"),
		.binaryTarget(name: "OVKitMyTargetPlugin", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitMyTargetPlugin/2.15.1/OVKitMyTargetPlugin.xcframework.zip", checksum: "d4956d72f6a3d813e66e8ee2869baffdf4e13e2ad8ff371cb290a1ee45f68855"),
		.binaryTarget(name: "OVKitUIComponents", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUIComponents/1.0.1/OVKitUIComponents.xcframework.zip", checksum: "e88b4c217dca4c7d413072a28103726f0359e12283ac855fa6cf788dcd3c3aaf"),
	]
)