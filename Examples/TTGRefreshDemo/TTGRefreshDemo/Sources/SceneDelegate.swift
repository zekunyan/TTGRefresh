import TTGRefresh
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        window.tintColor = DemoPalette.accent
        let rootViewController = ScreenshotScene.current?.makeViewController() ?? MainDemoViewController()
        window.rootViewController = DemoNavigationController(rootViewController: rootViewController)
        self.window = window
        window.makeKeyAndVisible()
    }
}

private enum ScreenshotScene: String {
    case posterOverview
    case posterLoadMore
    case posterCustomPaths
    case posterPathGrid
    case quickStartBasic
    case quickStartInfinite
    case quickStartCustom

    static var current: ScreenshotScene? {
        let arguments = ProcessInfo.processInfo.arguments
        guard let index = arguments.firstIndex(of: "--ttg-screenshot"),
              arguments.indices.contains(index + 1) else {
            return nil
        }
        return ScreenshotScene(rawValue: arguments[index + 1])
    }

    func makeViewController() -> UIViewController {
        switch self {
        case .posterPathGrid:
            return ScreenshotPathGridViewController()
        case .posterOverview, .posterLoadMore, .posterCustomPaths, .quickStartBasic, .quickStartInfinite, .quickStartCustom:
            return ScreenshotFeatureViewController(scene: self)
        }
    }
}

private enum ScreenshotLoadingMode {
    case refreshDefault
    case refreshPath(TTGRefreshPathEffectStyle)
    case loadMorePath(TTGRefreshPathEffectStyle)
    case infinitePath(TTGRefreshPathEffectStyle)
}

private struct ScreenshotFeatureItem {
    let title: String
    let subtitle: String
    let symbolName: String
    let color: UIColor
}

private enum ScreenshotFeatureRow {
    case feature(ScreenshotFeatureItem)
    case code(String)
}

private struct ScreenshotFeatureContent {
    let badge: String
    let title: String
    let subtitle: String
    let color: UIColor
    let loadingMode: ScreenshotLoadingMode
    let rows: [ScreenshotFeatureRow]
}

private extension ScreenshotScene {
    var featureContent: ScreenshotFeatureContent {
        switch self {
        case .posterOverview:
            ScreenshotFeatureContent(
                badge: "POSTER · OVERVIEW",
                title: "Refresh for Every UIKit Scroll",
                subtitle: "Pull-to-refresh, pull load more, infinite load, async callbacks, and guarded state transitions share one simple UIScrollView API.",
                color: DemoPalette.accent,
                loadingMode: .refreshDefault,
                rows: [
                    .feature(ScreenshotFeatureItem(title: "Zero delegate forwarding", subtitle: "KVO tracks offsets without taking over table, collection, or scroll delegates.", symbolName: "point.3.connected.trianglepath.dotted", color: DemoPalette.accent)),
                    .feature(ScreenshotFeatureItem(title: "Mutual exclusion by default", subtitle: "Refresh and load more are coordinated so callbacks cannot overlap accidentally.", symbolName: "lock.shield.fill", color: DemoPalette.mint)),
                    .feature(ScreenshotFeatureItem(title: "Inset restoration", subtitle: "Top and bottom additions are tracked independently and restored after each state.", symbolName: "arrow.up.and.down.and.arrow.left.and.right", color: DemoPalette.violet)),
                    .feature(ScreenshotFeatureItem(title: "Async ready", subtitle: "Swift concurrency actions can end automatically after the loading task finishes.", symbolName: "bolt.horizontal.circle.fill", color: DemoPalette.amber))
                ]
            )
        case .posterLoadMore:
            ScreenshotFeatureContent(
                badge: "POSTER · LOAD MORE",
                title: "Pull Load More + Infinite Load",
                subtitle: "Choose deliberate pull-up loading or preload the next page before the user reaches the end.",
                color: DemoPalette.mint,
                loadingMode: .loadMorePath(.rocketOrbit),
                rows: [
                    .feature(ScreenshotFeatureItem(title: "Tap or pull footer", subtitle: "The footer can start from drag release or a direct tap in the load-more area.", symbolName: "hand.tap.fill", color: DemoPalette.mint)),
                    .feature(ScreenshotFeatureItem(title: "No more data state", subtitle: "Switch to a stable terminal state without extra table footer plumbing.", symbolName: "checkmark.seal.fill", color: DemoPalette.accent)),
                    .feature(ScreenshotFeatureItem(title: "Fast pagination", subtitle: "Infinite load supports a configurable preload offset for smoother feeds.", symbolName: "speedometer", color: DemoPalette.coral)),
                    .feature(ScreenshotFeatureItem(title: "Path effect footer", subtitle: "Built-in footer styles use the same state callbacks as custom views.", symbolName: "scribble.variable", color: DemoPalette.violet))
                ]
            )
        case .posterCustomPaths:
            ScreenshotFeatureContent(
                badge: "POSTER · CUSTOM",
                title: "Custom Views, No Subclassing",
                subtitle: "Any UIView can become a refresh header or footer by implementing a small content protocol.",
                color: DemoPalette.violet,
                loadingMode: .refreshPath(.auroraWave),
                rows: [
                    .feature(ScreenshotFeatureItem(title: "State-driven UI", subtitle: "Idle, pulling, release, loading, ending, and no-more-data are exposed cleanly.", symbolName: "switch.2", color: DemoPalette.violet)),
                    .feature(ScreenshotFeatureItem(title: "Progress callbacks", subtitle: "Drive path drawing, scale, alpha, gradients, or any custom animation from pull progress.", symbolName: "chart.line.uptrend.xyaxis", color: DemoPalette.accent)),
                    .feature(ScreenshotFeatureItem(title: "20 built-in path sets", subtitle: "Use a bundled style immediately or override text, colors, height, and animation speed.", symbolName: "sparkles", color: DemoPalette.mint)),
                    .feature(ScreenshotFeatureItem(title: "UIKit-native", subtitle: "Works in UITableView, UICollectionView, and plain UIScrollView containers.", symbolName: "rectangle.stack.fill", color: DemoPalette.amber))
                ]
            )
        case .quickStartBasic:
            ScreenshotFeatureContent(
                badge: "QUICK START · 01",
                title: "Add Pull Refresh",
                subtitle: "Install the default header with one closure. The screenshot route triggers it automatically for documentation capture.",
                color: DemoPalette.accent,
                loadingMode: .refreshDefault,
                rows: [
                    .code("""
                    tableView.ttg.addHeaderRefresh {
                        await viewModel.reload()
                    }
                    """),
                    .feature(ScreenshotFeatureItem(title: "Default UI", subtitle: "A compact system-style header is ready without extra setup.", symbolName: "arrow.clockwise.circle.fill", color: DemoPalette.accent)),
                    .feature(ScreenshotFeatureItem(title: "Auto-end async", subtitle: "Async actions can restore the header when the task finishes.", symbolName: "checkmark.circle.fill", color: DemoPalette.mint))
                ]
            )
        case .quickStartInfinite:
            ScreenshotFeatureContent(
                badge: "QUICK START · 02",
                title: "Enable Infinite Load",
                subtitle: "Use preload offset to start loading before the user reaches the bottom of a long list.",
                color: DemoPalette.mint,
                loadingMode: .infinitePath(.pulseCircuit),
                rows: [
                    .code("""
                    collectionView.ttg.addInfiniteLoad(
                        preloadOffset: 180
                    ) {
                        await viewModel.loadNextPage()
                    }
                    """),
                    .feature(ScreenshotFeatureItem(title: "Preload distance", subtitle: "Tune how early the next page starts loading.", symbolName: "ruler.fill", color: DemoPalette.mint)),
                    .feature(ScreenshotFeatureItem(title: "Guarded callback", subtitle: "Repeated bottom offsets cannot start overlapping page loads.", symbolName: "lock.fill", color: DemoPalette.violet))
                ]
            )
        case .quickStartCustom:
            ScreenshotFeatureContent(
                badge: "QUICK START · 03",
                title: "Drop In a Path Effect",
                subtitle: "Switch to a built-in animated path header, then customize text, colors, sizing, and speed through a template.",
                color: DemoPalette.violet,
                loadingMode: .refreshPath(.auroraWave),
                rows: [
                    .code("""
                    tableView.ttg.addPathEffectHeaderRefresh(
                        style: .auroraWave
                    ) {
                        await viewModel.reload()
                    }
                    """),
                    .feature(ScreenshotFeatureItem(title: "Template based", subtitle: "Styles stay easy to use while remaining fully configurable.", symbolName: "slider.horizontal.3", color: DemoPalette.violet)),
                    .feature(ScreenshotFeatureItem(title: "Real content protocol", subtitle: "Path effects use the same UIView protocol as your own custom header.", symbolName: "sparkles", color: DemoPalette.accent))
                ]
            )
        case .posterPathGrid:
            fatalError("Path grid uses ScreenshotPathGridViewController")
        }
    }
}

private final class ScreenshotFeatureViewController: UITableViewController {
    private static let longLoadingNanoseconds: UInt64 = 600_000_000_000

    private let scene: ScreenshotScene
    private let content: ScreenshotFeatureContent
    private var didTriggerLoading = false

    init(scene: ScreenshotScene) {
        self.scene = scene
        self.content = scene.featureContent
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureRefresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !didTriggerLoading else { return }
        didTriggerLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            self?.triggerLoadingForScreenshot()
        }
    }

    private func configureTableView() {
        tableView.backgroundColor = DemoPalette.background
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        tableView.tableHeaderView = ScreenshotHeaderView.tableHeader(content: content)
        tableView.register(ScreenshotFeatureCell.self, forCellReuseIdentifier: ScreenshotFeatureCell.reuseIdentifier)
        tableView.register(ScreenshotCodeCell.self, forCellReuseIdentifier: ScreenshotCodeCell.reuseIdentifier)
    }

    private func configureRefresh() {
        var configuration = TTGRefreshConfiguration.default
        configuration.minimumRefreshingDuration = 300
        configuration.automaticallyChangeAlpha = true
        configuration.hapticsEnabled = false

        switch content.loadingMode {
        case .refreshDefault:
            tableView.ttg.addHeaderRefresh(configuration: configuration) {
                try? await Task.sleep(nanoseconds: Self.longLoadingNanoseconds)
            }
        case .refreshPath(let style):
            tableView.ttg.addPathEffectHeaderRefresh(style: style, configuration: configuration) {
                try? await Task.sleep(nanoseconds: Self.longLoadingNanoseconds)
            }
        case .loadMorePath(let style):
            tableView.ttg.addPathEffectHeaderRefresh(style: .auroraLoop, configuration: configuration) {
                try? await Task.sleep(nanoseconds: Self.longLoadingNanoseconds)
            }
            tableView.ttg.addPathEffectFooterRefresh(style: style, configuration: configuration) {
                try? await Task.sleep(nanoseconds: Self.longLoadingNanoseconds)
            }
        case .infinitePath(let style):
            tableView.ttg.addPathEffectHeaderRefresh(style: .zenRipple, configuration: configuration) {
                try? await Task.sleep(nanoseconds: Self.longLoadingNanoseconds)
            }
            tableView.ttg.addPathEffectInfiniteLoad(style: style, preloadOffset: 180, configuration: configuration) {
                try? await Task.sleep(nanoseconds: Self.longLoadingNanoseconds)
            }
        }
    }

    private func triggerLoadingForScreenshot() {
        switch content.loadingMode {
        case .refreshDefault, .refreshPath:
            tableView.ttg.triggerRefresh(animated: false)
        case .loadMorePath, .infinitePath:
            tableView.layoutIfNeeded()
            tableView.ttg.triggerLoadMore(animated: false)
            tableView.layoutIfNeeded()
            let offsetY = max(
                -tableView.adjustedContentInset.top,
                tableView.contentSize.height - tableView.bounds.height + tableView.adjustedContentInset.bottom
            )
            tableView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: false)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        content.rows.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        switch content.rows[indexPath.row] {
        case .feature(let feature):
            let cell = tableView.dequeueReusableCell(withIdentifier: ScreenshotFeatureCell.reuseIdentifier, for: indexPath) as! ScreenshotFeatureCell
            cell.configure(feature)
            return cell
        case .code(let code):
            let cell = tableView.dequeueReusableCell(withIdentifier: ScreenshotCodeCell.reuseIdentifier, for: indexPath) as! ScreenshotCodeCell
            cell.configure(code: code, color: content.color)
            return cell
        }
    }
}

private final class ScreenshotHeaderView: UIView {
    static func tableHeader(content: ScreenshotFeatureContent) -> ScreenshotHeaderView {
        let view = ScreenshotHeaderView(content: content)
        view.frame = CGRect(x: 0, y: 0, width: 1, height: 238)
        return view
    }

    private init(content: ScreenshotFeatureContent) {
        super.init(frame: .zero)
        setup(content: content)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(content: ScreenshotFeatureContent) {
        backgroundColor = DemoPalette.background

        let badgeLabel = DemoPaddedLabel(horizontalPadding: 12)
        badgeLabel.text = content.badge
        badgeLabel.font = .systemFont(ofSize: 12, weight: .heavy)
        badgeLabel.textColor = content.color
        badgeLabel.backgroundColor = content.color.withAlphaComponent(0.12)
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 12
        badgeLabel.layer.masksToBounds = true

        let titleLabel = UILabel()
        titleLabel.text = content.title
        titleLabel.font = .systemFont(ofSize: 36, weight: .heavy)
        titleLabel.textColor = DemoPalette.text
        titleLabel.numberOfLines = 2

        let subtitleLabel = UILabel()
        subtitleLabel.text = content.subtitle
        subtitleLabel.font = .preferredFont(forTextStyle: .body)
        subtitleLabel.textColor = DemoPalette.secondaryText
        subtitleLabel.numberOfLines = 0

        let stack = UIStackView(arrangedSubviews: [badgeLabel, titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 11
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            badgeLabel.heightAnchor.constraint(equalToConstant: 26),
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 18),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16)
        ])
    }
}

private final class ScreenshotFeatureCell: UITableViewCell {
    static let reuseIdentifier = "ScreenshotFeatureCell"

    private let cardView = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ item: ScreenshotFeatureItem) {
        iconView.image = UIImage(systemName: item.symbolName)
        iconView.tintColor = item.color
        iconView.backgroundColor = item.color.withAlphaComponent(0.12)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
    }

    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none

        cardView.applyCardStyle(cornerRadius: 18)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        iconView.contentMode = .center
        iconView.layer.cornerRadius = 17
        iconView.layer.cornerCurve = .continuous
        iconView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = DemoPalette.text
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = DemoPalette.secondaryText
        subtitleLabel.numberOfLines = 2

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 5

        let stack = UIStackView(arrangedSubviews: [iconView, textStack])
        stack.alignment = .center
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(stack)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
            iconView.widthAnchor.constraint(equalToConstant: 44),
            iconView.heightAnchor.constraint(equalToConstant: 44),
            stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 15),
            stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -15)
        ])
    }
}

private final class ScreenshotCodeCell: UITableViewCell {
    static let reuseIdentifier = "ScreenshotCodeCell"

    private let cardView = UIView()
    private let codeLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(code: String, color: UIColor) {
        cardView.backgroundColor = color.withAlphaComponent(0.11)
        codeLabel.text = code
    }

    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none

        cardView.layer.cornerRadius = 18
        cardView.layer.cornerCurve = .continuous
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        codeLabel.font = .monospacedSystemFont(ofSize: 13, weight: .semibold)
        codeLabel.textColor = DemoPalette.text
        codeLabel.numberOfLines = 0
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(codeLabel)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
            codeLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            codeLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            codeLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            codeLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
    }
}

private final class ScreenshotPathGridViewController: UIViewController {
    private var effectViews: [TTGRefreshPathEffectPreviewView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DemoPalette.background
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for effectView in effectViews {
            effectView.update(progress: 1)
            effectView.startAnimating()
        }
    }

    private func setupView() {
        let badgeLabel = DemoPaddedLabel(horizontalPadding: 12)
        badgeLabel.text = "POSTER · 20 PATH EFFECTS"
        badgeLabel.font = .systemFont(ofSize: 12, weight: .heavy)
        badgeLabel.textColor = DemoPalette.accent
        badgeLabel.backgroundColor = DemoPalette.accent.withAlphaComponent(0.12)
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 12
        badgeLabel.layer.masksToBounds = true

        let titleLabel = UILabel()
        titleLabel.text = "Built-in Path Gallery"
        titleLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        titleLabel.textColor = DemoPalette.text

        let subtitleLabel = UILabel()
        subtitleLabel.text = "Twenty bundled styles are ready for refresh, pull load more, and infinite load templates."
        subtitleLabel.font = .preferredFont(forTextStyle: .caption1)
        subtitleLabel.textColor = DemoPalette.secondaryText
        subtitleLabel.numberOfLines = 2

        let headerStack = UIStackView(arrangedSubviews: [badgeLabel, titleLabel, subtitleLabel])
        headerStack.axis = .vertical
        headerStack.alignment = .leading
        headerStack.spacing = 7

        let gridStack = UIStackView()
        gridStack.axis = .vertical
        gridStack.spacing = 7

        let styles = TTGRefreshPathEffectStyle.allCases
        for rowIndex in stride(from: 0, to: styles.count, by: 3) {
            let row = UIStackView()
            row.axis = .horizontal
            row.distribution = .fillEqually
            row.spacing = 8

            for columnOffset in 0..<3 {
                let index = rowIndex + columnOffset
                if styles.indices.contains(index) {
                    row.addArrangedSubview(makeEffectCard(style: styles[index]))
                } else {
                    row.addArrangedSubview(UIView())
                }
            }
            gridStack.addArrangedSubview(row)
        }

        let stack = UIStackView(arrangedSubviews: [headerStack, gridStack])
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            badgeLabel.heightAnchor.constraint(equalToConstant: 26),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }

    private func makeEffectCard(style: TTGRefreshPathEffectStyle) -> UIView {
        let template = TTGRefreshPathEffectTemplate(style: style, animationSpeed: 0.85)
        let effectView = TTGRefreshPathEffectPreviewView(template: template, role: .refresh, size: 46)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        effectViews.append(effectView)

        let titleLabel = UILabel()
        titleLabel.text = style.title
        titleLabel.font = .systemFont(ofSize: 10.5, weight: .heavy)
        titleLabel.textColor = DemoPalette.text
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.76

        let card = UIView()
        card.backgroundColor = DemoPalette.elevatedBackground
        card.layer.cornerRadius = 15
        card.layer.cornerCurve = .continuous
        card.clipsToBounds = true
        card.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(effectView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 78),
            effectView.topAnchor.constraint(equalTo: card.topAnchor, constant: 8),
            effectView.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            effectView.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            effectView.heightAnchor.constraint(equalToConstant: 46),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -5),
            titleLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -6)
        ])

        return card
    }
}
