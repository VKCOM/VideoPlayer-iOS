//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import OVKit
import UIKit

class MenuController: UIViewController {
    private static let stackSpacing: CGFloat = 8.0

    private static let blurEffect = UIBlurEffect(style: .systemChromeMaterial)

    // MARK: - Public

    var onHeightUpdate: VoidBlock?

    var contentHeight: CGFloat {
        let bounds = view.bounds
        let maxSize = CGSize(width: bounds.width, height: .greatestFiniteMagnitude)
        let spacing = (titleVibrancyWrapper.isHidden ? 0 : Self.stackSpacing) + (messageVibrancyWrapper.isHidden ? 0 : Self.stackSpacing)

        return titleLabel.sizeThatFits(maxSize).height
            + messageLabel.sizeThatFits(maxSize).height
            + tableView.contentSize.height
            + view.safeAreaInsets.bottom
            + spacing
            + topInset
    }

    // MARK: - Life cycle

    init(menu: Menu) {
        self.menu = menu
        self.backgroundView = UIVisualEffectView(effect: Self.blurEffect)

        super.init(nibName: nil, bundle: nil)

        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        modalPresentationStyle = .custom
        transitioningDelegate = strongTransitioningDelegate

        backgroundView.contentView.addSubview(stackView)

        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = Self.stackSpacing

        for item in [titleVibrancyWrapper, messageVibrancyWrapper, tableView] {
            stackView.addArrangedSubview(item)
        }

        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 18)

        messageLabel.font = .systemFont(ofSize: 14)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        tableView.alwaysBounceVertical = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuCell.self, forCellReuseIdentifier: MenuCell.reuseIdentifier)
        tableView.accessibilityIdentifier = "video_player.settings_menu.table_view"

        menu.onUpdate = { [weak self] in
            self?.handleContentsUpdate()
        }

        handleContentsUpdate()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = backgroundView
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        handleContentsUpdate()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        menu.didPresent()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        menu.didDismiss()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let horizontalMargin: CGFloat = 12.0
        stackView.frame = CGRect(
            x: horizontalMargin,
            y: topInset,
            width: view.bounds.width - horizontalMargin * 2,
            height: view.bounds.height
        )
    }

    // MARK: - Private

    private let menu: Menu
    private let strongTransitioningDelegate = MenuTransitioningDelegate()

    private let backgroundView: UIVisualEffectView

    private let stackView = UIStackView()
    private let tableView = UITableView(frame: .zero, style: .plain)

    private let titleLabel = UILabel()
    private lazy var titleVibrancyWrapper = Self.createVibrancyWrapper(for: titleLabel)
    private let messageLabel = UILabel()
    private lazy var messageVibrancyWrapper = Self.createVibrancyWrapper(for: messageLabel)

    private var topInset: CGFloat {
        let headerInvisible = titleVibrancyWrapper.isHidden && messageVibrancyWrapper.isHidden
        return max(headerInvisible ? 0.0 : 12.0, view.safeAreaInsets.top)
    }

    private var actions = [MenuAction]()

    private static func createVibrancyWrapper(for label: UILabel) -> UIVisualEffectView {
        let wrapper = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: Self.blurEffect))
        wrapper.contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            wrapper.contentView.leftAnchor.constraint(equalTo: label.leftAnchor),
            wrapper.contentView.rightAnchor.constraint(equalTo: label.rightAnchor),
            wrapper.contentView.topAnchor.constraint(equalTo: label.topAnchor),
            wrapper.contentView.bottomAnchor.constraint(equalTo: label.bottomAnchor),
        ])

        return wrapper
    }

    private func handleContentsUpdate() {
        let menuActions = menu.contents.actions
        let cancelAction = menuActions.first(where: { $0.style == .cancel })
        actions = menuActions.filter { $0 !== cancelAction }
        if let cancelAction {
            actions.append(cancelAction)
        }

        let titleText = menu.contents.title
        titleLabel.text = titleText
        titleVibrancyWrapper.isHidden = titleText == nil

        let messageText = menu.contents.message
        messageLabel.text = messageText
        messageVibrancyWrapper.isHidden = messageText == nil

        tableView.reloadData()

        view.setNeedsLayout()
        view.layoutIfNeeded()

        onHeightUpdate?()
    }
}

// MARK: - UITableViewDataSource

extension MenuController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        actions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.reuseIdentifier, for: indexPath) as? MenuCell else {
            return UITableViewCell()
        }

        cell.configure(with: actions[indexPath.row], style: menu.style)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MenuController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = actions[indexPath.row]

        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        dismiss(animated: true) {
            action.action?()
        }
    }
}
