import Foundation

/// `@DecodeSeconds` is special version of `@DecodeIfPresent` for decoding seconds.
/// It expects `TimeInterval` type to decode using `decodeFromStringIfPresent(...)` then
/// converts it to `Date` with required precision.
/// ```
/// struct Example: Codable {
///
///     @DecodeSeconds var timestamp: Date
///
///     // THIS CODE IS NOT REQUIRED, @DecodeSeconds do all the job
///     // init(from decoder: Decoder) throws {
///     //     let container = try decoder.container(keyedBy: CodingKeys.self)
///     //     timestamp = Date(timeIntervalSince1970:
///     //         (try container.decodeFromStringIfPresent(TimeInterval.self, forKey: .timestamp) ?? 0.0))
///     // }
/// }
/// ```
@propertyWrapper public struct DecodeSeconds: CodableContainer {
    public var wrappedValue: Date

    public init(wrappedValue: Date) {
        self.wrappedValue = wrappedValue
    }
}

extension KeyedDecodingContainer {
    public func decode(
        _ type: DecodeSeconds.Type,
        forKey key: Key
    ) throws -> DecodeSeconds {
        let seconds = try decodeFromStringIfPresent(TimeInterval.self, forKey: key) ?? 0.0
        return .init(wrappedValue: Date(timeIntervalSince1970: seconds))
    }
}

extension KeyedEncodingContainer {
    public mutating func encode(_ value: DecodeSeconds, forKey key: KeyedEncodingContainer<K>.Key) throws {
        try encode(value.wrappedValue.timeIntervalSince1970, forKey: key)
    }
}
