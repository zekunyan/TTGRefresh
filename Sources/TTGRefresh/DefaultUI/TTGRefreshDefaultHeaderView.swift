import UIKit

@MainActor
public final class TTGRefreshDefaultHeaderView: UIView, TTGRefreshHeaderContentView {
    public var preferredHeight: CGFloat
    public var triggerHeight: CGFloat
    public var texts: TTGRefreshHeaderTextSet

    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let titleLabel = UILabel()
    private let stackView = UIStackView()

    public init(
        preferredHeight: CGFloat = 60,
        triggerHeight: CGFloat = 60,
        texts: TTGRefreshHeaderTextSet = .default
    ) {
        self.preferredHeight = preferredHeight
        self.triggerHeight = triggerHeight
        self.texts = texts
        super.init(frame: .zero)
        setupView()
        refreshHeaderDidChange(state: .idle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func refreshHeaderDidChange(state: TTGRefreshHeaderState) {
        switch state {
        case .idle:
            titleLabel.text = texts.idle
            activityIndicator.stopAnimating()
        case .pulling:
            titleLabel.text = texts.pulling
            activityIndicator.stopAnimating()
        case .willRefresh:
            titleLabel.text = texts.willRefresh
            activityIndicator.stopAnimating()
        case .refreshing:
            titleLabel.text = texts.refreshing
            activityIndicator.startAnimating()
        case .ending:
            titleLabel.text = texts.ending
            activityIndicator.stopAnimating()
        }
    }

    public func refreshHeaderDidUpdate(progress: CGFloat) {}

    private func setupView() {
        titleLabel.font = .preferredFont(forTextStyle: .footnote)
        titleLabel.textColor = .secondaryLabel
        titleLabel.adjustsFontForContentSizeCategory = true

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(titleLabel)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
