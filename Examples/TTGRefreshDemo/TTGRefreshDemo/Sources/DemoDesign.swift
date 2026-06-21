import UIKit

enum DemoPalette {
    static let background = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.06, green: 0.07, blue: 0.09, alpha: 1)
            : UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1)
    }

    static let groupedBackground = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.10, green: 0.11, blue: 0.14, alpha: 1)
            : UIColor.white
    }

    static let elevatedBackground = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.13, green: 0.15, blue: 0.18, alpha: 1)
            : UIColor.white
    }

    static let accent = UIColor(red: 0.10, green: 0.48, blue: 0.94, alpha: 1)
    static let mint = UIColor(red: 0.02, green: 0.66, blue: 0.55, alpha: 1)
    static let coral = UIColor(red: 0.94, green: 0.34, blue: 0.28, alpha: 1)
    static let amber = UIColor(red: 0.94, green: 0.64, blue: 0.13, alpha: 1)
    static let violet = UIColor(red: 0.45, green: 0.33, blue: 0.86, alpha: 1)
    static let text = UIColor.label
    static let secondaryText = UIColor.secondaryLabel
    static let separator = UIColor.separator.withAlphaComponent(0.35)

    static let demoColors: [UIColor] = [accent, mint, coral, amber, violet]
}

extension UIView {
    func pinToSuperviewEdges(insets: UIEdgeInsets = .zero) {
        guard let superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
        ])
    }

    func applyCardStyle(cornerRadius: CGFloat = 18) {
        backgroundColor = DemoPalette.elevatedBackground
        layer.cornerRadius = cornerRadius
        layer.cornerCurve = .continuous
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 14
        layer.shadowOffset = CGSize(width: 0, height: 8)
    }
}

final class DemoPaddedLabel: UILabel {
    var contentInsets: UIEdgeInsets {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }

    init(horizontalPadding: CGFloat = 10, verticalPadding: CGFloat = 0) {
        self.contentInsets = UIEdgeInsets(
            top: verticalPadding,
            left: horizontalPadding,
            bottom: verticalPadding,
            right: horizontalPadding
        )
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + contentInsets.left + contentInsets.right,
            height: size.height + contentInsets.top + contentInsets.bottom
        )
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInsets))
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetBounds = bounds.inset(by: contentInsets)
        let rect = super.textRect(forBounds: insetBounds, limitedToNumberOfLines: numberOfLines)
        return CGRect(
            x: rect.minX - contentInsets.left,
            y: rect.minY - contentInsets.top,
            width: rect.width + contentInsets.left + contentInsets.right,
            height: rect.height + contentInsets.top + contentInsets.bottom
        )
    }
}

final class MetricPillView: UIView {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()

    init(title: String, value: String, color: UIColor) {
        super.init(frame: .zero)
        setup(title: title, value: value, color: color)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(title: String, value: String, color: UIColor) {
        backgroundColor = color.withAlphaComponent(0.12)
        layer.cornerRadius = 14
        layer.cornerCurve = .continuous

        titleLabel.text = title
        titleLabel.font = .preferredFont(forTextStyle: .caption1)
        titleLabel.textColor = DemoPalette.secondaryText

        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 20, weight: .bold)
        valueLabel.textColor = color

        let stackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
}

final class DemoHeaderView: UIView {
    private let badgeLabel = DemoPaddedLabel(horizontalPadding: 11)
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    init(badge: String, title: String, subtitle: String, color: UIColor) {
        super.init(frame: .zero)
        setupView(badge: badge, title: title, subtitle: subtitle, color: color)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func tableHeader(badge: String, title: String, subtitle: String, color: UIColor) -> DemoHeaderView {
        let headerView = DemoHeaderView(badge: badge, title: title, subtitle: subtitle, color: color)
        headerView.frame = CGRect(x: 0, y: 0, width: 1, height: 154)
        return headerView
    }

    private func setupView(badge: String, title: String, subtitle: String, color: UIColor) {
        backgroundColor = DemoPalette.background

        badgeLabel.text = badge
        badgeLabel.font = .systemFont(ofSize: 12, weight: .heavy)
        badgeLabel.textColor = color
        badgeLabel.textAlignment = .center
        badgeLabel.backgroundColor = color.withAlphaComponent(0.12)
        badgeLabel.layer.cornerRadius = 11
        badgeLabel.layer.masksToBounds = true

        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        titleLabel.textColor = DemoPalette.text
        titleLabel.numberOfLines = 0

        subtitleLabel.text = subtitle
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = DemoPalette.secondaryText
        subtitleLabel.numberOfLines = 0

        let stackView = UIStackView(arrangedSubviews: [badgeLabel, titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 86),
            badgeLabel.heightAnchor.constraint(equalToConstant: 24),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 18),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12)
        ])
    }
}

final class DemoCollectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "DemoCollectionHeaderView"

    private var headerView: DemoHeaderView?

    func configure(badge: String, title: String, subtitle: String, color: UIColor) {
        headerView?.removeFromSuperview()

        let headerView = DemoHeaderView(badge: badge, title: title, subtitle: subtitle, color: color)
        addSubview(headerView)
        headerView.pinToSuperviewEdges()
        self.headerView = headerView
    }
}
