import Foundation

/// `@DecodeMilliseconds` is special version of `@DecodeIfPresent` for decoding milliseconds.
/// It expects `TimeInterval` type to decode using `decodeFromStringIfPresent(...)` then
/// converts it to `Date` with required precision.
/// ```
/// struct Example: Codable {
///
///     @DecodeMilliseconds var timestamp: Date
///
///     // THIS CODE IS NOT REQUIRED, @DecodeMilliseconds do all the job
///     // init(from decoder: Decoder) throws {
///     //     let container = try decoder.container(keyedBy: CodingKeys.self)
///     //     timestamp = Date(timeIntervalSince1970:
///     //         (try container.decodeFromStringIfPresent(TimeInterval.self, forKey: .timestamp) ?? 0.0) / 1000.0)
///     // }
/// }
/// ```
@propertyWrapper public struct DecodeMilliseconds: CodableContainer {
    public var wrappedValue: Date

    public init(wrappedValue: Date) {
        self.wrappedValue = wrappedValue
    }
}

extension KeyedDecodingContainer {
    public func decode(
        _ type: DecodeMilliseconds.Type,
        forKey key: Key
    ) throws -> DecodeMilliseconds {
        let milliseconds = try decodeFromStringIfPresent(TimeInterval.self, forKey: key) ?? 0.0
        return .init(wrappedValue: Date(timeIntervalSince1970: milliseconds / 1000.0))
    }
}

extension KeyedEncodingContainer {
    public mutating func encode(_ value: DecodeMilliseconds, forKey key: KeyedEncodingContainer<K>.Key) throws {
        try encode(value.wrappedValue.timeIntervalSince1970 * TimeInterval(1000), forKey: key)
    }
}
