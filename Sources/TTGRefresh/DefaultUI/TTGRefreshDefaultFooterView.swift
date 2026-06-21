import UIKit

@MainActor
public final class TTGRefreshDefaultFooterView: UIView, TTGRefreshFooterContentView {
    public var preferredHeight: CGFloat
    public var triggerHeight: CGFloat
    public var texts: TTGRefreshFooterTextSet

    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let titleLabel = UILabel()
    private let stackView = UIStackView()

    public init(
        preferredHeight: CGFloat = 50,
        triggerHeight: CGFloat = 50,
        texts: TTGRefreshFooterTextSet = .default
    ) {
        self.preferredHeight = preferredHeight
        self.triggerHeight = triggerHeight
        self.texts = texts
        super.init(frame: .zero)
        setupView()
        refreshFooterDidChange(state: .idle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func refreshFooterDidChange(state: TTGRefreshFooterState) {
        switch state {
        case .idle:
            titleLabel.text = texts.idle
            activityIndicator.stopAnimating()
        case .pulling:
            titleLabel.text = texts.pulling
            activityIndicator.stopAnimating()
        case .willLoad:
            titleLabel.text = texts.willLoad
            activityIndicator.stopAnimating()
        case .loading:
            titleLabel.text = texts.loading
            activityIndicator.startAnimating()
        case .noMoreData:
            titleLabel.text = texts.noMoreData
            activityIndicator.stopAnimating()
        case .hidden:
            titleLabel.text = nil
            activityIndicator.stopAnimating()
        }
    }

    public func refreshFooterDidUpdate(progress: CGFloat) {}

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
