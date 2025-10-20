//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import Combine
import OVKit
import Photos
import UIKit

class ImportController: ViewController, UITextViewDelegate {
    var onImportVideo: ((Video) -> Void)!

    private var subscriptions = [AnyCancellable]()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupImportSourceView()

        view.addSubview(sourceView)
        view.addSubview(formatView)
        view.addSubview(textView)
        view.addSubview(keyboardButton)
        view.addSubview(applyButton)

        subscribeToKeyboard()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        handleHideKeyboard()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let safeFrame = view.frame.inset(by: view.safeAreaInsets)

        var sourceFrame = CGRect.zero
        sourceFrame.origin.x = max(max(view.safeAreaInsets.left, view.safeAreaInsets.right), 8)
        sourceFrame.origin.y = 18
        sourceFrame.size.width = view.bounds.width - 2 * sourceFrame.origin.x
        sourceFrame.size.height = sourceView.heightForWidth(sourceFrame.width)
        sourceView.frame = sourceFrame

        formatView.frame.origin = CGPoint(x: safeFrame.maxX - formatView.bounds.width - 8, y: sourceFrame.maxY + 4)

        let textViewY: CGFloat = formatView.frame.maxY + 4
        let textViewMaxY = keyboardY != nil ? keyboardY! : safeFrame.maxY
        textView.frame = CGRect(x: 0, y: textViewY, width: view.bounds.width, height: textViewMaxY - textViewY)

        applyButton.frame.origin = CGPoint(x: safeFrame.maxX - applyButton.bounds.width - 16, y: textViewMaxY - applyButton.bounds.height - 8)

        keyboardButton.frame.origin = CGPoint(x: safeFrame.minX + 16, y: applyButton.frame.midY - keyboardButton.bounds.height / 2)
        keyboardButton.alpha = keyboardY == nil ? 0 : 1
        keyboardButton.isUserInteractionEnabled = keyboardY != nil
    }

    // MARK: - Source View

    private let sourceView = ImportSourceView(frame: .zero)

    private func setupImportSourceView() {
        sourceView.addEntry(name: "Video", target: self, action: #selector(Self.handleImportVideo))
        sourceView.addEntry(name: "Live", target: self, action: #selector(Self.handleImportLive))
        sourceView.addEntry(name: "Pasteboard", target: self, action: #selector(Self.handleImportPasteboard))
        sourceView.addEntry(name: "File", target: self, action: #selector(Self.handleImportFile))
        sourceView.addEntry(name: "History", target: self, action: #selector(Self.handleOpenHistory))
    }

    @objc
    private func handleImportPasteboard() {
        guard let text = UIPasteboard.general.string else {
            return
        }

        textView.text = text
        didUpdateText()
    }

    @objc
    private func handleImportFile() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        picker.mediaTypes = ["public.movie"]
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc
    private func handleImportVideo() {
        textView.text = "https://vk.com/video-26006257_456245181"
        didUpdateText()
    }

    @objc
    private func handleImportLive() {
        textView.text = "https://vk.com/video-339767_456244698"
        didUpdateText()
    }

    @objc
    private func handleOpenHistory() {
        let vc = ImportTableController<ImportHistoryItem>(dataSource: ImportHistoryItem.loadAllItems())
        vc.onSelect = { [weak self] item in
            self?.textView.text = item.text
            self?.didUpdateText()
        }
        present(vc, animated: true)
    }

    // MARK: - Format View

    private lazy var formatView: ImportFormatView = {
        let view = ImportFormatView()
        view.addTarget(self, action: #selector(Self.handleFormatView), for: .touchUpInside)
        return view
    }()

    private func didUpdateText() {
        formatView.provideText(textView.text ?? "")
        applyButton.isEnabled = formatView.readyToApply
    }

    @objc
    private func handleFormatView() {
        let vc = ImportTableController<VideoFileFormat>(dataSource: VideoFileFormat.allCases)
        vc.onSelect = { [weak self] format in
            self?.formatView.correctFormat(format)
        }
        present(vc, animated: true)
    }

    // MARK: - Apply

    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.forward"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(font: .systemFont(ofSize: 20, weight: .semibold)), forImageIn: .normal)
        button.tintColor = UIColor(named: "tabbar_active")
        button.frame.size = CGSize(width: 44, height: 44)
        button.backgroundColor = .systemBackground
        button.clipsToBounds = true
        button.isEnabled = false
        button.layer.cornerRadius = button.frame.height / 2
        button.addTarget(self, action: #selector(Self.handleApplyButton), for: .touchUpInside)
        return button
    }()

    @objc
    private func handleApplyButton() {
        guard let video = formatView.makeVideo() else {
            return
        }

        ImportHistoryItem.append(textView.text ?? "")
        onImportVideo(video)
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Keyboard

    private var keyboardY: CGFloat?

    private lazy var keyboardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "keyboard.chevron.compact.down"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(font: .systemFont(ofSize: 20, weight: .medium)), forImageIn: .normal)
        button.tintColor = UIColor(named: "tabbar_active")
        button.backgroundColor = .systemBackground
        button.frame.size = CGSize(width: 54, height: 32)
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        button.addTarget(self, action: #selector(Self.handleHideKeyboard), for: .touchUpInside)
        return button
    }()

    @objc
    private func handleHideKeyboard() {
        textView.resignFirstResponder()
    }

    private func subscribeToKeyboard() {
        NotificationCenter.default
            .publisher(for: UIApplication.keyboardWillShowNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification))
            .sink { [unowned self] notification in
                updateKeyboardY(notification)
            }
            .store(in: &subscriptions)
    }

    private func updateKeyboardY(_ notification: Notification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        keyboardY = nil

        defer {
            UIView.animate(withDuration: duration, delay: 0, options: .init(rawValue: curve << 16)) {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
        }

        let keyboardFrameEnd = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let screen = (notification.object as? UIScreen) ?? view.window?.windowScene?.screen ?? UIScreen.main
        let fromCoordinateSpace = screen.coordinateSpace
        let toCoordinateSpace: UICoordinateSpace = view
        let convertedKeyboardFrameEnd = fromCoordinateSpace.convert(keyboardFrameEnd, to: toCoordinateSpace)

        let viewIntersection = view.bounds.intersection(convertedKeyboardFrameEnd)
        if !viewIntersection.isEmpty {
            keyboardY = viewIntersection.minY
        }
    }

    // MARK: - Text View

    private lazy var textView: UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 18)
        view.isEditable = true
        view.textColor = .label
        view.backgroundColor = .quaternarySystemFill
        view.delegate = self
        return view
    }()

    func textViewDidChange(_ textView: UITextView) {
        didUpdateText()
    }
}

extension ImportController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        guard let mediaURL = info[.mediaURL] as? URL else {
            print("No media URL found with UIImagePicker!")
            return
        }

        print("Loaded video from library: \(mediaURL)")
        textView.text = mediaURL.absoluteString
        didUpdateText()
    }
}

private struct ImportHistoryItem: Codable, ImportTableItem {
    let text: String

    static func loadAllItems() -> [ImportHistoryItem] {
        if let data = UserDefaults.standard.data(forKey: "demo_history_items") {
            if let items = try? JSONDecoder().decode([ImportHistoryItem].self, from: data) {
                return items
            }
        }
        return []
    }

    static func append(_ text: String) {
        guard !text.isEmpty else {
            return
        }

        var items = loadAllItems()
        if items.count > 20 {
            items = items.dropLast(1)
        }
        items.insert(ImportHistoryItem(text: text), at: 0)
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: "demo_history_items")
        }
    }
}

extension VideoFileFormat: ImportTableItem {
    var text: String { rawValue }
}
