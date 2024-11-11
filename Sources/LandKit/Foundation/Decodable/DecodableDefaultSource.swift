import Foundation

/// This protocol allows to use default value in `@DecodeIfPresent` and `@DecodeIfPresentNoError`
/// property wrappers without explicit declaration.
/// You should implement this protocol for using with `@DecodeIfPresent` or `@DecodeIfPresentNoError`.
public protocol DecodableDefaultSource {
    static var defaultValue: Self { get }
}

extension String: DecodableDefaultSource {
    public static var defaultValue: Self { "" }
}

extension Int: DecodableDefaultSource {
    public static var defaultValue: Self { .zero }
}

extension Int8: DecodableDefaultSource {
    public static var defaultValue: Self { .zero }
}

extension Int16: DecodableDefaultSource {
    public static var defaultValue: Self { .zero }
}

extension Int64: DecodableDefaultSource {
    public static var defaultValue: Self { .zero }
}

extension UInt: DecodableDefaultSource {
    public static var defaultValue: Self { .zero }
}

extension UInt32: DecodableDefaultSource {
    public static var defaultValue: Self { .zero }
}

extension UInt8: DecodableDefaultSource {
    public static var defaultValue: Self { .zero }
}

extension UInt16: DecodableDefaultSource {
    public static var defaultValue: Self { .zero }
}

extension UInt64: DecodableDefaultSource {
    public static var defaultValue: Self { .zero }
}

extension Float: DecodableDefaultSource {
    public static var defaultValue: Self { .zero }
}

extension Decimal: DecodableDefaultSource {
    public static var defaultValue: Self { .zero }
}

extension TimeInterval: DecodableDefaultSource {
    public static var defaultValue: Self { 0.0 }
}

extension Bool: DecodableDefaultSource {
    public static var defaultValue: Bool { false }
}

extension Optional: DecodableDefaultSource {
    public static var defaultValue: Self { nil }
}

extension Array: DecodableDefaultSource {
    public static var defaultValue: Self { [] }
}

extension Dictionary: DecodableDefaultSource {
    public static var defaultValue: Self { [:] }
}
