import SwiftUI
import OVKit

class SettingsViewController: UIHostingController<SettingsView> {}

struct SettingsView: View {

    @AppStorage(Environment.demo_userIdKey)
    private var userId: String = ""

    @AppStorage(Environment.demo_advDebugKey)
    private var advDebug: Bool = false

    @AppStorage(Environment.demo_advDeviceIdKey)
    private var advDeviceId: String = ""

    @AppStorage(Environment.demo_advCustomSlotIdKey)
    private var advCustomSlotId: String = ""

    @AppStorage(Environment.demo_advCustomCreativeTypeKey)
    private var advCustomCreativeType: String = ""

    @AppStorage(Environment.demo_advExpIdKey)
    private var advExpId: String = ""

    @AppStorage(Environment.demo_enableMotionAdKey)
    private var enableVideoMotion: Bool = false
#if DEBUG
    @AppStorage(Environment.demo_focusDebug)
    private var focusDebug: Bool = false
#endif
    @State
    private var creativeType: MyTargetCreativeType = .auto

    var body: some View {
        Form {
            Section {
                TextField("[0-9]+", text: $userId)
                    .onChange(of: userId, perform: self.updateUserId)
            } header: {
                Text("User ID")
            } footer: {
                Text("Override vkId parameted for requested ads.")
            }
#if DEBUG
            Section {
                Toggle(isOn: $focusDebug.animation()) {
                    Text("Focus Preview")
                }
                .onChange(of: focusDebug, perform: self.updateFocusDebug)
            } footer: {
                Text("Enable Focus Preview for autoplay feature.")
            }
#endif
            Section {
                NavigationLink("Advertisement") {
                    List {
                        Section {
                            Toggle(isOn: $enableVideoMotion.animation()) {
                                Text("Video Motion")
                            }
                            .onChange(of: enableVideoMotion, perform: self.updateEnableVideoMotion)
                        } footer: {
                            Text("Enable Video Motion format for In-stream video ads.")
                        }
                        Section {
                            Toggle(isOn: $advDebug.animation()) {
                                Text("Debug Mode")
                            }
                            .onChange(of: advDebug, perform: self.updateAdvDebug)
                        }
                        if advDebug {
                            // Slot ID
                            Section {
                                TextField("Optional [0-9]+", text: $advCustomSlotId)
                                    .onChange(of: advCustomSlotId, perform: self.updateCustomSlotId)
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
                                }
                                .pickerStyle(.segmented)
                                .onChange(of: creativeType, perform: self.updateCreativeType)
                            } header: {
                                Text("Creative Type")
                            } footer: {
                                Text("Control type of banners for slot.")
                            }
                            // Exp ID
                            Section {
                                TextField("Optional String", text: $advExpId)
                                    .minimumScaleFactor(0.5)
                                    .onChange(of: advExpId, perform: self.updateAdvExpId)
                            } header: {
                                Text("Experiment Id")
                            } footer: {
                                Text("Override exp_id parameter for requested ads.")
                            }
                            // Device ID
                            Section {
                                TextField("Optional String", text: $advDeviceId)
                                    .minimumScaleFactor(0.5)
                                    .onChange(of: advDeviceId, perform: self.updateAdvDeviceId)
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

    // MARK - Private

    private func updateUserId(value: String) {
        let number = UInt(value)
        userId = number != nil ? value : ""
        Environment.shared.userId = userId
    }

    private func updateAdvDebug(value: Bool) {
        advDebug = value
        Environment.shared._advDebug = advDebug
    }

    private func updateEnableVideoMotion(value: Bool) {
        enableVideoMotion = value
        Environment._enableMotionAd = enableVideoMotion
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
        Environment.shared._focusDebug = focusDebug
    }

    #endif

}
