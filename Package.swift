// swift-tools-version: 5.9
// 2026-10-16 11:08:53
// Version: 2.54.1
// App version: 8.183

import PackageDescription

let package = Package(name: "VKVideoPlayer", platforms: [.iOS(.v14)],
	products: [
		.library(name: "VKVideoPlayer", targets: ["OVKResources", "VPX", "OVKit", "OVPlayerKit", "OVKitStatistics", "VKOpus", "WebM", "Dav1d"]),
		.library(name: "OVKitMyTargetPlugin", targets: ["OVKitMyTargetPlugin"]),
		.library(name: "OVKitOpusPlugin", targets: ["OVKitOpusPlugin"]),
		.library(name: "OVKitVPXPlugin", targets: ["OVKitVPXPlugin"]),
		.library(name: "OVKitUIComponents", targets: ["OVKitUIComponents"]),
		.library(name: "OVKitUpload", targets: ["OVKitUpload"]),
	],
	targets: [
		.binaryTarget(name: "OVKResources", url: "https://nexus-external.vkteam.ru/repository/raw-one-video-ios-player/OVKResources/2.92.1/OVKResources.xcframework.zip", checksum: "1cd2876a3fe0f205e1eff879f5a308de333bcbd3f519ced30c79dc04fb697606"),
		.binaryTarget(name: "VPX", url: "https://nexus-external.vkteam.ru/repository/raw-one-video-ios-player/VPX/1.2.1/VPX.xcframework.zip", checksum: "9377ec0ff544202efee0002b2e876d113ec6afb417aa33d2697f00a3c0ce155f"),
		.binaryTarget(name: "OVKit", url: "https://nexus-external.vkteam.ru/repository/raw-one-video-ios-player/OVKit/5.54.1/OVKit.xcframework.zip", checksum: "863702640406e8e6b574544b9bc22485983762fdd080f3d383b4045acbdf24ef"),
		.binaryTarget(name: "OVPlayerKit", url: "https://nexus-external.vkteam.ru/repository/raw-one-video-ios-player/OVPlayerKit/3.94.1/OVPlayerKit.xcframework.zip", checksum: "fbf96e91709df92dbad9f2ca075fd8c60069e6834b46b867b8be9adcc78e5a5a"),
		.binaryTarget(name: "OVKitStatistics", url: "https://nexus-external.vkteam.ru/repository/raw-one-video-ios-player/OVKitStatistics/1.41.1/OVKitStatistics.xcframework.zip", checksum: "a95ea83324f0d2029b1201095b4a9a2d0cb8408bb9f986f4c579d0f5946dee99"),
		.binaryTarget(name: "VKOpus", url: "https://nexus-external.vkteam.ru/repository/raw-one-video-ios-player/VKOpus/1.0.1/VKOpus.xcframework.zip", checksum: "0cc832ed878ad0bc6caec82e262c4dfc8be1161076111c8ac93057a95d2ce7a5"),
		.binaryTarget(name: "WebM", url: "https://nexus-external.vkteam.ru/repository/raw-one-video-ios-player/WebM/1.2.1/WebM.xcframework.zip", checksum: "a5456984ca8ad47efd286c9f0112ab3b9995c21f50923203b19462414f0c6bb4"),
		.binaryTarget(name: "Dav1d", url: "https://nexus-external.vkteam.ru/repository/raw-one-video-ios-player/Dav1d/2.0/Dav1d.xcframework.zip", checksum: "f9c1945e81936dd4fde648e8716eeb01cbcfe762f462d4efd6dac8782fac5399"),
		.binaryTarget(name: "OVKitMyTargetPlugin", url: "https://nexus-external.vkteam.ru/repository/raw-one-video-ios-player/OVKitMyTargetPlugin/2.18.1/OVKitMyTargetPlugin.xcframework.zip", checksum: "7776a57ac9d93d714f968d42925bb9714b7e2c9cc413b09cfc8ccc99b3ba7671"),
		.binaryTarget(name: "OVKitOpusPlugin", url: "https://nexus-external.vkteam.ru/repository/raw-one-video-ios-player/OVKitOpusPlugin/1.0/OVKitOpusPlugin.xcframework.zip", checksum: "9fd35d36f4e52c659c29d2a5805443c834a4c0d18859c738cad7d5ec42927a94"),
		.binaryTarget(name: "OVKitVPXPlugin", url: "https://nexus-external.vkteam.ru/repository/raw-one-video-ios-player/OVKitVPXPlugin/1.0/OVKitVPXPlugin.xcframework.zip", checksum: "9eb134e2171100b622643d55b533d60ed59938f2bfb167059b6e2effd667d235"),
		.binaryTarget(name: "OVKitUIComponents", url: "https://nexus-external.vkteam.ru/repository/raw-one-video-ios-player/OVKitUIComponents/1.3.1/OVKitUIComponents.xcframework.zip", checksum: "24d82e508c036ba79487c81f804db50e6f7ed2c4213319d62416ef072a06da9d"),
		.binaryTarget(name: "OVKitUpload", url: "https://nexus-external.vkteam.ru/repository/raw-one-video-ios-player/OVKitUpload/1.3.1/OVKitUpload.xcframework.zip", checksum: "350b22d40ac1c0de3eea701b8ab4dda1dae2142b2bfabe663a6280b89fb6d9b7"),
	]
)