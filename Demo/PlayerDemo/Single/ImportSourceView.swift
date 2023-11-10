import UIKit


class ImportSourceView: UIView {
    
    func addEntry(name: String, target: Any?, action: Selector) {
        let button = UIButton(type: .system)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        button.backgroundColor = .tertiarySystemGroupedBackground
        button.setTitleColor(.label, for: .normal)
        button.setTitle(name, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.sizeToFit()
        button.frame.size = CGSize(width: ceil(button.frame.width) + 12, height: 32)
        
        addSubview(button)
        items.append(button)
    }
    
    
    func heightForWidth(_ width: CGFloat) -> CGFloat {
        guard width > 0 else { return 0 }
        return itemsFrames(availableWidth: width).last?.maxY ?? 0
    }
    
    
    // MARK: - Private
    
    private let itemsPadding = CGPoint(x: 8, y: 6)
    
    private var items = [UIButton]()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let frames = itemsFrames(availableWidth: bounds.width)
        for i in 0..<frames.count {
            items[i].frame = frames[i]
        }
    }
    
    
    private func itemsFrames(availableWidth: CGFloat) -> [CGRect] {
        var frames = [CGRect]()
        var y = CGFloat(0)
        var x = CGFloat(0)
        for item in items {
            if x == 0 {
                frames.append(CGRect(origin: CGPoint(x: 0, y: y), size: item.bounds.size))
                x = item.bounds.width
            } else if x + itemsPadding.x + item.bounds.width <= availableWidth {
                let frame = CGRect(origin: CGPoint(x: x + itemsPadding.x, y: y), size: item.bounds.size)
                frames.append(frame)
                x = frame.maxX
            } else {
                y += itemsPadding.y + item.bounds.height
                frames.append(CGRect(origin: CGPoint(x: 0, y: y), size: item.bounds.size))
                x = item.bounds.width
            }
        }
        return frames
    }
}
