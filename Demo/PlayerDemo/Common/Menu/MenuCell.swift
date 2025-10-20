//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import OVKit
import UIKit

class MenuCell: UITableViewCell {
    static let reuseIdentifier = String(describing: MenuCell.self)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none
        indentationWidth = 40

        detailTextLabel?.font = .systemFont(ofSize: 14)
        detailTextLabel?.textColor = .secondaryLabel

        contentView.addSubview(iconView)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let contentSize = contentView.bounds
        let side: CGFloat = 28
        let leftMargin: CGFloat = 14
        iconView.frame = CGRect(
            x: leftMargin,
            y: (contentSize.height - side) / 2,
            width: side,
            height: side
        )
    }

    // MARK: - Public

    var isDisabled: Bool {
        get { isUserInteractionEnabled }
        set {
            isUserInteractionEnabled = !newValue
            let alpha = newValue ? 0.25 : 1.0
            iconView.alpha = alpha
            textLabel?.alpha = alpha
            detailTextLabel?.alpha = alpha
        }
    }

    override var isSelected: Bool {
        didSet {
            updateColors()
        }
    }

    func configure(with action: MenuAction, style: MenuStyle) {
        self.action = action

        let isMultiline = style == .selectionMultiline
        let isCancel = action.style == .cancel
        let showIcon = style != .selectionMultiline && style != .selectionCompact
        let showDetail = style != .imageTitle && !isCancel

        indentationLevel = showIcon ? 1 : 0

        textLabel?.text = action.title
        textLabel?.font = isCancel ? .boldSystemFont(ofSize: 18) : .systemFont(ofSize: 18)

        detailTextLabel?.text = action.message
        detailTextLabel?.isHidden = !showDetail
        detailTextLabel?.numberOfLines = isMultiline ? 0 : 1

        iconView.image = action.icon?.withRenderingMode(.alwaysTemplate)
        iconView.isHidden = !showIcon

        isSelected = action.selected
        isDisabled = action.disabled

        accessibilityTraits = isSelected ? .selected : []
        accessibilityIdentifier = action.accessibilityId

        updateColors()
    }

    // MARK: - Private

    private let iconView = UIImageView()

    private var action: MenuAction?

    private func updateColors() {
        guard let action else {
            return
        }

        let actionColor: UIColor
        if action.style == .destructive {
            actionColor = .systemRed
        } else {
            actionColor = action.selected ? tintColor : UIColor.label
        }

        textLabel?.textColor = actionColor
        iconView.tintColor = actionColor
    }
}
