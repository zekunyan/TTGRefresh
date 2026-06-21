import ObjectiveC

enum TTGAssociatedObject {
    static func get<Object: AnyObject>(_ host: AnyObject, key: UnsafeRawPointer) -> Object? {
        objc_getAssociatedObject(host, key) as? Object
    }

    static func set<Object: AnyObject>(_ host: AnyObject, key: UnsafeRawPointer, value: Object?) {
        objc_setAssociatedObject(host, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
