import Foundation

@MainActor
final class TTGRefreshActivityCoordinator {
    enum Operation {
        case header
        case footer
    }

    private var activeOperation: Operation?

    func canBegin(_: Operation) -> Bool {
        activeOperation == nil
    }

    func begin(_ operation: Operation) -> Bool {
        guard activeOperation == nil else { return false }
        activeOperation = operation
        return true
    }

    func end(_ operation: Operation) {
        guard activeOperation == operation else { return }
        activeOperation = nil
    }
}
