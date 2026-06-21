import TTGRefresh
import UIKit

final class FeedTableDemoViewController: UITableViewController {
    private var items = DemoContentFactory.feedItems(page: 1, count: 10)
    private var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Feed"
        navigationItem.title = "Feed Refresh"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = DemoPalette.background
        configureTableView()
        configureRefresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureTableView() {
        tableView.backgroundColor = DemoPalette.background
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 24, right: 0)
        tableView.tableHeaderView = DemoHeaderView.tableHeader(
            badge: "DEFAULT API",
            title: "Feed Refresh",
            subtitle: "Pull down to reload, pull up to append pages, then show no-more-data.",
            color: DemoPalette.accent
        )
        tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.reuseIdentifier)
    }

    private func configureRefresh() {
        var configuration = TTGRefreshConfiguration.default
        configuration.minimumRefreshingDuration = 0.4
        configuration.automaticallyChangeAlpha = true

        tableView.ttg.addHeaderRefresh(configuration: configuration) { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: 1_700_000_000)
            self.page = 1
            self.items = DemoContentFactory.feedItems(page: self.page, count: 10)
            self.tableView.reloadData()
            self.tableView.ttg.resetFooterNoMoreData()
        }

        tableView.ttg.addFooterRefresh(configuration: configuration) { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: 1_450_000_000)
            self.page += 1
            self.items.append(contentsOf: DemoContentFactory.feedItems(page: self.page, count: 5))
            self.tableView.reloadData()

            if self.page >= 3 {
                self.tableView.ttg.endFooterRefreshingWithNoMoreData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.reuseIdentifier, for: indexPath) as! FeedCell
        cell.configure(with: items[indexPath.row])
        return cell
    }
}

private final class FeedCell: UITableViewCell {
    static let reuseIdentifier = "FeedCell"

    private let cardView = UIView()
    private let symbolView = UIImageView()
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
        symbolView.tintColor = item.tintColor
        symbolView.backgroundColor = item.tintColor.withAlphaComponent(0.12)
    }

    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none

        cardView.applyCardStyle()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        symbolView.image = UIImage(systemName: "arrow.triangle.2.circlepath")
        symbolView.contentMode = .center
        symbolView.layer.cornerRadius = 18
        symbolView.layer.cornerCurve = .continuous
        symbolView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = DemoPalette.text
        titleLabel.numberOfLines = 1

        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = DemoPalette.secondaryText
        subtitleLabel.numberOfLines = 2

        tagLabel.font = .systemFont(ofSize: 12, weight: .bold)
        tagLabel.textAlignment = .center
        tagLabel.layer.cornerRadius = 10
        tagLabel.layer.cornerCurve = .continuous
        tagLabel.layer.masksToBounds = true
        tagLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 6

        let contentStack = UIStackView(arrangedSubviews: [symbolView, textStack, tagLabel])
        contentStack.alignment = .center
        contentStack.spacing = 14
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),

            symbolView.widthAnchor.constraint(equalToConstant: 44),
            symbolView.heightAnchor.constraint(equalToConstant: 44),

            tagLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 58),
            tagLabel.heightAnchor.constraint(equalToConstant: 24),

            contentStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
    }
}
