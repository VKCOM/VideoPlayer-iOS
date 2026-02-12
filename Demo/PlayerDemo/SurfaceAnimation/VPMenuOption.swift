struct VPMenuOption<T: Equatable> {
    let value: T
    let title: String
    let accessibilityIdentifier: String?

    init(value: T, title: String, accessibilityIdentifier: String? = nil) {
        self.value = value
        self.title = title
        self.accessibilityIdentifier = accessibilityIdentifier
    }

    init(_ value: T, _ title: String) {
        self.init(value: value, title: title, accessibilityIdentifier: nil)
    }
}
