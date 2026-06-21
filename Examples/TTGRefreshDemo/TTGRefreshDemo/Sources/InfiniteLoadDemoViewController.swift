import TTGRefresh
import UIKit

final class InfiniteLoadDemoViewController: UICollectionViewController {
    private var items = DemoContentFactory.galleryItems(page: 1, count: 12)
    private var page = 1
    private let preloadOffset: CGFloat = 260

    init() {
        super.init(collectionViewLayout: Self.makeLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Infinite"
        navigationItem.title = "Infinite Load"
        navigationItem.largeTitleDisplayMode = .never
        configureCollectionView()
        configureRefresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureCollectionView() {
        collectionView.backgroundColor = DemoPalette.background
        collectionView.alwaysBounceHorizontal = false
        collectionView.isDirectionalLockEnabled = true
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 28, right: 0)
        collectionView.register(GalleryCell.self, forCellWithReuseIdentifier: GalleryCell.reuseIdentifier)
        collectionView.register(
            DemoCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DemoCollectionHeaderView.reuseIdentifier
        )
    }

    private func configureRefresh() {
        var configuration = TTGRefreshConfiguration.default
        configuration.footerVisibilityMode = .always
        configuration.minimumRefreshingDuration = 0.35

        collectionView.ttg.addHeaderRefresh(configuration: configuration) { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: 1_700_000_000)
            self.page = 1
            self.items = DemoContentFactory.galleryItems(page: self.page, count: 12)
            self.collectionView.reloadData()
            self.collectionView.ttg.resetFooterNoMoreData()
        }

        collectionView.ttg.addInfiniteLoad(preloadOffset: preloadOffset, configuration: configuration) { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: 1_450_000_000)
            self.page += 1
            self.items.append(contentsOf: DemoContentFactory.galleryItems(page: self.page, count: 6))
            self.collectionView.reloadData()

            if self.page >= 4 {
                self.collectionView.ttg.endFooterRefreshingWithNoMoreData()
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.reuseIdentifier, for: indexPath) as! GalleryCell
        cell.configure(with: items[indexPath.item])
        return cell
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: DemoCollectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as! DemoCollectionHeaderView
        headerView.configure(
            badge: "INFINITE LOAD",
            title: "Preload before the end",
            subtitle: "This demo starts loading \(Int(preloadOffset)) pt before the bottom, so pagination feels continuous.",
            color: DemoPalette.mint
        )
        return headerView
    }

    private static func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .absolute(150)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(150)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(154)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        return UICollectionViewCompositionalLayout(section: section)
    }
}

private final class GalleryCell: UICollectionViewCell {
    static let reuseIdentifier = "GalleryCell"

    private let symbolView = UIImageView()
    private let titleLabel = UILabel()
    private let metricLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: GalleryItem) {
        symbolView.image = UIImage(systemName: item.symbolName)
        symbolView.tintColor = item.tintColor
        titleLabel.text = item.title
        metricLabel.text = item.metric
        backgroundColor = item.tintColor.withAlphaComponent(0.10)
    }

    private func setupView() {
        layer.cornerRadius = 22
        layer.cornerCurve = .continuous
        layer.borderWidth = 1
        layer.borderColor = DemoPalette.separator.cgColor

        symbolView.contentMode = .scaleAspectFit
        symbolView.translatesAutoresizingMaskIntoConstraints = false

        metricLabel.font = .systemFont(ofSize: 25, weight: .heavy)
        metricLabel.textColor = DemoPalette.text

        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
        titleLabel.textColor = DemoPalette.secondaryText
        titleLabel.numberOfLines = 2

        let stackView = UIStackView(arrangedSubviews: [symbolView, metricLabel, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            symbolView.widthAnchor.constraint(equalToConstant: 28),
            symbolView.heightAnchor.constraint(equalToConstant: 28),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -18)
        ])
    }
}
