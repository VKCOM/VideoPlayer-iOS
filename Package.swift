// swift-tools-version: 5.9
// 2026-03-18 10:47:14
// Version: 2.53.5
// App version: 8.165

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["Dav1d", "OVPlayerKit", "OVKResources", "VPX", "OVKitStatistics", "WebM", "VKOpus", "OVKit"]),
		.library(name: "OVKitUIComponents", targets: ["OVKitUIComponents"]),
		.library(name: "OVKitMyTargetPlugin", targets: ["OVKitMyTargetPlugin"]),
		.library(name: "OVKitUpload", targets: ["OVKitUpload"]),
	],
	targets: [
		.binaryTarget(name: "Dav1d", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "OVPlayerKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVPlayerKit/3.93.5/OVPlayerKit.xcframework.zip", checksum: "2b62cad64dc9611c55025e67c8138b3cb0abfe3b6839f63af3718fde90911010"),
		.binaryTarget(name: "OVKResources", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKResources/2.91.5/OVKResources.xcframework.zip", checksum: "b2c58359227f13b8029d007d8c1ffba50151cb5a0d93e1ed3b9cb2140874a997"),
		.binaryTarget(name: "VPX", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "OVKitStatistics", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitStatistics/1.40.5/OVKitStatistics.xcframework.zip", checksum: "2178f7522775e5c26c40a7e94e0f21efe1657f93833f0eae2696dbcd3082bf24"),
		.binaryTarget(name: "WebM", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "VKOpus", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/VKOpus/1.0.1/VKOpus.xcframework.zip", checksum: "0cc832ed878ad0bc6caec82e262c4dfc8be1161076111c8ac93057a95d2ce7a5"),
		.binaryTarget(name: "OVKit", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKit/5.53.5/OVKit.xcframework.zip", checksum: "ffc99b6a5434ac251b188fb2fcb7392a962ce313fde758f0b87c39771ba17e2f"),
		.binaryTarget(name: "OVKitUIComponents", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUIComponents/1.2.5/OVKitUIComponents.xcframework.zip", checksum: "496ab1f1b4e755cb5d024eafa41445dd9ff6af76d51f41e5df58297eeab18d11"),
		.binaryTarget(name: "OVKitMyTargetPlugin", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitMyTargetPlugin/2.17.5/OVKitMyTargetPlugin.xcframework.zip", checksum: "08dc1e8d792734838d0b7016b6d05f3396c282f77e9d8219ba3f3d727a7636fe"),
		.binaryTarget(name: "OVKitUpload", url: "https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk/OVKitUpload/1.2.5/OVKitUpload.xcframework.zip", checksum: "5c8a89e71b5be342413ac2c8c9c517984d06250f531bf61ce79517b5cbec9c71"),
	]
)