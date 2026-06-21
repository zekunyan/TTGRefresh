import TTGRefresh
import UIKit

final class ScrollShowcaseDemoViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let timestampLabel = UILabel()
    private var refreshCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Scroll"
        navigationItem.title = "Scroll View"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = DemoPalette.background
        setupScrollView()
        populateContent()
        configureRefresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setupScrollView() {
        scrollView.backgroundColor = DemoPalette.background
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        scrollView.pinToSuperviewEdges()

        stackView.axis = .vertical
        stackView.spacing = 18
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 22),
            stackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 18),
            stackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -18),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -28)
        ])
    }

    private func populateContent() {
        stackView.addArrangedSubview(makeHeroCard())
        stackView.addArrangedSubview(makeMetricsRow())

        [
            ("KVO driven", "No delegate forwarding is required, so existing scroll delegates remain untouched.", DemoPalette.accent),
            ("Inset aware", "The demo restores scroll insets after every refresh animation.", DemoPalette.mint),
            ("Content view protocol", "Any UIView can become a header or footer by implementing a small protocol.", DemoPalette.violet),
            ("Async friendly", "Swift concurrency actions can end automatically after the task finishes.", DemoPalette.coral)
        ].forEach { item in
            stackView.addArrangedSubview(makeFeatureCard(title: item.0, subtitle: item.1, color: item.2))
        }
    }

    private func configureRefresh() {
        var configuration = TTGRefreshConfiguration.default
        configuration.hapticsEnabled = true
        configuration.minimumRefreshingDuration = 0.5

        scrollView.ttg.addHeaderRefresh(
            contentView: GradientRefreshHeaderView(),
            configuration: configuration
        ) { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: 1_700_000_000)
            self.refreshCount += 1
            self.timestampLabel.text = "Updated \(self.refreshCount)x just now"
        }
    }

    private func makeHeroCard() -> UIView {
        let cardView = UIView()
        cardView.applyCardStyle(cornerRadius: 24)

        let badgeLabel = DemoPaddedLabel(horizontalPadding: 12)
        badgeLabel.text = "UIScrollView"
        badgeLabel.font = .systemFont(ofSize: 12, weight: .heavy)
        badgeLabel.textColor = DemoPalette.accent
        badgeLabel.backgroundColor = DemoPalette.accent.withAlphaComponent(0.12)
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 11
        badgeLabel.layer.masksToBounds = true

        let titleLabel = UILabel()
        titleLabel.text = "A refresh component that stays out of your layout."
        titleLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        titleLabel.textColor = DemoPalette.text
        titleLabel.numberOfLines = 0

        timestampLabel.text = "Pull down to update"
        timestampLabel.font = .preferredFont(forTextStyle: .subheadline)
        timestampLabel.textColor = DemoPalette.secondaryText

        let stack = UIStackView(arrangedSubviews: [badgeLabel, titleLabel, timestampLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(stack)

        NSLayoutConstraint.activate([
            badgeLabel.widthAnchor.constraint(equalToConstant: 104),
            badgeLabel.heightAnchor.constraint(equalToConstant: 26),
            stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),
            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24)
        ])

        return cardView
    }

    private func makeMetricsRow() -> UIView {
        let row = UIStackView(arrangedSubviews: [
            MetricPillView(title: "Targets", value: "3", color: DemoPalette.accent),
            MetricPillView(title: "Swift", value: "5.9", color: DemoPalette.mint),
            MetricPillView(title: "iOS", value: "16+", color: DemoPalette.violet)
        ])
        row.axis = .horizontal
        row.distribution = .fillEqually
        row.spacing = 10
        return row
    }

    private func makeFeatureCard(title: String, subtitle: String, color: UIColor) -> UIView {
        let cardView = UIView()
        cardView.applyCardStyle()

        let indicator = UIView()
        indicator.backgroundColor = color
        indicator.layer.cornerRadius = 5
        indicator.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = DemoPalette.text

        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = DemoPalette.secondaryText
        subtitleLabel.numberOfLines = 0

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 6

        let stack = UIStackView(arrangedSubviews: [indicator, textStack])
        stack.alignment = .top
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(stack)

        NSLayoutConstraint.activate([
            indicator.widthAnchor.constraint(equalToConstant: 10),
            indicator.heightAnchor.constraint(equalToConstant: 46),
            stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 18),
            stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 18),
            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18),
            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -18)
        ])

        return cardView
    }
}
