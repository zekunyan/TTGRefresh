import TTGRefresh
import UIKit

final class GradientRefreshHeaderView: UIView, TTGRefreshHeaderContentView {
    var preferredHeight: CGFloat { 86 }
    var triggerHeight: CGFloat { preferredHeight }

    private let iconContainer = UIView()
    private let iconView = UIImageView(image: UIImage(systemName: "arrow.down.circle.fill"))
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .bar)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        iconContainer.layer.cornerRadius = iconContainer.bounds.height / 2
    }

    func refreshHeaderDidChange(state: TTGRefreshHeaderState) {
        switch state {
        case .idle:
            titleLabel.text = "Pull for a fresh snapshot"
            subtitleLabel.text = "Custom header view"
            iconView.image = UIImage(systemName: "arrow.down.circle.fill")
            iconView.tintColor = DemoPalette.accent
        case .pulling:
            titleLabel.text = "Keep pulling"
            subtitleLabel.text = "Progress-driven UI"
            iconView.image = UIImage(systemName: "arrow.down.circle.fill")
            iconView.tintColor = DemoPalette.accent
        case .willRefresh:
            titleLabel.text = "Release to refresh"
            subtitleLabel.text = "Threshold reached"
            iconView.image = UIImage(systemName: "hand.tap.fill")
            iconView.tintColor = DemoPalette.mint
        case .refreshing:
            titleLabel.text = "Refreshing content"
            subtitleLabel.text = "Async action is running"
            iconView.image = UIImage(systemName: "sparkles")
            iconView.tintColor = DemoPalette.violet
        case .ending:
            titleLabel.text = "Updated"
            subtitleLabel.text = "Inset will restore smoothly"
            iconView.image = UIImage(systemName: "checkmark.circle.fill")
            iconView.tintColor = DemoPalette.mint
        }
    }

    func refreshHeaderDidUpdate(progress: CGFloat) {
        progressView.setProgress(Float(progress), animated: true)
        iconContainer.transform = CGAffineTransform(rotationAngle: progress * .pi)
    }

    private func setupView() {
        iconContainer.backgroundColor = DemoPalette.accent.withAlphaComponent(0.12)
        iconContainer.translatesAutoresizingMaskIntoConstraints = false

        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.addSubview(iconView)

        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = DemoPalette.text

        subtitleLabel.font = .preferredFont(forTextStyle: .caption1)
        subtitleLabel.textColor = DemoPalette.secondaryText

        progressView.progressTintColor = DemoPalette.accent
        progressView.trackTintColor = DemoPalette.separator
        progressView.layer.cornerRadius = 2
        progressView.layer.masksToBounds = true

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, progressView])
        textStack.axis = .vertical
        textStack.spacing = 5

        let stackView = UIStackView(arrangedSubviews: [iconContainer, textStack])
        stackView.alignment = .center
        stackView.spacing = 14
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            iconContainer.widthAnchor.constraint(equalToConstant: 48),
            iconContainer.heightAnchor.constraint(equalToConstant: 48),

            iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 26),
            iconView.heightAnchor.constraint(equalToConstant: 26),

            progressView.heightAnchor.constraint(equalToConstant: 4),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 28),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -28)
        ])
    }
}

final class CapsuleRefreshFooterView: UIView, TTGRefreshFooterContentView {
    var preferredHeight: CGFloat { 64 }
    var triggerHeight: CGFloat { 56 }

    private let capsuleView = UIView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func refreshFooterDidChange(state: TTGRefreshFooterState) {
        switch state {
        case .idle, .pulling:
            titleLabel.text = "More examples"
            activityIndicator.stopAnimating()
            capsuleView.backgroundColor = DemoPalette.accent.withAlphaComponent(0.12)
        case .willLoad:
            titleLabel.text = "Release to append"
            activityIndicator.stopAnimating()
            capsuleView.backgroundColor = DemoPalette.mint.withAlphaComponent(0.14)
        case .loading:
            titleLabel.text = "Adding rows"
            activityIndicator.startAnimating()
            capsuleView.backgroundColor = DemoPalette.violet.withAlphaComponent(0.14)
        case .noMoreData:
            titleLabel.text = "End of the demo"
            activityIndicator.stopAnimating()
            capsuleView.backgroundColor = DemoPalette.separator
        case .hidden:
            titleLabel.text = nil
            activityIndicator.stopAnimating()
        }
    }

    func refreshFooterDidUpdate(progress: CGFloat) {
        capsuleView.transform = CGAffineTransform(scaleX: 0.92 + progress * 0.08, y: 0.92 + progress * 0.08)
    }

    private func setupView() {
        capsuleView.layer.cornerRadius = 22
        capsuleView.layer.cornerCurve = .continuous
        capsuleView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(capsuleView)

        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        titleLabel.textColor = DemoPalette.text

        let stackView = UIStackView(arrangedSubviews: [activityIndicator, titleLabel])
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        capsuleView.addSubview(stackView)

        NSLayoutConstraint.activate([
            capsuleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            capsuleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            capsuleView.heightAnchor.constraint(equalToConstant: 44),
            capsuleView.widthAnchor.constraint(greaterThanOrEqualToConstant: 176),

            stackView.centerXAnchor.constraint(equalTo: capsuleView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: capsuleView.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: capsuleView.leadingAnchor, constant: 18),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: capsuleView.trailingAnchor, constant: -18)
        ])
    }
}

final class AuroraRefreshHeaderView: UIView, TTGRefreshHeaderContentView {
    var preferredHeight: CGFloat { 108 }
    var triggerHeight: CGFloat { preferredHeight }

    private let orbView = UIView()
    private let gradientLayer = CAGradientLayer()
    private let pathLayer = CAShapeLayer()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        orbView.layer.cornerRadius = orbView.bounds.width / 2
        gradientLayer.frame = orbView.bounds
        gradientLayer.cornerRadius = orbView.bounds.width / 2
        pathLayer.frame = orbView.bounds
        pathLayer.path = makeWavePath(in: orbView.bounds.insetBy(dx: 12, dy: 14)).cgPath
    }

    func refreshHeaderDidChange(state: TTGRefreshHeaderState) {
        switch state {
        case .idle:
            titleLabel.text = "Pull the aurora"
            subtitleLabel.text = "Overlay header with custom path drawing"
            stopAnimating()
        case .pulling:
            titleLabel.text = "Drawing path"
            subtitleLabel.text = "Progress drives stroke and scale"
            stopAnimating()
        case .willRefresh:
            titleLabel.text = "Release to refresh"
            subtitleLabel.text = "Threshold reached"
            stopAnimating()
        case .refreshing:
            titleLabel.text = "Streaming update"
            subtitleLabel.text = "Conic gradient and path animations"
            startAnimating()
        case .ending:
            titleLabel.text = "Refresh complete"
            subtitleLabel.text = "State callback switched the UI"
            stopAnimating()
        }
    }

    func refreshHeaderDidUpdate(progress: CGFloat) {
        let clampedProgress = min(max(progress, 0), 1)
        pathLayer.strokeEnd = clampedProgress
        orbView.transform = CGAffineTransform(scaleX: 0.84 + clampedProgress * 0.16, y: 0.84 + clampedProgress * 0.16)
        orbView.alpha = 0.36 + clampedProgress * 0.64
    }

    private func setupView() {
        orbView.translatesAutoresizingMaskIntoConstraints = false
        orbView.backgroundColor = DemoPalette.elevatedBackground

        gradientLayer.type = .conic
        gradientLayer.colors = [
            DemoPalette.accent.cgColor,
            DemoPalette.mint.cgColor,
            DemoPalette.violet.cgColor,
            DemoPalette.coral.cgColor,
            DemoPalette.accent.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        orbView.layer.addSublayer(gradientLayer)

        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.strokeColor = UIColor.white.cgColor
        pathLayer.lineWidth = 4
        pathLayer.lineCap = .round
        pathLayer.lineJoin = .round
        pathLayer.strokeEnd = 0
        gradientLayer.mask = pathLayer

        titleLabel.font = .systemFont(ofSize: 17, weight: .heavy)
        titleLabel.textColor = DemoPalette.text
        titleLabel.numberOfLines = 1

        subtitleLabel.font = .preferredFont(forTextStyle: .caption1)
        subtitleLabel.textColor = DemoPalette.secondaryText
        subtitleLabel.numberOfLines = 2

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 5
        textStack.translatesAutoresizingMaskIntoConstraints = false

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.addSubview(orbView)
        contentView.addSubview(textStack)

        NSLayoutConstraint.activate([
            orbView.widthAnchor.constraint(equalToConstant: 64),
            orbView.heightAnchor.constraint(equalToConstant: 64),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 72),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            orbView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            orbView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textStack.leadingAnchor.constraint(equalTo: orbView.trailingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        refreshHeaderDidChange(state: .idle)
    }

    private func makeWavePath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addCurve(
            to: CGPoint(x: rect.midX, y: rect.midY),
            controlPoint1: CGPoint(x: rect.minX + rect.width * 0.22, y: rect.minY),
            controlPoint2: CGPoint(x: rect.minX + rect.width * 0.30, y: rect.maxY)
        )
        path.addCurve(
            to: CGPoint(x: rect.maxX, y: rect.midY),
            controlPoint1: CGPoint(x: rect.minX + rect.width * 0.70, y: rect.minY),
            controlPoint2: CGPoint(x: rect.minX + rect.width * 0.78, y: rect.maxY)
        )
        return path
    }

    private func startAnimating() {
        guard gradientLayer.animation(forKey: "ttg.rotate") == nil else { return }

        pathLayer.strokeEnd = 1

        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 1.2
        rotation.repeatCount = .infinity
        rotation.timingFunction = CAMediaTimingFunction(name: .linear)
        gradientLayer.add(rotation, forKey: "ttg.rotate")

        let pulse = CABasicAnimation(keyPath: "lineWidth")
        pulse.fromValue = 3
        pulse.toValue = 7
        pulse.duration = 0.52
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pathLayer.add(pulse, forKey: "ttg.pulse")
    }

    private func stopAnimating() {
        gradientLayer.removeAnimation(forKey: "ttg.rotate")
        pathLayer.removeAnimation(forKey: "ttg.pulse")
    }
}

final class OrbitLoadMoreFooterView: UIView, TTGRefreshFooterContentView {
    var preferredHeight: CGFloat { 72 }
    var triggerHeight: CGFloat { 58 }

    private let capsuleView = UIView()
    private let titleLabel = UILabel()
    private let replicatorLayer = CAReplicatorLayer()
    private let dotLayer = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        capsuleView.layer.cornerRadius = capsuleView.bounds.height / 2
        replicatorLayer.frame = CGRect(x: 18, y: (capsuleView.bounds.height - 18) / 2, width: 58, height: 18)
        dotLayer.frame = CGRect(x: 0, y: 4, width: 10, height: 10)
        dotLayer.cornerRadius = 5
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(18, 0, 0)
    }

    func refreshFooterDidChange(state: TTGRefreshFooterState) {
        switch state {
        case .idle, .pulling:
            titleLabel.text = "Tap or pull for more"
            capsuleView.backgroundColor = DemoPalette.mint.withAlphaComponent(0.12)
            stopAnimating()
        case .willLoad:
            titleLabel.text = "Release to load"
            capsuleView.backgroundColor = DemoPalette.mint.withAlphaComponent(0.18)
            stopAnimating()
        case .loading:
            titleLabel.text = "Loading next page"
            capsuleView.backgroundColor = DemoPalette.violet.withAlphaComponent(0.14)
            startAnimating()
        case .noMoreData:
            titleLabel.text = "No more pages"
            capsuleView.backgroundColor = DemoPalette.separator
            stopAnimating()
        case .hidden:
            titleLabel.text = nil
            stopAnimating()
        }
    }

    func refreshFooterDidUpdate(progress: CGFloat) {
        let clampedProgress = min(max(progress, 0), 1)
        capsuleView.transform = CGAffineTransform(scaleX: 0.9 + clampedProgress * 0.1, y: 0.9 + clampedProgress * 0.1)
    }

    private func setupView() {
        capsuleView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(capsuleView)

        replicatorLayer.instanceCount = 3
        replicatorLayer.instanceDelay = 0.12
        dotLayer.backgroundColor = DemoPalette.violet.cgColor
        replicatorLayer.addSublayer(dotLayer)
        capsuleView.layer.addSublayer(replicatorLayer)

        titleLabel.font = .systemFont(ofSize: 14, weight: .heavy)
        titleLabel.textColor = DemoPalette.text
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        capsuleView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            capsuleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            capsuleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            capsuleView.heightAnchor.constraint(equalToConstant: 48),
            capsuleView.widthAnchor.constraint(greaterThanOrEqualToConstant: 218),
            titleLabel.centerYAnchor.constraint(equalTo: capsuleView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: capsuleView.leadingAnchor, constant: 86),
            titleLabel.trailingAnchor.constraint(equalTo: capsuleView.trailingAnchor, constant: -22)
        ])

        refreshFooterDidChange(state: .idle)
    }

    private func startAnimating() {
        guard dotLayer.animation(forKey: "ttg.scale") == nil else { return }

        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 0.45
        scale.toValue = 1.15
        scale.duration = 0.42
        scale.autoreverses = true
        scale.repeatCount = .infinity
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        dotLayer.add(scale, forKey: "ttg.scale")
    }

    private func stopAnimating() {
        dotLayer.removeAnimation(forKey: "ttg.scale")
    }
}
