//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import UIKit

protocol ImportTableItem {
    var text: String { get }
}

class ImportTableController<Item: ImportTableItem>: UITableViewController {
    var onSelect: ((Item) -> Void)?

    private let items: [Item]

    init(dataSource: [Item]) {
        self.items = dataSource
        super.init(style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = items[indexPath.row].text
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelect?(items[indexPath.row])
        dismiss(animated: true)
    }
}
