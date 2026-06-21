import XCTest
@testable import TTGRefresh
import UIKit

@MainActor
final class TTGRefreshTests: XCTestCase {
    func testDefaultConfiguration() {
        let configuration = TTGRefreshConfiguration.default
        XCTAssertEqual(configuration.animationDuration, 0.25)
        XCTAssertEqual(configuration.minimumRefreshingDuration, 0.25)
        XCTAssertEqual(configuration.headerPresentationMode, .contentInset)
        XCTAssertEqual(configuration.minimumVisibleAlpha, 0.24)
        XCTAssertEqual(configuration.headerContentVerticalOffset, 36)
        XCTAssertTrue(configuration.isTapToLoadMoreEnabled)
    }

    func testInstallHeaderAndFooterWithSyncActions() {
        let scrollView = UIScrollView()

        scrollView.ttg.addHeaderRefresh {}
        scrollView.ttg.addFooterRefresh {}
        scrollView.ttg.triggerRefresh(animated: false)
        scrollView.ttg.triggerLoadMore(animated: false)

        XCTAssertNotNil(scrollView.ttg.header)
        XCTAssertNotNil(scrollView.ttg.footer)
    }

    func testRefreshCoordinatorRejectsDuplicateAndOppositeOperations() {
        let scrollView = UIScrollView()

        scrollView.ttg.addHeaderRefresh {}
        scrollView.ttg.addFooterRefresh {}

        XCTAssertTrue(scrollView.ttg.triggerRefresh(animated: false))
        XCTAssertFalse(scrollView.ttg.triggerRefresh(animated: false))
        XCTAssertFalse(scrollView.ttg.triggerLoadMore(animated: false))
    }

    func testLoadMoreCoordinatorRejectsDuplicateAndOppositeOperations() {
        let scrollView = UIScrollView()

        scrollView.ttg.addHeaderRefresh {}
        scrollView.ttg.addFooterRefresh {}

        XCTAssertTrue(scrollView.ttg.triggerLoadMore(animated: false))
        XCTAssertFalse(scrollView.ttg.triggerLoadMore(animated: false))
        XCTAssertFalse(scrollView.ttg.triggerRefresh(animated: false))
    }

    func testInstallHeaderAndFooterWithAsyncActions() async {
        let scrollView = UIScrollView()

        scrollView.ttg.addHeaderRefresh {
            await Task.yield()
        }
        scrollView.ttg.addInfiniteLoad {
            await Task.yield()
        }

        XCTAssertNotNil(scrollView.ttg.header)
        XCTAssertNotNil(scrollView.ttg.footer)
    }

    func testInstallBuiltInPathEffectStyle() async {
        let scrollView = UIScrollView()

        scrollView.ttg.addPathEffectHeaderRefresh(style: .auroraLoop) {
            await Task.yield()
        }
        scrollView.ttg.addPathEffectInfiniteLoad(style: .pulseCircuit, preloadOffset: 180) {
            await Task.yield()
        }

        XCTAssertEqual(TTGRefreshPathEffectStyle.allCases.count, 20)
        XCTAssertTrue(TTGRefreshPathEffectStyle.allCases.contains(.auroraWave))
        XCTAssertNotNil(scrollView.ttg.header)
        XCTAssertNotNil(scrollView.ttg.footer)
    }

    func testPathEffectHeaderTriggerDefaultsToPreferredHeight() {
        let defaultTemplate = TTGRefreshPathEffectTemplate(style: .auroraWave)
        XCTAssertEqual(defaultTemplate.headerTriggerHeight, defaultTemplate.headerPreferredHeight)

        let customTemplate = TTGRefreshPathEffectTemplate(
            style: .auroraWave,
            headerPreferredHeight: 120,
            headerTriggerHeight: 90
        )
        XCTAssertEqual(customTemplate.headerPreferredHeight, 120)
        XCTAssertEqual(customTemplate.headerTriggerHeight, 90)
    }

    func testFooterLoadingSurvivesHiddenWhenContentFitsAndReleasesCoordinatorOnEnd() async {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 320, height: 640))
        scrollView.contentSize = CGSize(width: 320, height: 1_200)

        var configuration = TTGRefreshConfiguration.default
        configuration.footerVisibilityMode = .hiddenWhenContentFits
        configuration.minimumRefreshingDuration = 0

        scrollView.ttg.addHeaderRefresh {}
        scrollView.ttg.addFooterRefresh(configuration: configuration) {}

        XCTAssertTrue(scrollView.ttg.triggerLoadMore(animated: false))
        XCTAssertEqual(scrollView.ttg.footer?.state, .loading)

        scrollView.contentSize = CGSize(width: 320, height: 120)
        await drainMainActorWork()

        XCTAssertFalse(scrollView.ttg.footer?.isHidden ?? true)
        XCTAssertEqual(scrollView.ttg.footer?.state, .loading)

        scrollView.ttg.endFooterRefreshing(animated: false)
        await drainMainActorWork()

        XCTAssertEqual(scrollView.ttg.footer?.state, .hidden)
        XCTAssertTrue(scrollView.ttg.triggerRefresh(animated: false))
    }

    private func drainMainActorWork() async {
        await Task.yield()
        await Task.yield()
    }
}
