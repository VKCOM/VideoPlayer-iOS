//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import OVKit
import SwiftUI

class SettingsViewController: UIHostingController<SettingsView> {
    /// Включает режим отображения плеера, на котором находится фокус автоплея.
    @objc
    static var focusDebug = false
    /// Включает загрузку видео в формате HLS
    @objc
    static var useHLS = false
}

struct SettingsView: View {
    @AppStorage(Environment.demo_userIdKey)
    private var userId = ""

    @AppStorage(Environment.demo_advDebugKey)
    private var advDebug = false

    @AppStorage(Environment.demo_advDeviceIdKey)
    private var advDeviceId = ""

    @AppStorage(Environment.demo_advCustomSlotIdKey)
    private var advCustomSlotId = ""

    @AppStorage(Environment.demo_advCustomCreativeTypeKey)
    private var advCustomCreativeType = ""

    @AppStorage(Environment.demo_advExpIdKey)
    private var advExpId = ""

    #if DEBUG
    @AppStorage(Environment.demo_focusDebug)
    private var focusDebug = false
    #endif

    @AppStorage(Environment.demo_hlsDownload)
    private var videoInHLS = false

    @AppStorage(Environment.demo_apiClientIdKey)
    private var clientId = ""

    @AppStorage(Environment.demo_apiSecretKey)
    private var clientSecret = ""

    @State
    private var creativeType = MyTargetCreativeType.auto

    var body: some View {
        Form {
            Section {
                TextField("[0-9]+", text: $userId)
                    .onChange(of: userId, perform: updateUserId)
            } header: {
                Text("User ID")
            } footer: {
                Text("Override VK ID parameter for requested ads.")
            }

            Section {
                if let clientId = Environment.launchApiSessionClientId {
                    Text(clientId)
                } else {
                    TextField("Client ID", text: $clientId)
                        .autocorrectionDisabled()
                }

                if let apiSecret = Environment.launchApiSessionSecret {
                    Text(String(repeating: "*", count: apiSecret.count))
                } else {
                    SecureField("Secret", text: $clientSecret)
                }
            } header: {
                Text("VK API Credentials")
            }
            #if DEBUG
            Section {
                Toggle(isOn: $focusDebug.animation()) {
                    Text("Focus Preview")
                }
                .onChange(of: focusDebug, perform: updateFocusDebug)
            } footer: {
                Text("Enable Focus Preview for autoplay feature.")
            }
            #endif

            Section {
                Toggle(isOn: $videoInHLS.animation()) {
                    Text("Download videos in HLS")
                }
                .onChange(of: videoInHLS, perform: updateHLS)
            }

            Section {
                NavigationLink("Advertisement") {
                    List {
                        Section {
                            Toggle(isOn: $advDebug.animation()) {
                                Text("Debug Mode")
                            }
                            .onChange(of: advDebug, perform: updateAdvDebug)
                        }
                        if advDebug {
                            // Slot ID
                            Section {
                                TextField("Optional [0-9]+", text: $advCustomSlotId)
                                    .onChange(of: advCustomSlotId, perform: updateCustomSlotId)
                            } header: {
                                Text("Custom Slot ID")
                            } footer: {
                                Text("Override slotId argument for MTRGInstreamAd initialization.")
                            }
                            // Creative Type
                            Section {
                                Picker("Type", selection: $creativeType) {
                                    Text("None").tag(MyTargetCreativeType.auto)
                                    Text("Shoppable").tag(MyTargetCreativeType.shoppable)
                                    Text("Video Motion").tag(MyTargetCreativeType.videoMotion)
                                    Text("Instream").tag(MyTargetCreativeType.instream)
                                }
                                .pickerStyle(.segmented)
                                .onChange(of: creativeType, perform: updateCreativeType)
                            } header: {
                                Text("Creative Type")
                            } footer: {
                                Text("Control type of banners for slot.")
                            }
                            // Exp ID
                            Section {
                                TextField("Optional String", text: $advExpId)
                                    .minimumScaleFactor(0.5)
                                    .onChange(of: advExpId, perform: updateAdvExpId)
                            } header: {
                                Text("Experiment Id")
                            } footer: {
                                Text("Override exp_id parameter for requested ads.")
                            }
                            // Device ID
                            Section {
                                TextField("Optional String", text: $advDeviceId)
                                    .minimumScaleFactor(0.5)
                                    .onChange(of: advDeviceId, perform: updateAdvDeviceId)
                            } header: {
                                Text("Test Device ID")
                            } footer: {
                                Text("See UUID in device logs after Debug Mode is turning on.")
                            }
                        }
                    }
                    .navigationTitle("Advertisement")
                }
            } header: {
                Text("Advertisement")
            }
        }
        .navigationTitle("Settings")
        .onAppear {
            if userId.count == 0 {
                userId = Environment.shared.userId ?? ""
            }
            creativeType = .from(string: advCustomCreativeType)
        }
    }

    // MARK: - Private

    private func updateUserId(value: String) {
        let number = UInt(value)
        userId = number != nil ? value : ""
        Environment.shared.userId = userId
    }

    private func updateAdvDebug(value: Bool) {
        advDebug = value
        Environment.shared._advDebug = advDebug
    }

    private func updateCustomSlotId(value: String) {
        if let number = UInt(value) {
            advCustomSlotId = value
            Environment.shared._advCustomSlotId = NSNumber(value: number)
        } else {
            advCustomSlotId = ""
            Environment.shared._advCustomSlotId = nil
        }
    }

    private func updateCreativeType(value: MyTargetCreativeType) {
        advCustomCreativeType = value.jsonString ?? ""
        Environment.shared._advCustomCreativeType = value.jsonString
    }

    private func updateAdvExpId(value: String) {
        let number = UInt(value)
        advExpId = number != nil ? value : ""
        Environment.shared._advExpId = advExpId
    }

    private func updateAdvDeviceId(value: String) {
        advDeviceId = value
        Environment.shared._advDeviceId = advDeviceId
    }

    #if DEBUG

    private func updateFocusDebug(value: Bool) {
        focusDebug = value
        SettingsViewController.focusDebug = focusDebug
    }

    #endif

    private func updateHLS(value: Bool) {
        videoInHLS = value
        SettingsViewController.useHLS = videoInHLS
    }
}

@available(iOS 13.0, *)
struct SettingsView_Preview: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
