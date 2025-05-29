import UIKit
import OVKit


final class AdsSupplementaryViewController: UIViewController {


    private var contentContainerView = UIView()


    private var supplementaryView: SupplementaryAdControlsView?


    override func loadView() {
        super.loadView()

        title = "Ads Supplementary"

        // Container
        contentContainerView.backgroundColor = .secondarySystemBackground
        contentContainerView.layer.cornerRadius = 8.0
        contentContainerView.layer.masksToBounds = true
        contentContainerView.layoutMargins = .init(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        view.addSubview(contentContainerView)

        // Supplementary
        supplementaryView = SupplementaryAdControlsView(frame: .zero, style: SupplementaryAdViewStyle.init(
                                                                edgeInsets: .init(top: 12, left: 12, bottom: 12, right: 12),
                                                                buttonInsets: .init(top: 1, left: 0, bottom: 1, right: 0),
                                                                imageRadius: 14
                                                            ),
                                                        showsProgress: true
        )
        if let supplementaryView {
            supplementaryView.overrideUserInterfaceStyle = .dark
            supplementaryView.translatesAutoresizingMaskIntoConstraints = false
            supplementaryView.controlMask = .demoControlMask()
            supplementaryView.backgroundColor = .tertiarySystemBackground.withAlphaComponent(0.36)
            supplementaryView.layer.cornerRadius = 8.0
            supplementaryView.layer.masksToBounds = true
            contentContainerView.addSubview(supplementaryView)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        if let supplementaryView {
            let constraints: [NSLayoutConstraint] = [
                supplementaryView.centerYAnchor.constraint(equalTo: contentContainerView.centerYAnchor),
                supplementaryView.heightAnchor.constraint(equalToConstant: 50),
                supplementaryView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 8.0),
                supplementaryView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -8.0),
            ]
            contentContainerView.addConstraints(constraints)
        }

        view.backgroundColor = .systemBackground
    }


    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        contentContainerView.frame = view.bounds
            .inset(by: view.layoutMargins)
    }
}
