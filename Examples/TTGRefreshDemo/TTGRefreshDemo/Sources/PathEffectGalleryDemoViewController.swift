import TTGRefresh
import UIKit

final class PathEffectGalleryDemoViewController: UITableViewController {
    private let styles = TTGRefreshPathEffectStyle.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Path Effects"
        navigationItem.title = "Path Effects"
        navigationItem.largeTitleDisplayMode = .never
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureTableView() {
        tableView.backgroundColor = DemoPalette.background
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 14, left: 0, bottom: 26, right: 0)
        tableView.tableHeaderView = DemoHeaderView.tableHeader(
            badge: "20 PATH SETS",
            title: "Effect Gallery",
            subtitle: "Each row opens a paired refresh and load-more path animation designed as a candidate built-in style.",
            color: DemoPalette.violet
        )
        tableView.register(PathEffectStyleCell.self, forCellReuseIdentifier: PathEffectStyleCell.reuseIdentifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        styles.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PathEffectStyleCell.reuseIdentifier, for: indexPath) as! PathEffectStyleCell
        cell.configure(index: indexPath.row, style: styles[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(PathEffectDetailDemoViewController(style: styles[indexPath.row]), animated: true)
    }
}

private final class PathEffectDetailDemoViewController: UITableViewController {
    private let style: TTGRefreshPathEffectStyle
    private var items: [FeedItem]
    private var page = 1

    init(style: TTGRefreshPathEffectStyle) {
        self.style = style
        self.items = DemoContentFactory.feedItems(page: 20 + TTGRefreshPathEffectStyle.allCases.firstIndex(of: style)!, count: 8)
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = style.title
        navigationItem.title = style.title
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "arrow.down.to.line.compact"), style: .plain, target: self, action: #selector(triggerLoadMore)),
            UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(triggerRefresh))
        ]
        configureTableView()
        configureRefresh()
    }

    private func configureTableView() {
        tableView.backgroundColor = DemoPalette.background
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 14, left: 0, bottom: 26, right: 0)
        tableView.tableHeaderView = DemoHeaderView.tableHeader(
            badge: style.badge,
            title: style.title,
            subtitle: style.subtitle,
            color: style.colors[0]
        )
        tableView.register(PathEffectDetailCell.self, forCellReuseIdentifier: PathEffectDetailCell.reuseIdentifier)
    }

    private func configureRefresh() {
        var configuration = TTGRefreshConfiguration.default
        configuration.hapticsEnabled = true
        configuration.minimumRefreshingDuration = 0.55

        tableView.ttg.addHeaderRefresh(
            contentView: TTGRefreshPathEffectHeaderView(style: style),
            configuration: configuration
        ) { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: 1_700_000_000)
            self.page = 1
            let seed = 20 + (TTGRefreshPathEffectStyle.allCases.firstIndex(of: self.style) ?? 0)
            self.items = DemoContentFactory.feedItems(page: seed, count: 8)
            self.tableView.reloadData()
            self.tableView.ttg.resetFooterNoMoreData()
        }

        tableView.ttg.addFooterRefresh(
            contentView: TTGRefreshPathEffectFooterView(style: style),
            configuration: configuration
        ) { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: 1_450_000_000)
            self.page += 1
            let seed = 40 + self.page + (TTGRefreshPathEffectStyle.allCases.firstIndex(of: self.style) ?? 0)
            self.items.append(contentsOf: DemoContentFactory.feedItems(page: seed, count: 4))
            self.tableView.reloadData()

            if self.page >= 3 {
                self.tableView.ttg.endFooterRefreshingWithNoMoreData()
            }
        }
    }

    @objc private func triggerRefresh() {
        tableView.ttg.triggerRefresh()
    }

    @objc private func triggerLoadMore() {
        tableView.ttg.triggerLoadMore()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PathEffectDetailCell.reuseIdentifier, for: indexPath) as! PathEffectDetailCell
        cell.configure(index: indexPath.row, item: items[indexPath.row], style: style)
        return cell
    }
}

private final class PathEffectStyleCell: UITableViewCell {
    static let reuseIdentifier = "PathEffectStyleCell"

    private let cardView = UIView()
    private let iconView = UIImageView()
    private let badgeLabel = DemoPaddedLabel(horizontalPadding: 10)
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let chevronView = UIImageView(image: UIImage(systemName: "chevron.right"))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(index: Int, style: TTGRefreshPathEffectStyle) {
        iconView.image = UIImage(systemName: style.symbolName)
        iconView.tintColor = style.colors[0]
        iconView.backgroundColor = style.colors[0].withAlphaComponent(0.12)
        badgeLabel.text = "\(String(format: "%02d", index + 1)) · \(style.badge)"
        badgeLabel.textColor = style.colors[0]
        badgeLabel.backgroundColor = style.colors[0].withAlphaComponent(0.12)
        titleLabel.text = style.title
        subtitleLabel.text = style.subtitle
        accessibilityLabel = "\(style.title), \(style.subtitle)"
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

        badgeLabel.font = .systemFont(ofSize: 11, weight: .heavy)
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 9
        badgeLabel.layer.masksToBounds = true

        titleLabel.font = .systemFont(ofSize: 17, weight: .heavy)
        titleLabel.textColor = DemoPalette.text

        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = DemoPalette.secondaryText
        subtitleLabel.numberOfLines = 2

        chevronView.tintColor = .tertiaryLabel
        chevronView.setContentCompressionResistancePriority(.required, for: .horizontal)

        let textStack = UIStackView(arrangedSubviews: [badgeLabel, titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.spacing = 6

        let row = UIStackView(arrangedSubviews: [iconView, textStack, chevronView])
        row.alignment = .center
        row.spacing = 14
        row.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(row)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            iconView.widthAnchor.constraint(equalToConstant: 46),
            iconView.heightAnchor.constraint(equalToConstant: 46),
            badgeLabel.heightAnchor.constraint(equalToConstant: 22),
            row.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            row.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            row.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            row.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
    }
}

private final class PathEffectDetailCell: UITableViewCell {
    static let reuseIdentifier = "PathEffectDetailCell"

    private let cardView = UIView()
    private let markerView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(index: Int, item: FeedItem, style: TTGRefreshPathEffectStyle) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        markerView.backgroundColor = style.colors[index % style.colors.count]
    }

    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none

        cardView.applyCardStyle(cornerRadius: 18)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        markerView.layer.cornerRadius = 4
        markerView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = DemoPalette.text

        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = DemoPalette.secondaryText
        subtitleLabel.numberOfLines = 2

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 6

        let row = UIStackView(arrangedSubviews: [markerView, textStack])
        row.alignment = .top
        row.spacing = 12
        row.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(row)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
            markerView.widthAnchor.constraint(equalToConstant: 8),
            markerView.heightAnchor.constraint(equalToConstant: 44),
            row.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            row.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            row.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            row.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
    }
}
