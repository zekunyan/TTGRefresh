import TTGRefresh
import UIKit

final class OverlayRefreshDemoViewController: UITableViewController {
    private var items = DemoContentFactory.feedItems(page: 12, count: 9)
    private var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Overlay"
        navigationItem.title = "Overlay Refresh"
        navigationItem.largeTitleDisplayMode = .never
        configureNavigationItems()
        configureTableView()
        configureRefresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureNavigationItems() {
        let refreshItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.clockwise"),
            style: .plain,
            target: self,
            action: #selector(triggerRefresh)
        )
        refreshItem.accessibilityLabel = "Trigger refresh"

        let loadItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.down.to.line.compact"),
            style: .plain,
            target: self,
            action: #selector(triggerLoadMore)
        )
        loadItem.accessibilityLabel = "Trigger load more"

        navigationItem.rightBarButtonItems = [loadItem, refreshItem]
    }

    private func configureTableView() {
        tableView.backgroundColor = DemoPalette.background
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 14, left: 0, bottom: 26, right: 0)
        tableView.tableHeaderView = DemoHeaderView.tableHeader(
            badge: "OVERLAY MODE",
            title: "Android-style pull",
            subtitle: "The list stays pinned while the refresh view slides into the visible top area. Toolbar buttons call the same refresh and load-more callbacks.",
            color: DemoPalette.coral
        )
        tableView.register(OverlayDemoCell.self, forCellReuseIdentifier: OverlayDemoCell.reuseIdentifier)
    }

    private func configureRefresh() {
        var configuration = TTGRefreshConfiguration.default
        configuration.headerPresentationMode = .overlay
        configuration.minimumRefreshingDuration = 0.55
        configuration.hapticsEnabled = true

        tableView.ttg.addHeaderRefresh(
            contentView: TTGRefreshDefaultHeaderView(preferredHeight: 60, triggerHeight: 32),
            configuration: configuration
        ) { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: 1_700_000_000)
            self.page = 1
            self.items = DemoContentFactory.feedItems(page: 12, count: 9)
            self.tableView.reloadData()
            self.tableView.ttg.resetFooterNoMoreData()
        }

        tableView.ttg.addFooterRefresh(
            contentView: TTGRefreshDefaultFooterView(preferredHeight: 54, triggerHeight: 44),
            configuration: configuration
        ) { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: 1_450_000_000)
            self.page += 1
            self.items.append(contentsOf: DemoContentFactory.feedItems(page: 12 + self.page, count: 4))
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
        let cell = tableView.dequeueReusableCell(withIdentifier: OverlayDemoCell.reuseIdentifier, for: indexPath) as! OverlayDemoCell
        cell.configure(index: indexPath.row, item: items[indexPath.row])
        return cell
    }
}

private final class OverlayDemoCell: UITableViewCell {
    static let reuseIdentifier = "OverlayDemoCell"

    private let cardView = UIView()
    private let accentView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let symbolView = UIImageView(image: UIImage(systemName: "waveform.path.ecg.rectangle"))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(index: Int, item: FeedItem) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        accentView.backgroundColor = item.tintColor
        symbolView.tintColor = item.tintColor
        symbolView.backgroundColor = item.tintColor.withAlphaComponent(0.12)
    }

    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none

        cardView.applyCardStyle(cornerRadius: 20)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        accentView.layer.cornerRadius = 3
        accentView.translatesAutoresizingMaskIntoConstraints = false

        symbolView.contentMode = .center
        symbolView.layer.cornerRadius = 18
        symbolView.layer.cornerCurve = .continuous
        symbolView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = DemoPalette.text

        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = DemoPalette.secondaryText
        subtitleLabel.numberOfLines = 2

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 6

        let row = UIStackView(arrangedSubviews: [accentView, symbolView, textStack])
        row.alignment = .center
        row.spacing = 14
        row.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(row)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
            accentView.widthAnchor.constraint(equalToConstant: 6),
            accentView.heightAnchor.constraint(equalToConstant: 46),
            symbolView.widthAnchor.constraint(equalToConstant: 44),
            symbolView.heightAnchor.constraint(equalToConstant: 44),
            row.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            row.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            row.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            row.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
    }
}
