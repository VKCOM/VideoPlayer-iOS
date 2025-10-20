//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import UIKit

class DownloadsCollectionFooter: UICollectionReusableView {
    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()

    // MARK: - Initialization & Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(label)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        label.frame = bounds
    }

    // MARK: - Public

    static let reuseId = String(describing: DownloadsCollectionFooter.self)

    override var reuseIdentifier: String? {
        Self.reuseId
    }

    func updateText(_ text: String) {
        label.text = text
    }
}
