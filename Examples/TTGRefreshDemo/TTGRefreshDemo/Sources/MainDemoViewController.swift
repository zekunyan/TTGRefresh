import TTGRefresh
import UIKit

final class MainDemoViewController: UITableViewController {
    private enum Row {
        case live(FeedItem)
        case demo(DemoEntry)
        case note(title: String, subtitle: String, color: UIColor)
    }

    struct DemoEntry {
        let title: String
        let subtitle: String
        let badge: String
        let symbolName: String
        let color: UIColor
        let makeViewController: () -> UIViewController
    }

    private var refreshCount = 0
    private var loadedNoteCount = 0
    private var liveItems = DemoContentFactory.feedItems(page: 1, count: 2)

    private lazy var demos: [DemoEntry] = [
        DemoEntry(
            title: "Default header and footer",
            subtitle: "Minimal API for pull-to-refresh and pull-up load more.",
            badge: "BASIC",
            symbolName: "arrow.triangle.2.circlepath",
            color: DemoPalette.accent,
            makeViewController: { FeedTableDemoViewController() }
        ),
        DemoEntry(
            title: "Infinite load",
            subtitle: "Preload the next page before users hit the end.",
            badge: "INFINITE",
            symbolName: "bolt.fill",
            color: DemoPalette.mint,
            makeViewController: { InfiniteLoadDemoViewController() }
        ),
        DemoEntry(
            title: "Overlay refresh",
            subtitle: "Android-style pull plus code-triggered refresh and load more.",
            badge: "OVERLAY",
            symbolName: "waveform.path.ecg.rectangle",
            color: DemoPalette.coral,
            makeViewController: { OverlayRefreshDemoViewController() }
        ),
        DemoEntry(
            title: "Plain UIScrollView",
            subtitle: "The same component works without table or collection views.",
            badge: "SCROLL",
            symbolName: "rectangle.and.hand.point.up.left",
            color: DemoPalette.amber,
            makeViewController: { ScrollShowcaseDemoViewController() }
        ),
        DemoEntry(
            title: "Custom refresh views",
            subtitle: "Drive custom UIView animations with state and progress.",
            badge: "CUSTOM",
            symbolName: "sparkles",
            color: DemoPalette.violet,
            makeViewController: { CustomRefreshDemoViewController() }
        ),
        DemoEntry(
            title: "Path effect gallery",
            subtitle: "Browse 20 paired refresh and load-more path animation concepts.",
            badge: "20 STYLES",
            symbolName: "scribble.variable",
            color: DemoPalette.accent,
            makeViewController: { PathEffectGalleryDemoViewController() }
        )
    ]

    private var rows: [Row] {
        liveItems.map(Row.live)
            + demos.map(Row.demo)
            + loadedNotes
    }

    private var loadedNotes: [Row] {
        guard loadedNoteCount > 0 else { return [] }
        return (0..<loadedNoteCount).map { index in
            Row.note(
                title: ["No delegate forwarding", "Inset restoration", "No more data", "Swift concurrency"][index % 4],
                subtitle: [
                    "KVO keeps business scroll delegates untouched.",
                    "Top and bottom inset additions are tracked independently.",
                    "Footer state can switch into a stable terminal state.",
                    "Async closures can end refreshing automatically."
                ][index % 4],
                color: DemoPalette.demoColors[index % DemoPalette.demoColors.count]
            )
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TTGRefresh"
        configureTableView()
        configureRefresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func configureTableView() {
        tableView.backgroundColor = DemoPalette.background
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 28, right: 0)
        tableView.register(MainLiveCell.self, forCellReuseIdentifier: MainLiveCell.reuseIdentifier)
        tableView.register(MainDemoEntryCell.self, forCellReuseIdentifier: MainDemoEntryCell.reuseIdentifier)
        tableView.register(MainNoteCell.self, forCellReuseIdentifier: MainNoteCell.reuseIdentifier)
        tableView.tableHeaderView = MainHeroHeaderView.makeTableHeader()
    }

    private func configureRefresh() {
        var configuration = TTGRefreshConfiguration.default
        configuration.minimumRefreshingDuration = 0.4
        configuration.automaticallyChangeAlpha = true

        tableView.ttg.addHeaderRefresh(configuration: configuration) { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: 1_700_000_000)
            self.refreshCount += 1
            self.liveItems = DemoContentFactory.feedItems(page: self.refreshCount + 1, count: 2)
            self.loadedNoteCount = 0
            self.tableView.reloadData()
            self.tableView.ttg.resetFooterNoMoreData()
        }

        tableView.ttg.addFooterRefresh(configuration: configuration) { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: 1_450_000_000)
            self.loadedNoteCount += 2
            self.tableView.reloadData()

            if self.loadedNoteCount >= 4 {
                self.tableView.ttg.endFooterRefreshingWithNoMoreData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        switch rows[indexPath.row] {
        case .live(let item):
            let cell = tableView.dequeueReusableCell(withIdentifier: MainLiveCell.reuseIdentifier, for: indexPath) as! MainLiveCell
            cell.configure(with: item)
            return cell
        case .demo(let demo):
            let cell = tableView.dequeueReusableCell(withIdentifier: MainDemoEntryCell.reuseIdentifier, for: indexPath) as! MainDemoEntryCell
            cell.configure(with: demo)
            return cell
        case .note(let title, let subtitle, let color):
            let cell = tableView.dequeueReusableCell(withIdentifier: MainNoteCell.reuseIdentifier, for: indexPath) as! MainNoteCell
            cell.configure(title: title, subtitle: subtitle, color: color)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case .demo(let demo) = rows[indexPath.row] else { return }
        let viewController = demo.makeViewController()
        viewController.title = demo.title
        navigationController?.pushViewController(viewController, animated: true)
    }
}

private final class MainHeroHeaderView: UIView {
    static func makeTableHeader() -> MainHeroHeaderView {
        let header = MainHeroHeaderView(frame: CGRect(x: 0, y: 0, width: 1, height: 306))
        return header
    }

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = DemoPalette.background

        let badgeLabel = DemoPaddedLabel(horizontalPadding: 12)
        badgeLabel.text = "ZERO-DELEGATE · EXTENSIBLE"
        badgeLabel.font = .systemFont(ofSize: 12, weight: .heavy)
        badgeLabel.textColor = DemoPalette.accent
        badgeLabel.backgroundColor = DemoPalette.accent.withAlphaComponent(0.12)
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 12
        badgeLabel.layer.masksToBounds = true

        titleLabel.text = "TTGRefresh"
        titleLabel.font = .systemFont(ofSize: 42, weight: .heavy)
        titleLabel.textColor = DemoPalette.text

        subtitleLabel.text = "Refresh for lists, grids, and scroll views."
        subtitleLabel.font = .preferredFont(forTextStyle: .body)
        subtitleLabel.textColor = DemoPalette.secondaryText
        subtitleLabel.numberOfLines = 0

        let metricRow = UIStackView(arrangedSubviews: [
            MetricPillView(title: "Header", value: "Pull", color: DemoPalette.accent),
            MetricPillView(title: "Footer", value: "Infinite", color: DemoPalette.mint),
            MetricPillView(title: "Views", value: "Custom", color: DemoPalette.violet)
        ])
        metricRow.axis = .horizontal
        metricRow.distribution = .fillEqually
        metricRow.spacing = 10

        let hintCard = makeHintCard()

        let stackView = UIStackView(arrangedSubviews: [badgeLabel, titleLabel, subtitleLabel, metricRow, hintCard])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 14
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            badgeLabel.widthAnchor.constraint(equalToConstant: 206),
            badgeLabel.heightAnchor.constraint(equalToConstant: 26),
            metricRow.heightAnchor.constraint(equalToConstant: 74),
            hintCard.heightAnchor.constraint(equalToConstant: 58),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 18),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    private func makeHintCard() -> UIView {
        let card = UIView()
        card.backgroundColor = DemoPalette.mint.withAlphaComponent(0.12)
        card.layer.cornerRadius = 18
        card.layer.cornerCurve = .continuous

        let icon = UIImageView(image: UIImage(systemName: "hand.draw.fill"))
        icon.tintColor = DemoPalette.mint
        icon.contentMode = .scaleAspectFit

        let label = UILabel()
        label.text = "Pull down to refresh. Pull up to load more notes."
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = DemoPalette.text
        label.numberOfLines = 2

        let stack = UIStackView(arrangedSubviews: [icon, label])
        stack.alignment = .center
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(stack)

        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 24),
            icon.heightAnchor.constraint(equalToConstant: 24),
            stack.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 18),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -18)
        ])

        return card
    }
}

private final class MainLiveCell: UITableViewCell {
    static let reuseIdentifier = "MainLiveCell"

    private let cardView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let tagLabel = DemoPaddedLabel(horizontalPadding: 10)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: FeedItem) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        tagLabel.text = item.tag
        tagLabel.textColor = item.tintColor
        tagLabel.backgroundColor = item.tintColor.withAlphaComponent(0.12)
    }

    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none

        cardView.applyCardStyle(cornerRadius: 18)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = DemoPalette.text
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = DemoPalette.secondaryText
        subtitleLabel.numberOfLines = 2
        tagLabel.font = .systemFont(ofSize: 12, weight: .bold)
        tagLabel.textAlignment = .center
        tagLabel.layer.cornerRadius = 10
        tagLabel.layer.masksToBounds = true

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 6

        let stack = UIStackView(arrangedSubviews: [textStack, tagLabel])
        stack.alignment = .center
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(stack)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
            tagLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 58),
            tagLabel.heightAnchor.constraint(equalToConstant: 24),
            stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
    }
}

private final class MainDemoEntryCell: UITableViewCell {
    static let reuseIdentifier = "MainDemoEntryCell"

    private let cardView = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let badgeLabel = DemoPaddedLabel(horizontalPadding: 10)
    private let chevronView = UIImageView(image: UIImage(systemName: "chevron.right"))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with demo: MainDemoViewController.DemoEntry) {
        iconView.image = UIImage(systemName: demo.symbolName)
        iconView.tintColor = demo.color
        iconView.backgroundColor = demo.color.withAlphaComponent(0.12)
        titleLabel.text = demo.title
        subtitleLabel.text = demo.subtitle
        badgeLabel.text = demo.badge
        badgeLabel.textColor = demo.color
        badgeLabel.backgroundColor = demo.color.withAlphaComponent(0.12)
        accessibilityLabel = "\(demo.title), \(demo.subtitle)"
    }

    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
        isAccessibilityElement = true
        accessibilityTraits = [.button]

        cardView.applyCardStyle(cornerRadius: 20)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        iconView.contentMode = .center
        iconView.layer.cornerRadius = 18
        iconView.layer.cornerCurve = .continuous
        iconView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = DemoPalette.text
        titleLabel.numberOfLines = 1
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = DemoPalette.secondaryText
        subtitleLabel.numberOfLines = 2

        badgeLabel.font = .systemFont(ofSize: 11, weight: .heavy)
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 9
        badgeLabel.layer.masksToBounds = true

        chevronView.tintColor = .tertiaryLabel
        chevronView.setContentCompressionResistancePriority(.required, for: .horizontal)

        let textStack = UIStackView(arrangedSubviews: [badgeLabel, titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.spacing = 6

        let stack = UIStackView(arrangedSubviews: [iconView, textStack, chevronView])
        stack.alignment = .center
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(stack)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            iconView.widthAnchor.constraint(equalToConstant: 46),
            iconView.heightAnchor.constraint(equalToConstant: 46),
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 62),
            badgeLabel.heightAnchor.constraint(equalToConstant: 22),
            stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
    }
}

private final class MainNoteCell: UITableViewCell {
    static let reuseIdentifier = "MainNoteCell"

    private let cardView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let indicatorView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, subtitle: String, color: UIColor) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        indicatorView.backgroundColor = color
    }

    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none

        cardView.backgroundColor = DemoPalette.elevatedBackground
        cardView.layer.cornerRadius = 16
        cardView.layer.cornerCurve = .continuous
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        indicatorView.layer.cornerRadius = 4
        indicatorView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = DemoPalette.text
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = DemoPalette.secondaryText
        subtitleLabel.numberOfLines = 2

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 4

        let stack = UIStackView(arrangedSubviews: [indicatorView, textStack])
        stack.alignment = .top
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(stack)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            indicatorView.widthAnchor.constraint(equalToConstant: 8),
            indicatorView.heightAnchor.constraint(equalToConstant: 42),
            stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -14)
        ])
    }
}
