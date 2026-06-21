import TTGRefresh
import UIKit

final class CustomRefreshDemoViewController: UITableViewController {
    private var items = DemoContentFactory.feedItems(page: 7, count: 7)
    private var loadCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Custom"
        navigationItem.title = "Custom UI"
        navigationItem.largeTitleDisplayMode = .never
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
        tableView.contentInset = UIEdgeInsets(top: 14, left: 0, bottom: 26, right: 0)
        tableView.tableHeaderView = DemoHeaderView.tableHeader(
            badge: "CUSTOM VIEWS",
            title: "Animated Custom UI",
            subtitle: "Conic gradients, path drawing, and dot animations are plain UIView protocol implementations driven by state and progress callbacks.",
            color: DemoPalette.violet
        )
        tableView.register(CustomDemoCell.self, forCellReuseIdentifier: CustomDemoCell.reuseIdentifier)
    }

    private func configureRefresh() {
        var configuration = TTGRefreshConfiguration.default
        configuration.hapticsEnabled = true
        configuration.minimumRefreshingDuration = 0.45

        tableView.ttg.addPathEffectHeaderRefresh(style: .auroraWave, configuration: configuration) { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: 1_700_000_000)
            self.loadCount = 0
            self.items = DemoContentFactory.feedItems(page: 7, count: 7)
            self.tableView.reloadData()
            self.tableView.ttg.resetFooterNoMoreData()
        }

        tableView.ttg.addPathEffectFooterRefresh(style: .auroraWave, configuration: configuration) { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: 1_450_000_000)
            self.loadCount += 1
            self.items.append(contentsOf: DemoContentFactory.feedItems(page: 9 + self.loadCount, count: 3))
            self.tableView.reloadData()

            if self.loadCount >= 2 {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomDemoCell.reuseIdentifier, for: indexPath) as! CustomDemoCell
        cell.configure(index: indexPath.row, item: items[indexPath.row])
        return cell
    }
}

private final class CustomDemoCell: UITableViewCell {
    static let reuseIdentifier = "CustomDemoCell"

    private let cardView = UIView()
    private let indexLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(index: Int, item: FeedItem) {
        indexLabel.text = String(format: "%02d", index + 1)
        indexLabel.textColor = item.tintColor
        indexLabel.backgroundColor = item.tintColor.withAlphaComponent(0.12)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
    }

    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none

        cardView.applyCardStyle(cornerRadius: 20)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        indexLabel.font = .systemFont(ofSize: 13, weight: .heavy)
        indexLabel.textAlignment = .center
        indexLabel.layer.cornerRadius = 14
        indexLabel.layer.masksToBounds = true
        indexLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = DemoPalette.text

        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = DemoPalette.secondaryText
        subtitleLabel.numberOfLines = 2

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 7

        let stack = UIStackView(arrangedSubviews: [indexLabel, textStack])
        stack.alignment = .top
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(stack)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),

            indexLabel.widthAnchor.constraint(equalToConstant: 42),
            indexLabel.heightAnchor.constraint(equalToConstant: 28),

            stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 18),
            stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 18),
            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18),
            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -18)
        ])
    }
}
