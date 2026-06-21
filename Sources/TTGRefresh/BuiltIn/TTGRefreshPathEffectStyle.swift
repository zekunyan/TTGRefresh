import UIKit

public enum TTGRefreshPathEffectRole {
    case refresh
    case loadMore
}

private enum TTGRefreshPathEffectMotion {
    case aurora
    case circuit
    case ripple
    case bounce
    case fold
    case swim
    case radar
    case scan
    case tide
    case ignite
    case bloom
    case blink
    case dive
    case record
    case pixel
    case slither
    case rain
    case quantum
    case launch
}

public enum TTGRefreshPathEffectStyle: CaseIterable {
    case auroraLoop
    case pulseCircuit
    case zenRipple
    case neonCat
    case origamiBird
    case koiStream
    case retroRadar
    case cyberGrid
    case lunarTide
    case flameJet
    case lotusBloom
    case robotSmile
    case whaleDive
    case auroraWave
    case vinylSpin
    case pixelHeart
    case dragonCurve
    case rainGarden
    case quantumKnot
    case rocketOrbit

    public var title: String {
        switch self {
        case .auroraLoop: "Aurora Loop"
        case .pulseCircuit: "Pulse Circuit"
        case .zenRipple: "Zen Ripple"
        case .neonCat: "Neon Cat"
        case .origamiBird: "Origami Bird"
        case .koiStream: "Koi Stream"
        case .retroRadar: "Retro Radar"
        case .cyberGrid: "Cyber Grid"
        case .lunarTide: "Lunar Tide"
        case .flameJet: "Flame Jet"
        case .lotusBloom: "Lotus Bloom"
        case .robotSmile: "Robot Smile"
        case .whaleDive: "Whale Dive"
        case .auroraWave: "Aurora Wave"
        case .vinylSpin: "Vinyl Spin"
        case .pixelHeart: "Pixel Heart"
        case .dragonCurve: "Dragon Curve"
        case .rainGarden: "Rain Garden"
        case .quantumKnot: "Quantum Knot"
        case .rocketOrbit: "Rocket Orbit"
        }
    }

    public var subtitle: String {
        switch self {
        case .auroraLoop: "Soft natural light, circular flow, polished and calm."
        case .pulseCircuit: "Technical traces with electric pulse timing."
        case .zenRipple: "Minimal ripples for a quiet, fluid refresh."
        case .neonCat: "Playful animal silhouette with cyber neon energy."
        case .origamiBird: "Sharp folds and light wing motion."
        case .koiStream: "Organic swimming curve for gentle data flow."
        case .retroRadar: "Old terminal radar sweep with precise rhythm."
        case .cyberGrid: "Glitchy square path with high contrast motion."
        case .lunarTide: "Moon arc and tide line for slow smooth loading."
        case .flameJet: "Fast upward ignition for energetic feeds."
        case .lotusBloom: "Symmetric petals with calm blooming progress."
        case .robotSmile: "Friendly character-like path feedback."
        case .whaleDive: "Large soft curve with tiny water trail."
        case .auroraWave: "Single gradient wave with a soft breathing stroke."
        case .vinylSpin: "Retro record groove and spinning load more."
        case .pixelHeart: "Pixel-art warmth for social or creator apps."
        case .dragonCurve: "Bold serpentine path with strong personality."
        case .rainGarden: "Small drops, leaf arc, and natural rhythm."
        case .quantumKnot: "Abstract loop with premium technical feel."
        case .rocketOrbit: "Launch arc and orbit path for fast pagination."
        }
    }

    public var badge: String {
        switch self {
        case .auroraLoop, .zenRipple, .koiStream, .lunarTide, .lotusBloom, .rainGarden:
            "NATURE"
        case .pulseCircuit, .cyberGrid, .quantumKnot, .rocketOrbit:
            "TECH"
        case .retroRadar, .vinylSpin, .pixelHeart:
            "RETRO"
        case .neonCat, .origamiBird, .robotSmile, .whaleDive, .dragonCurve:
            "CHARM"
        case .flameJet:
            "MOTION"
        case .auroraWave:
            "AURORA"
        }
    }

    public var symbolName: String {
        switch self {
        case .auroraLoop: "sparkles"
        case .pulseCircuit: "cpu"
        case .zenRipple: "circle.dotted"
        case .neonCat: "cat"
        case .origamiBird: "paperplane"
        case .koiStream: "fish"
        case .retroRadar: "dot.radiowaves.left.and.right"
        case .cyberGrid: "square.grid.3x3"
        case .lunarTide: "moon.stars"
        case .flameJet: "flame"
        case .lotusBloom: "camera.macro"
        case .robotSmile: "face.smiling"
        case .whaleDive: "water.waves"
        case .auroraWave: "waveform.path.ecg"
        case .vinylSpin: "record.circle"
        case .pixelHeart: "heart"
        case .dragonCurve: "scribble.variable"
        case .rainGarden: "cloud.rain"
        case .quantumKnot: "atom"
        case .rocketOrbit: "paperplane.circle"
        }
    }

    public var colors: [UIColor] {
        switch self {
        case .auroraLoop: [UIColor(red: 0.16, green: 0.72, blue: 0.92, alpha: 1), UIColor(red: 0.40, green: 0.88, blue: 0.66, alpha: 1), UIColor(red: 0.58, green: 0.45, blue: 0.94, alpha: 1)]
        case .pulseCircuit: [UIColor(red: 0.00, green: 0.72, blue: 0.90, alpha: 1), UIColor(red: 0.07, green: 0.36, blue: 0.86, alpha: 1)]
        case .zenRipple: [UIColor(red: 0.20, green: 0.70, blue: 0.58, alpha: 1), UIColor(red: 0.58, green: 0.76, blue: 0.70, alpha: 1)]
        case .neonCat: [UIColor(red: 1.00, green: 0.22, blue: 0.58, alpha: 1), UIColor(red: 0.48, green: 0.22, blue: 0.92, alpha: 1)]
        case .origamiBird: [UIColor(red: 0.24, green: 0.34, blue: 0.90, alpha: 1), UIColor(red: 0.32, green: 0.74, blue: 0.90, alpha: 1)]
        case .koiStream: [UIColor(red: 0.94, green: 0.32, blue: 0.25, alpha: 1), UIColor(red: 0.96, green: 0.62, blue: 0.24, alpha: 1)]
        case .retroRadar: [UIColor(red: 0.24, green: 0.86, blue: 0.35, alpha: 1), UIColor(red: 0.80, green: 0.92, blue: 0.32, alpha: 1)]
        case .cyberGrid: [UIColor(red: 0.74, green: 0.16, blue: 0.92, alpha: 1), UIColor(red: 0.04, green: 0.82, blue: 0.92, alpha: 1)]
        case .lunarTide: [UIColor(red: 0.30, green: 0.48, blue: 0.86, alpha: 1), UIColor(red: 0.62, green: 0.70, blue: 0.84, alpha: 1)]
        case .flameJet: [UIColor(red: 0.96, green: 0.22, blue: 0.16, alpha: 1), UIColor(red: 1.00, green: 0.64, blue: 0.18, alpha: 1)]
        case .lotusBloom: [UIColor(red: 0.86, green: 0.28, blue: 0.64, alpha: 1), UIColor(red: 0.58, green: 0.40, blue: 0.88, alpha: 1)]
        case .robotSmile: [UIColor(red: 0.06, green: 0.66, blue: 0.82, alpha: 1), UIColor(red: 0.24, green: 0.44, blue: 0.66, alpha: 1)]
        case .whaleDive: [UIColor(red: 0.10, green: 0.46, blue: 0.82, alpha: 1), UIColor(red: 0.08, green: 0.70, blue: 0.78, alpha: 1)]
        case .auroraWave: [UIColor(red: 0.08, green: 0.56, blue: 0.94, alpha: 1), UIColor(red: 0.02, green: 0.76, blue: 0.62, alpha: 1), UIColor(red: 0.56, green: 0.42, blue: 0.92, alpha: 1)]
        case .vinylSpin: [UIColor(red: 0.42, green: 0.42, blue: 0.48, alpha: 1), UIColor(red: 0.92, green: 0.30, blue: 0.56, alpha: 1)]
        case .pixelHeart: [UIColor(red: 0.92, green: 0.18, blue: 0.30, alpha: 1), UIColor(red: 0.96, green: 0.42, blue: 0.62, alpha: 1)]
        case .dragonCurve: [UIColor(red: 0.90, green: 0.18, blue: 0.16, alpha: 1), UIColor(red: 0.88, green: 0.48, blue: 0.16, alpha: 1)]
        case .rainGarden: [UIColor(red: 0.08, green: 0.66, blue: 0.56, alpha: 1), UIColor(red: 0.28, green: 0.58, blue: 0.84, alpha: 1)]
        case .quantumKnot: [UIColor(red: 0.08, green: 0.76, blue: 0.86, alpha: 1), UIColor(red: 0.58, green: 0.34, blue: 0.92, alpha: 1)]
        case .rocketOrbit: [UIColor(red: 0.96, green: 0.48, blue: 0.16, alpha: 1), UIColor(red: 0.24, green: 0.46, blue: 0.92, alpha: 1)]
        }
    }

    fileprivate var motion: TTGRefreshPathEffectMotion {
        switch self {
        case .auroraLoop: .aurora
        case .pulseCircuit: .circuit
        case .zenRipple: .ripple
        case .neonCat: .bounce
        case .origamiBird: .fold
        case .koiStream: .swim
        case .retroRadar: .radar
        case .cyberGrid: .scan
        case .lunarTide: .tide
        case .flameJet: .ignite
        case .lotusBloom: .bloom
        case .robotSmile: .blink
        case .whaleDive: .dive
        case .auroraWave: .aurora
        case .vinylSpin: .record
        case .pixelHeart: .pixel
        case .dragonCurve: .slither
        case .rainGarden: .rain
        case .quantumKnot: .quantum
        case .rocketOrbit: .launch
        }
    }

    fileprivate var lineDashPattern: [NSNumber]? {
        switch self {
        case .pulseCircuit, .cyberGrid:
            [8, 6]
        case .retroRadar, .rainGarden:
            [4, 7]
        case .rocketOrbit:
            [16, 6, 4, 6]
        case .pixelHeart:
            [6, 3]
        default:
            nil
        }
    }

    fileprivate var strokeLineWidth: CGFloat {
        switch self {
        case .pixelHeart, .pulseCircuit, .cyberGrid:
            3.2
        case .lotusBloom, .zenRipple:
            3.6
        case .flameJet, .dragonCurve:
            4.8
        default:
            4.0
        }
    }
}

public struct TTGRefreshPathEffectText {
    public var title: String
    public var subtitle: String

    public init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }
}

public typealias TTGRefreshPathEffectHeaderTextProvider = @MainActor (
    TTGRefreshPathEffectStyle,
    TTGRefreshHeaderState
) -> TTGRefreshPathEffectText

public typealias TTGRefreshPathEffectFooterTextProvider = @MainActor (
    TTGRefreshPathEffectStyle,
    TTGRefreshFooterState
) -> TTGRefreshPathEffectText

@MainActor
public struct TTGRefreshPathEffectTemplate {
    public var style: TTGRefreshPathEffectStyle
    public var headerPreferredHeight: CGFloat
    public var headerTriggerHeight: CGFloat
    public var footerPreferredHeight: CGFloat
    public var footerTriggerHeight: CGFloat
    public var footerContentWidth: CGFloat
    public var colors: [UIColor]?
    public var animationSpeed: CGFloat
    public var lineWidthScale: CGFloat
    public var headerTextProvider: TTGRefreshPathEffectHeaderTextProvider
    public var footerTextProvider: TTGRefreshPathEffectFooterTextProvider

    public init(
        style: TTGRefreshPathEffectStyle,
        headerPreferredHeight: CGFloat = 116,
        headerTriggerHeight: CGFloat? = nil,
        footerPreferredHeight: CGFloat = 78,
        footerTriggerHeight: CGFloat = 58,
        footerContentWidth: CGFloat = 286,
        colors: [UIColor]? = nil,
        animationSpeed: CGFloat = 1,
        lineWidthScale: CGFloat = 1,
        headerTextProvider: @escaping TTGRefreshPathEffectHeaderTextProvider = TTGRefreshPathEffectTemplate.defaultHeaderTextProvider,
        footerTextProvider: @escaping TTGRefreshPathEffectFooterTextProvider = TTGRefreshPathEffectTemplate.defaultFooterTextProvider
    ) {
        self.style = style
        self.headerPreferredHeight = headerPreferredHeight
        self.headerTriggerHeight = headerTriggerHeight ?? headerPreferredHeight
        self.footerPreferredHeight = footerPreferredHeight
        self.footerTriggerHeight = footerTriggerHeight
        self.footerContentWidth = footerContentWidth
        self.colors = colors
        self.animationSpeed = animationSpeed
        self.lineWidthScale = lineWidthScale
        self.headerTextProvider = headerTextProvider
        self.footerTextProvider = footerTextProvider
    }

    public func makeHeaderView() -> TTGRefreshPathEffectHeaderView {
        TTGRefreshPathEffectHeaderView(template: self)
    }

    public func makeFooterView() -> TTGRefreshPathEffectFooterView {
        TTGRefreshPathEffectFooterView(template: self)
    }

    public static func defaultHeaderTextProvider(
        style: TTGRefreshPathEffectStyle,
        state: TTGRefreshHeaderState
    ) -> TTGRefreshPathEffectText {
        switch state {
        case .idle:
            TTGRefreshPathEffectText(title: style.title, subtitle: "Pull to preview the refresh path.")
        case .pulling:
            TTGRefreshPathEffectText(title: "Tracing \(style.title)", subtitle: "Progress maps directly to stroke and scale.")
        case .willRefresh:
            TTGRefreshPathEffectText(title: "Release to refresh", subtitle: style.subtitle)
        case .refreshing:
            TTGRefreshPathEffectText(title: "\(style.title) refreshing", subtitle: "Looping path animation is running.")
        case .ending:
            TTGRefreshPathEffectText(title: "Refresh complete", subtitle: "State-driven UI returned to idle.")
        }
    }

    public static func defaultFooterTextProvider(
        style: TTGRefreshPathEffectStyle,
        state: TTGRefreshFooterState
    ) -> TTGRefreshPathEffectText {
        switch state {
        case .idle, .pulling:
            TTGRefreshPathEffectText(title: "Tap or pull for more", subtitle: "\(style.title) load-more")
        case .willLoad:
            TTGRefreshPathEffectText(title: "Release to load more", subtitle: style.subtitle)
        case .loading:
            TTGRefreshPathEffectText(title: "Loading next page", subtitle: "\(style.title) is animating")
        case .noMoreData:
            TTGRefreshPathEffectText(title: "No more pages", subtitle: "Reset after pull-to-refresh.")
        case .hidden:
            TTGRefreshPathEffectText(title: "", subtitle: "")
        }
    }
}

public final class TTGRefreshPathEffectHeaderView: UIView, TTGRefreshHeaderContentView {
    public var preferredHeight: CGFloat
    public var triggerHeight: CGFloat

    private let template: TTGRefreshPathEffectTemplate
    private var style: TTGRefreshPathEffectStyle { template.style }
    private let glyphView: TTGRefreshPathEffectGlyphView
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    public convenience init(style: TTGRefreshPathEffectStyle) {
        self.init(template: TTGRefreshPathEffectTemplate(style: style))
    }

    public init(template: TTGRefreshPathEffectTemplate) {
        self.template = template
        self.preferredHeight = template.headerPreferredHeight
        self.triggerHeight = template.headerTriggerHeight
        self.glyphView = TTGRefreshPathEffectGlyphView(template: template, role: .refresh, preferredSize: 70)
        super.init(frame: .zero)
        setupView()
        refreshHeaderDidChange(state: .idle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func refreshHeaderDidChange(state: TTGRefreshHeaderState) {
        let text = template.headerTextProvider(style, state)
        titleLabel.text = text.title
        subtitleLabel.text = text.subtitle

        switch state {
        case .idle, .pulling, .willRefresh, .ending:
            glyphView.stopAnimating()
        case .refreshing:
            glyphView.startAnimating()
        }
    }

    public func refreshHeaderDidUpdate(progress: CGFloat) {
        glyphView.update(progress: progress)
    }

    private func setupView() {
        titleLabel.font = .systemFont(ofSize: 18, weight: .heavy)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1

        subtitleLabel.font = .preferredFont(forTextStyle: .caption1)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 2

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 5
        textStack.translatesAutoresizingMaskIntoConstraints = false

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.addSubview(glyphView)
        contentView.addSubview(textStack)

        NSLayoutConstraint.activate([
            glyphView.widthAnchor.constraint(equalToConstant: 70),
            glyphView.heightAnchor.constraint(equalToConstant: 70),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 78),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            glyphView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            glyphView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textStack.leadingAnchor.constraint(equalTo: glyphView.trailingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

public final class TTGRefreshPathEffectFooterView: UIView, TTGRefreshFooterContentView {
    public var preferredHeight: CGFloat
    public var triggerHeight: CGFloat

    private let template: TTGRefreshPathEffectTemplate
    private var style: TTGRefreshPathEffectStyle { template.style }
    private let glyphView: TTGRefreshPathEffectGlyphView
    private let capsuleView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    public convenience init(style: TTGRefreshPathEffectStyle) {
        self.init(template: TTGRefreshPathEffectTemplate(style: style))
    }

    public init(template: TTGRefreshPathEffectTemplate) {
        self.template = template
        self.preferredHeight = template.footerPreferredHeight
        self.triggerHeight = template.footerTriggerHeight
        self.glyphView = TTGRefreshPathEffectGlyphView(template: template, role: .loadMore, preferredSize: 46)
        super.init(frame: .zero)
        setupView()
        refreshFooterDidChange(state: .idle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func refreshFooterDidChange(state: TTGRefreshFooterState) {
        let text = template.footerTextProvider(style, state)
        titleLabel.text = text.title.isEmpty ? nil : text.title
        subtitleLabel.text = text.subtitle.isEmpty ? nil : text.subtitle

        switch state {
        case .idle, .pulling, .willLoad, .noMoreData, .hidden:
            glyphView.stopAnimating()
        case .loading:
            glyphView.startAnimating()
        }
    }

    public func refreshFooterDidUpdate(progress: CGFloat) {
        glyphView.update(progress: progress)
        capsuleView.transform = CGAffineTransform(scaleX: 0.94 + progress * 0.06, y: 0.94 + progress * 0.06)
    }

    private func setupView() {
        capsuleView.backgroundColor = (template.colors ?? style.colors)[0].withAlphaComponent(0.12)
        capsuleView.layer.cornerRadius = 24
        capsuleView.layer.cornerCurve = .continuous
        capsuleView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(capsuleView)

        titleLabel.font = .systemFont(ofSize: 14, weight: .heavy)
        titleLabel.textColor = .label

        subtitleLabel.font = .preferredFont(forTextStyle: .caption2)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 1

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.translatesAutoresizingMaskIntoConstraints = false
        capsuleView.addSubview(glyphView)
        capsuleView.addSubview(textStack)

        NSLayoutConstraint.activate([
            capsuleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            capsuleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            capsuleView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 24),
            capsuleView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -24),
            capsuleView.heightAnchor.constraint(equalToConstant: 56),
            capsuleView.widthAnchor.constraint(equalToConstant: template.footerContentWidth),
            glyphView.leadingAnchor.constraint(equalTo: capsuleView.leadingAnchor, constant: 16),
            glyphView.centerYAnchor.constraint(equalTo: capsuleView.centerYAnchor),
            glyphView.widthAnchor.constraint(equalToConstant: 46),
            glyphView.heightAnchor.constraint(equalToConstant: 46),
            textStack.leadingAnchor.constraint(equalTo: glyphView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: capsuleView.trailingAnchor, constant: -18),
            textStack.centerYAnchor.constraint(equalTo: capsuleView.centerYAnchor)
        ])
    }
}

public final class TTGRefreshPathEffectPreviewView: UIView {
    private let glyphView: TTGRefreshPathEffectGlyphView

    public convenience init(
        style: TTGRefreshPathEffectStyle,
        role: TTGRefreshPathEffectRole = .refresh,
        size: CGFloat = 54
    ) {
        self.init(template: TTGRefreshPathEffectTemplate(style: style), role: role, size: size)
    }

    public init(
        template: TTGRefreshPathEffectTemplate,
        role: TTGRefreshPathEffectRole = .refresh,
        size: CGFloat = 54
    ) {
        self.glyphView = TTGRefreshPathEffectGlyphView(template: template, role: role, preferredSize: size)
        super.init(frame: .zero)
        setupView(size: size)
        update(progress: 1)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func update(progress: CGFloat) {
        glyphView.update(progress: progress)
    }

    public func startAnimating() {
        glyphView.startAnimating()
    }

    public func stopAnimating() {
        glyphView.stopAnimating()
    }

    private func setupView(size: CGFloat) {
        addSubview(glyphView)
        NSLayoutConstraint.activate([
            glyphView.centerXAnchor.constraint(equalTo: centerXAnchor),
            glyphView.centerYAnchor.constraint(equalTo: centerYAnchor),
            glyphView.widthAnchor.constraint(equalToConstant: size),
            glyphView.heightAnchor.constraint(equalToConstant: size)
        ])
    }
}

private final class TTGRefreshPathEffectGlyphView: UIView {
    private let template: TTGRefreshPathEffectTemplate
    private var style: TTGRefreshPathEffectStyle { template.style }
    private var colors: [UIColor] { template.colors ?? style.colors }
    private let role: TTGRefreshPathEffectRole
    private let preferredSize: CGFloat
    private let baseLayer = CAShapeLayer()
    private let strokeLayer = CAShapeLayer()
    private let accentLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    private var lastBounds: CGRect = .zero
    private var currentStrokeLineWidth: CGFloat {
        style.strokeLineWidth * template.lineWidthScale * (role == .refresh ? 1 : 0.82)
    }

    init(template: TTGRefreshPathEffectTemplate, role: TTGRefreshPathEffectRole, preferredSize: CGFloat) {
        self.template = template
        self.role = role
        self.preferredSize = preferredSize
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupLayers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard bounds != lastBounds else { return }
        lastBounds = bounds
        updateLayerFrames()
    }

    func update(progress: CGFloat) {
        let clamped = min(max(progress, 0), 1)
        strokeLayer.strokeEnd = max(0.06, clamped)
        accentLayer.strokeEnd = min(1, clamped * 1.15)
        transform = CGAffineTransform(scaleX: 0.86 + clamped * 0.14, y: 0.86 + clamped * 0.14)
        alpha = 0.38 + clamped * 0.62
    }

    func startAnimating() {
        stopAnimating()
        strokeLayer.strokeEnd = 1
        accentLayer.strokeEnd = 1

        if style == .auroraWave {
            let lineWidth = currentStrokeLineWidth
            addGradientRotation(duration: 1.2)
            addLineWidthPulse(from: lineWidth * 0.75, to: lineWidth * 1.75, duration: 0.52)
            return
        }

        switch style.motion {
        case .aurora:
            addGradientRotation(duration: 1.8)
            addSoftPulse(scale: 1.06, duration: 0.9)
        case .circuit:
            addDashFlow(distance: -52, duration: 0.44)
            addStrokeSweep(duration: 0.8)
        case .ripple:
            addSoftPulse(scale: 1.12, duration: 1.05)
            addOpacityBreath(duration: 1.05)
        case .bounce:
            addVerticalBob(distance: 5, duration: 0.48)
            addSoftPulse(scale: 1.05, duration: 0.48)
        case .fold:
            addRotationWobble(angle: 0.16, duration: 0.64)
            addStrokeSweep(duration: 0.9)
        case .swim:
            addHorizontalFloat(distance: 6, duration: 0.72)
            addRotationWobble(angle: 0.10, duration: 0.72)
        case .radar:
            addGradientRotation(duration: 0.9)
            addOpacityBreath(duration: 0.8)
        case .scan:
            addDashFlow(distance: -28, duration: 0.30)
            addHorizontalFloat(distance: 3, duration: 0.24)
        case .tide:
            addVerticalBob(distance: 4, duration: 1.15)
            addStrokeSweep(duration: 1.5)
        case .ignite:
            addVerticalBob(distance: -7, duration: 0.34)
            addSoftPulse(scale: 1.13, duration: 0.34)
        case .bloom:
            addSoftPulse(scale: 1.16, duration: 0.95)
            addStrokeSweep(duration: 1.2)
        case .blink:
            addOpacityBlink(duration: 0.42)
            addSoftPulse(scale: 1.04, duration: 0.7)
        case .dive:
            addVerticalBob(distance: 7, duration: 0.82)
            addRotationWobble(angle: 0.08, duration: 0.82)
        case .record:
            addWholeRotation(duration: 0.95)
        case .pixel:
            addPixelSnap(duration: 0.38)
            addOpacityBlink(duration: 0.76)
        case .slither:
            addHorizontalFloat(distance: 7, duration: 0.52)
            addRotationWobble(angle: 0.14, duration: 0.52)
        case .rain:
            addVerticalBob(distance: 6, duration: 0.42)
            addDashFlow(distance: -18, duration: 0.42)
        case .quantum:
            addGradientRotation(duration: 1.05)
            addRotationWobble(angle: 0.20, duration: 0.7)
            addSoftPulse(scale: 1.08, duration: 0.7)
        case .launch:
            addLaunchMotion(duration: 0.62)
            addDashFlow(distance: -42, duration: 0.5)
        }
    }

    func stopAnimating() {
        gradientLayer.removeAllAnimations()
        strokeLayer.removeAllAnimations()
        accentLayer.removeAllAnimations()
        layer.removeAllAnimations()
    }

    private func setupLayers() {
        if style == .auroraWave {
            backgroundColor = .secondarySystemGroupedBackground
            layer.borderWidth = 1 / UIScreen.main.scale
            layer.borderColor = UIColor.separator.withAlphaComponent(0.16).cgColor
        } else {
            backgroundColor = colors[0].withAlphaComponent(0.10)
        }
        layer.cornerRadius = preferredSize / 2
        layer.cornerCurve = .continuous

        baseLayer.fillColor = UIColor.clear.cgColor
        baseLayer.strokeColor = UIColor.separator.withAlphaComponent(0.35).cgColor
        baseLayer.lineWidth = 2
        baseLayer.lineCap = .round
        baseLayer.lineJoin = .round
        baseLayer.isHidden = style == .auroraWave
        layer.addSublayer(baseLayer)

        gradientLayer.colors = colors.map(\.cgColor) + [colors[0].cgColor]
        if style == .auroraWave {
            gradientLayer.type = .conic
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        } else {
            gradientLayer.type = .axial
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        }
        layer.addSublayer(gradientLayer)

        strokeLayer.fillColor = UIColor.clear.cgColor
        strokeLayer.strokeColor = UIColor.white.cgColor
        strokeLayer.lineWidth = currentStrokeLineWidth
        strokeLayer.lineCap = .round
        strokeLayer.lineJoin = .round
        strokeLayer.strokeEnd = 0.08
        strokeLayer.lineDashPattern = style.lineDashPattern
        gradientLayer.mask = strokeLayer

        accentLayer.fillColor = UIColor.clear.cgColor
        accentLayer.strokeColor = colors.last?.withAlphaComponent(0.82).cgColor
        accentLayer.lineWidth = 1.7
        accentLayer.lineCap = .round
        accentLayer.lineJoin = .round
        accentLayer.strokeEnd = 0.08
        accentLayer.isHidden = style == .auroraWave
        layer.addSublayer(accentLayer)
    }

    private func addGradientRotation(duration: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.duration = adjusted(duration)
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        gradientLayer.add(animation, forKey: "gradient.rotate")
    }

    private func addWholeRotation(duration: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.duration = adjusted(duration)
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        layer.add(animation, forKey: "whole.rotate")
    }

    private func addDashFlow(distance: CGFloat, duration: CFTimeInterval) {
        guard strokeLayer.lineDashPattern != nil else { return }
        let animation = CABasicAnimation(keyPath: "lineDashPhase")
        animation.fromValue = 0
        animation.toValue = distance
        animation.duration = adjusted(duration)
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        strokeLayer.add(animation, forKey: "dash.flow")
    }

    private func addStrokeSweep(duration: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.fromValue = 0
        animation.toValue = 0.28
        animation.duration = adjusted(duration)
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        strokeLayer.add(animation, forKey: "stroke.sweep")
    }

    private func addSoftPulse(scale: CGFloat, duration: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1
        animation.toValue = scale
        animation.duration = adjusted(duration)
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        layer.add(animation, forKey: "soft.pulse")
    }

    private func addLineWidthPulse(from: CGFloat, to: CGFloat, duration: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath: "lineWidth")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = adjusted(duration)
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        strokeLayer.add(animation, forKey: "line.width.pulse")
    }

    private func addOpacityBreath(duration: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.54
        animation.toValue = 1
        animation.duration = adjusted(duration)
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        accentLayer.add(animation, forKey: "opacity.breath")
    }

    private func addOpacityBlink(duration: CFTimeInterval) {
        let animation = CAKeyframeAnimation(keyPath: "opacity")
        animation.values = [1, 0.25, 1, 0.65, 1]
        animation.keyTimes = [0, 0.18, 0.34, 0.52, 1]
        animation.duration = adjusted(duration)
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        strokeLayer.add(animation, forKey: "opacity.blink")
    }

    private func addVerticalBob(distance: CGFloat, duration: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath: "transform.translation.y")
        animation.fromValue = -distance
        animation.toValue = distance
        animation.duration = adjusted(duration)
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        layer.add(animation, forKey: "vertical.bob")
    }

    private func addHorizontalFloat(distance: CGFloat, duration: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -distance
        animation.toValue = distance
        animation.duration = adjusted(duration)
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        layer.add(animation, forKey: "horizontal.float")
    }

    private func addRotationWobble(angle: CGFloat, duration: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = -angle
        animation.toValue = angle
        animation.duration = adjusted(duration)
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        layer.add(animation, forKey: "rotation.wobble")
    }

    private func addPixelSnap(duration: CFTimeInterval) {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [1, 1.0, 1.14, 1.14, 0.96, 1]
        animation.keyTimes = [0, 0.18, 0.19, 0.48, 0.49, 1]
        animation.duration = adjusted(duration)
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        layer.add(animation, forKey: "pixel.snap")
    }

    private func addLaunchMotion(duration: CFTimeInterval) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        animation.values = [8, -8, 4, -4, 0]
        animation.keyTimes = [0, 0.32, 0.56, 0.76, 1]
        animation.duration = adjusted(duration)
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        layer.add(animation, forKey: "launch.motion")
    }

    private func adjusted(_ duration: CFTimeInterval) -> CFTimeInterval {
        let speed = max(0.2, template.animationSpeed)
        let base = role == .refresh ? duration : max(0.24, duration * 0.82)
        return base / speed
    }

    private func updateLayerFrames() {
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
        gradientLayer.frame = bounds
        baseLayer.frame = bounds
        strokeLayer.frame = bounds
        accentLayer.frame = bounds

        let rect: CGRect
        if style == .auroraWave {
            rect = bounds.insetBy(dx: bounds.width * 0.19, dy: bounds.height * 0.22)
        } else {
            rect = bounds.insetBy(dx: bounds.width * 0.18, dy: bounds.height * 0.18)
        }
        let path = TTGRefreshPathEffectPathFactory.path(for: style, role: role, in: rect)
        baseLayer.path = path.cgPath
        strokeLayer.path = path.cgPath
        accentLayer.path = TTGRefreshPathEffectPathFactory.accentPath(for: style, role: role, in: rect).cgPath
    }
}

private enum TTGRefreshPathEffectPathFactory {
    static func path(for style: TTGRefreshPathEffectStyle, role: TTGRefreshPathEffectRole, in rect: CGRect) -> UIBezierPath {
        switch style {
        case .auroraLoop: lissajous(in: rect, a: 2, b: role == .refresh ? 3 : 2, phase: .pi / 2)
        case .pulseCircuit: circuit(in: rect, compact: role == .loadMore)
        case .zenRipple: ripple(in: rect, turns: role == .refresh ? 2.5 : 1.8)
        case .neonCat: cat(in: rect, compact: role == .loadMore)
        case .origamiBird: bird(in: rect, compact: role == .loadMore)
        case .koiStream: fish(in: rect, compact: role == .loadMore)
        case .retroRadar: radar(in: rect, compact: role == .loadMore)
        case .cyberGrid: grid(in: rect, compact: role == .loadMore)
        case .lunarTide: lunar(in: rect, compact: role == .loadMore)
        case .flameJet: flame(in: rect, compact: role == .loadMore)
        case .lotusBloom: lotus(in: rect, petals: role == .refresh ? 6 : 4)
        case .robotSmile: robot(in: rect, compact: role == .loadMore)
        case .whaleDive: whale(in: rect, compact: role == .loadMore)
        case .auroraWave: auroraWave(in: rect, compact: role == .loadMore)
        case .vinylSpin: vinyl(in: rect, compact: role == .loadMore)
        case .pixelHeart: pixelHeart(in: rect, compact: role == .loadMore)
        case .dragonCurve: dragon(in: rect, compact: role == .loadMore)
        case .rainGarden: rainGarden(in: rect, compact: role == .loadMore)
        case .quantumKnot: lissajous(in: rect, a: role == .refresh ? 3 : 2, b: 4, phase: .pi / 3)
        case .rocketOrbit: rocket(in: rect, compact: role == .loadMore)
        }
    }

    static func accentPath(for style: TTGRefreshPathEffectStyle, role: TTGRefreshPathEffectRole, in rect: CGRect) -> UIBezierPath {
        let inset = rect.insetBy(dx: rect.width * 0.15, dy: rect.height * 0.15)
        switch style {
        case .pulseCircuit, .cyberGrid:
            return cornerTicks(in: inset)
        case .retroRadar, .vinylSpin, .rocketOrbit:
            return UIBezierPath(ovalIn: inset)
        case .lotusBloom, .rainGarden:
            return lotus(in: inset, petals: 3)
        case .auroraLoop, .zenRipple, .lunarTide, .quantumKnot:
            return UIBezierPath(ovalIn: inset)
        default:
            return UIBezierPath()
        }
    }

    private static func cornerTicks(in rect: CGRect) -> UIBezierPath {
        let p = UIBezierPath()
        let tick = min(rect.width, rect.height) * 0.18
        let corners = [
            CGPoint(x: rect.minX, y: rect.minY),
            CGPoint(x: rect.maxX, y: rect.minY),
            CGPoint(x: rect.maxX, y: rect.maxY),
            CGPoint(x: rect.minX, y: rect.maxY)
        ]
        for corner in corners {
            let xDirection: CGFloat = corner.x == rect.minX ? 1 : -1
            let yDirection: CGFloat = corner.y == rect.minY ? 1 : -1
            p.move(to: corner)
            p.addLine(to: CGPoint(x: corner.x + tick * xDirection, y: corner.y))
            p.move(to: corner)
            p.addLine(to: CGPoint(x: corner.x, y: corner.y + tick * yDirection))
        }
        return p
    }

    private static func lissajous(in rect: CGRect, a: CGFloat, b: CGFloat, phase: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        let steps = 140
        for step in 0...steps {
            let t = CGFloat(step) / CGFloat(steps) * CGFloat.pi * 2
            let point = CGPoint(
                x: rect.midX + sin(a * t + phase) * rect.width * 0.46,
                y: rect.midY + sin(b * t) * rect.height * 0.46
            )
            step == 0 ? path.move(to: point) : path.addLine(to: point)
        }
        return path
    }

    private static func ripple(in rect: CGRect, turns: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        let steps = 120
        for step in 0...steps {
            let t = CGFloat(step) / CGFloat(steps)
            let angle = t * CGFloat.pi * 2 * turns
            let radius = min(rect.width, rect.height) * 0.08 + min(rect.width, rect.height) * 0.42 * t
            let point = CGPoint(x: rect.midX + cos(angle) * radius, y: rect.midY + sin(angle) * radius)
            step == 0 ? path.move(to: point) : path.addLine(to: point)
        }
        return path
    }

    private static func circuit(in rect: CGRect, compact: Bool) -> UIBezierPath {
        let p = UIBezierPath()
        p.move(to: CGPoint(x: rect.minX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.minX + rect.width * 0.22, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.minX + rect.width * 0.22, y: rect.minY + rect.height * 0.24))
        p.addLine(to: CGPoint(x: rect.minX + rect.width * 0.58, y: rect.minY + rect.height * 0.24))
        p.addLine(to: CGPoint(x: rect.minX + rect.width * 0.58, y: rect.maxY - rect.height * 0.22))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - rect.height * 0.22))
        if !compact {
            p.move(to: CGPoint(x: rect.minX + rect.width * 0.38, y: rect.midY))
            p.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.18, y: rect.midY))
        }
        return p
    }

    private static func cat(in rect: CGRect, compact: Bool) -> UIBezierPath {
        let p = UIBezierPath()
        p.move(to: CGPoint(x: rect.minX + rect.width * 0.20, y: rect.midY))
        p.addQuadCurve(to: CGPoint(x: rect.minX + rect.width * 0.36, y: rect.minY + rect.height * 0.16), controlPoint: CGPoint(x: rect.minX + rect.width * 0.26, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.34))
        p.addLine(to: CGPoint(x: rect.minX + rect.width * 0.64, y: rect.minY + rect.height * 0.16))
        p.addQuadCurve(to: CGPoint(x: rect.maxX - rect.width * 0.20, y: rect.midY), controlPoint: CGPoint(x: rect.maxX - rect.width * 0.26, y: rect.minY))
        p.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.08), controlPoint: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addQuadCurve(to: CGPoint(x: rect.minX + rect.width * 0.20, y: rect.midY), controlPoint: CGPoint(x: rect.minX, y: rect.maxY))
        if !compact {
            p.move(to: CGPoint(x: rect.minX + rect.width * 0.36, y: rect.midY))
            p.addQuadCurve(to: CGPoint(x: rect.maxX - rect.width * 0.36, y: rect.midY), controlPoint: CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.16))
        }
        return p
    }

    private static func bird(in rect: CGRect, compact: Bool) -> UIBezierPath {
        let p = UIBezierPath()
        p.move(to: CGPoint(x: rect.minX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.20))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.24))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        if !compact {
            p.move(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.20))
            p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.24))
        }
        return p
    }

    private static func fish(in rect: CGRect, compact: Bool) -> UIBezierPath {
        let p = UIBezierPath()
        p.move(to: CGPoint(x: rect.minX, y: rect.midY))
        p.addCurve(to: CGPoint(x: rect.maxX - rect.width * 0.24, y: rect.midY), controlPoint1: CGPoint(x: rect.minX + rect.width * 0.22, y: rect.minY), controlPoint2: CGPoint(x: rect.minX + rect.width * 0.62, y: rect.minY))
        p.addCurve(to: CGPoint(x: rect.minX, y: rect.midY), controlPoint1: CGPoint(x: rect.minX + rect.width * 0.62, y: rect.maxY), controlPoint2: CGPoint(x: rect.minX + rect.width * 0.22, y: rect.maxY))
        p.move(to: CGPoint(x: rect.maxX - rect.width * 0.24, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.30))
        p.move(to: CGPoint(x: rect.maxX - rect.width * 0.24, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - rect.height * 0.30))
        if !compact {
            p.move(to: CGPoint(x: rect.minX + rect.width * 0.28, y: rect.midY))
            p.addQuadCurve(to: CGPoint(x: rect.maxX - rect.width * 0.36, y: rect.midY), controlPoint: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.30))
        }
        return p
    }

    private static func radar(in rect: CGRect, compact: Bool) -> UIBezierPath {
        let p = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY), radius: min(rect.width, rect.height) * 0.42, startAngle: -.pi / 2, endAngle: .pi * 1.35, clockwise: true)
        p.move(to: CGPoint(x: rect.midX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.25))
        if !compact {
            p.move(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.24))
            p.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: min(rect.width, rect.height) * 0.22, startAngle: -.pi / 2, endAngle: .pi, clockwise: true)
        }
        return p
    }

    private static func grid(in rect: CGRect, compact: Bool) -> UIBezierPath {
        let p = UIBezierPath()
        let columns = compact ? 2 : 3
        for index in 0...columns {
            let x = rect.minX + rect.width * CGFloat(index) / CGFloat(columns)
            p.move(to: CGPoint(x: x, y: rect.minY))
            p.addLine(to: CGPoint(x: x, y: rect.maxY))
            let y = rect.minY + rect.height * CGFloat(index) / CGFloat(columns)
            p.move(to: CGPoint(x: rect.minX, y: y))
            p.addLine(to: CGPoint(x: rect.maxX, y: y))
        }
        p.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        return p
    }

    private static func lunar(in rect: CGRect, compact: Bool) -> UIBezierPath {
        let p = UIBezierPath()
        p.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: min(rect.width, rect.height) * 0.34, startAngle: -.pi * 0.78, endAngle: .pi * 0.76, clockwise: false)
        p.move(to: CGPoint(x: rect.minX, y: rect.maxY - rect.height * 0.24))
        p.addCurve(to: CGPoint(x: rect.maxX, y: rect.maxY - rect.height * 0.24), controlPoint1: CGPoint(x: rect.minX + rect.width * 0.28, y: rect.maxY), controlPoint2: CGPoint(x: rect.maxX - rect.width * 0.28, y: rect.minY + rect.height * 0.55))
        if !compact {
            p.move(to: CGPoint(x: rect.maxX - rect.width * 0.20, y: rect.minY + rect.height * 0.20))
            p.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.10, y: rect.minY + rect.height * 0.28))
        }
        return p
    }

    private static func flame(in rect: CGRect, compact: Bool) -> UIBezierPath {
        let p = UIBezierPath()
        p.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.addCurve(to: CGPoint(x: rect.midX, y: rect.minY), controlPoint1: CGPoint(x: rect.minX, y: rect.maxY - rect.height * 0.18), controlPoint2: CGPoint(x: rect.maxX - rect.width * 0.12, y: rect.minY + rect.height * 0.32))
        p.addCurve(to: CGPoint(x: rect.midX, y: rect.maxY), controlPoint1: CGPoint(x: rect.minX + rect.width * 0.16, y: rect.minY + rect.height * 0.34), controlPoint2: CGPoint(x: rect.maxX, y: rect.maxY - rect.height * 0.14))
        if !compact {
            p.move(to: CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.16))
            p.addCurve(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.36), controlPoint1: CGPoint(x: rect.minX + rect.width * 0.36, y: rect.maxY - rect.height * 0.34), controlPoint2: CGPoint(x: rect.midX + rect.width * 0.18, y: rect.midY))
        }
        return p
    }

    private static func lotus(in rect: CGRect, petals: Int) -> UIBezierPath {
        let p = UIBezierPath()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) * 0.43
        for index in 0..<petals {
            let angle = CGFloat(index) / CGFloat(petals) * .pi * 2 - .pi / 2
            let end = CGPoint(x: center.x + cos(angle) * radius, y: center.y + sin(angle) * radius)
            p.move(to: center)
            p.addQuadCurve(to: end, controlPoint: CGPoint(x: center.x + cos(angle - 0.55) * radius * 0.62, y: center.y + sin(angle - 0.55) * radius * 0.62))
            p.addQuadCurve(to: center, controlPoint: CGPoint(x: center.x + cos(angle + 0.55) * radius * 0.62, y: center.y + sin(angle + 0.55) * radius * 0.62))
        }
        return p
    }

    private static func robot(in rect: CGRect, compact: Bool) -> UIBezierPath {
        let p = UIBezierPath(roundedRect: rect.insetBy(dx: rect.width * 0.12, dy: rect.height * 0.18), cornerRadius: rect.width * 0.12)
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.minY - rect.height * 0.12))
        p.move(to: CGPoint(x: rect.minX + rect.width * 0.32, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.minX + rect.width * 0.34, y: rect.midY))
        p.move(to: CGPoint(x: rect.maxX - rect.width * 0.34, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.32, y: rect.midY))
        if !compact {
            p.move(to: CGPoint(x: rect.minX + rect.width * 0.34, y: rect.maxY - rect.height * 0.28))
            p.addQuadCurve(to: CGPoint(x: rect.maxX - rect.width * 0.34, y: rect.maxY - rect.height * 0.28), controlPoint: CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.12))
        }
        return p
    }

    private static func whale(in rect: CGRect, compact: Bool) -> UIBezierPath {
        let p = UIBezierPath()
        p.move(to: CGPoint(x: rect.minX, y: rect.midY))
        p.addCurve(to: CGPoint(x: rect.maxX - rect.width * 0.20, y: rect.midY), controlPoint1: CGPoint(x: rect.minX + rect.width * 0.20, y: rect.minY), controlPoint2: CGPoint(x: rect.maxX - rect.width * 0.30, y: rect.minY + rect.height * 0.04))
        p.addCurve(to: CGPoint(x: rect.minX, y: rect.midY), controlPoint1: CGPoint(x: rect.maxX - rect.width * 0.34, y: rect.maxY), controlPoint2: CGPoint(x: rect.minX + rect.width * 0.18, y: rect.maxY))
        p.move(to: CGPoint(x: rect.maxX - rect.width * 0.20, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.34))
        p.move(to: CGPoint(x: rect.maxX - rect.width * 0.20, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - rect.height * 0.34))
        if !compact {
            p.move(to: CGPoint(x: rect.minX + rect.width * 0.22, y: rect.minY + rect.height * 0.14))
            p.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.18), controlPoint: CGPoint(x: rect.minX + rect.width * 0.36, y: rect.minY - rect.height * 0.12))
        }
        return p
    }

    private static func auroraWave(in rect: CGRect, compact _: Bool) -> UIBezierPath {
        let p = UIBezierPath()
        p.move(to: CGPoint(x: rect.minX, y: rect.midY))
        p.addCurve(
            to: CGPoint(x: rect.midX, y: rect.midY),
            controlPoint1: CGPoint(x: rect.minX + rect.width * 0.22, y: rect.minY),
            controlPoint2: CGPoint(x: rect.minX + rect.width * 0.30, y: rect.maxY)
        )
        p.addCurve(
            to: CGPoint(x: rect.maxX, y: rect.midY),
            controlPoint1: CGPoint(x: rect.minX + rect.width * 0.70, y: rect.minY),
            controlPoint2: CGPoint(x: rect.minX + rect.width * 0.78, y: rect.maxY)
        )
        return p
    }

    private static func vinyl(in rect: CGRect, compact: Bool) -> UIBezierPath {
        let p = UIBezierPath(ovalIn: rect)
        p.append(UIBezierPath(ovalIn: rect.insetBy(dx: rect.width * 0.24, dy: rect.height * 0.24)))
        if !compact {
            p.append(UIBezierPath(ovalIn: rect.insetBy(dx: rect.width * 0.38, dy: rect.height * 0.38)))
        }
        p.move(to: CGPoint(x: rect.midX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return p
    }

    private static func pixelHeart(in rect: CGRect, compact: Bool) -> UIBezierPath {
        let p = UIBezierPath()
        let points: [CGPoint] = [
            CGPoint(x: 0.50, y: 0.88), CGPoint(x: 0.12, y: 0.50), CGPoint(x: 0.12, y: 0.24),
            CGPoint(x: 0.34, y: 0.14), CGPoint(x: 0.50, y: 0.30), CGPoint(x: 0.66, y: 0.14),
            CGPoint(x: 0.88, y: 0.24), CGPoint(x: 0.88, y: 0.50), CGPoint(x: 0.50, y: 0.88)
        ]
        for (index, point) in points.enumerated() {
            let mapped = CGPoint(x: rect.minX + point.x * rect.width, y: rect.minY + point.y * rect.height)
            index == 0 ? p.move(to: mapped) : p.addLine(to: mapped)
        }
        if !compact {
            p.move(to: CGPoint(x: rect.minX + rect.width * 0.34, y: rect.midY))
            p.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.34, y: rect.midY))
        }
        return p
    }

    private static func dragon(in rect: CGRect, compact: Bool) -> UIBezierPath {
        let p = UIBezierPath()
        p.move(to: CGPoint(x: rect.minX, y: rect.maxY - rect.height * 0.22))
        p.addCurve(to: CGPoint(x: rect.midX, y: rect.midY), controlPoint1: CGPoint(x: rect.minX + rect.width * 0.14, y: rect.minY), controlPoint2: CGPoint(x: rect.minX + rect.width * 0.42, y: rect.maxY))
        p.addCurve(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.28), controlPoint1: CGPoint(x: rect.maxX - rect.width * 0.22, y: rect.minY), controlPoint2: CGPoint(x: rect.maxX - rect.width * 0.14, y: rect.maxY))
        if !compact {
            p.move(to: CGPoint(x: rect.maxX - rect.width * 0.12, y: rect.minY + rect.height * 0.28))
            p.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.30, y: rect.minY + rect.height * 0.20))
            p.move(to: CGPoint(x: rect.maxX - rect.width * 0.12, y: rect.minY + rect.height * 0.28))
            p.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.28, y: rect.minY + rect.height * 0.44))
        }
        return p
    }

    private static func rainGarden(in rect: CGRect, compact: Bool) -> UIBezierPath {
        let p = UIBezierPath()
        p.move(to: CGPoint(x: rect.minX, y: rect.maxY - rect.height * 0.22))
        p.addCurve(to: CGPoint(x: rect.maxX, y: rect.maxY - rect.height * 0.24), controlPoint1: CGPoint(x: rect.minX + rect.width * 0.24, y: rect.minY + rect.height * 0.18), controlPoint2: CGPoint(x: rect.maxX - rect.width * 0.24, y: rect.minY + rect.height * 0.18))
        let drops = compact ? 2 : 4
        for index in 0..<drops {
            let x = rect.minX + rect.width * (0.22 + CGFloat(index) * 0.18)
            p.move(to: CGPoint(x: x, y: rect.minY))
            p.addQuadCurve(to: CGPoint(x: x, y: rect.minY + rect.height * 0.24), controlPoint: CGPoint(x: x - rect.width * 0.06, y: rect.minY + rect.height * 0.12))
            p.addQuadCurve(to: CGPoint(x: x, y: rect.minY), controlPoint: CGPoint(x: x + rect.width * 0.06, y: rect.minY + rect.height * 0.12))
        }
        return p
    }

    private static func rocket(in rect: CGRect, compact: Bool) -> UIBezierPath {
        let p = UIBezierPath()
        p.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: min(rect.width, rect.height) * 0.42, startAngle: .pi * 0.75, endAngle: .pi * 2.15, clockwise: true)
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.20, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.16))
        p.addLine(to: CGPoint(x: rect.minX + rect.width * 0.34, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        if !compact {
            p.move(to: CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.16))
            p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        }
        return p
    }
}
