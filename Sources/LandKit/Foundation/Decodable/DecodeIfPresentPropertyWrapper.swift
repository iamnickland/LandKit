import Foundation

/// `@DecodeIfPresent` property wrapper is used for automatically decoding `Codable` in a safer way,
/// you don't need to implement custom `init(from: Decoder)` with `decodeIfPresent` explicitly.
/// It uses `container.decodeIfPresent(...)`, but doesn't require the wrapped type to be an `Optional`.
/// For `StringDecodable` types it implicitly uses `decodeFromStringIfPresent(...)`.
/// In case if value of given property is not present it sets default value which is defined
/// in `DecodableDefaultSource` extension for the given decodable type.
/// ```
/// struct Example: Codable {
///
///     @DecodeIfPresent var title: String
///     @DecodeIfPresent var count: Int
///
///     // THIS CODE IS NOT REQUIRED, @DecodeIfPresent do all the job
///     // init(from decoder: Decoder) throws {
///     //     let container = try decoder.container(keyedBy: CodingKeys.self)
///     //     title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
///     //     count = try container.decodeFromStringIfPresent(Int.self, forKey: .count) ?? 0
///     // }
/// }
/// ```
@propertyWrapper public struct DecodeIfPresent<T: Codable & DecodableDefaultSource>: CodableContainer {
    public var wrappedValue: T

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
}

// Follow the Equatable protocol
extension DecodeIfPresent: Equatable where T: Equatable {}

// All types - should use `decodeIfPresent`
extension KeyedDecodingContainer {
    public func decode<T>(
        _ type: DecodeIfPresent<T>.Type,
        forKey key: Key
    ) throws -> DecodeIfPresent<T> {
        .init(wrappedValue: try decodeIfPresent(T.self, forKey: key) ?? T.defaultValue)
    }

    public func decode<T>(
        _ type: DecodeIfPresent<T?>.Type,
        forKey key: Key
    ) throws -> DecodeIfPresent<T?> {
        .init(wrappedValue: try decodeIfPresent(T.self, forKey: key) ?? Optional.defaultValue)
    }
}

// `LosslessStringDecodable` types - should use `decodeFromStringIfPresent`
extension KeyedDecodingContainer {
    public func decode<T: LosslessStringDecodable>(
        _ type: DecodeIfPresent<T>.Type,
        forKey key: Key
    ) throws -> DecodeIfPresent<T> {
        .init(wrappedValue: try decodeFromStringIfPresent(T.self, forKey: key) ?? T.defaultValue)
    }

    public func decode<T: LosslessStringDecodable>(
        _ type: DecodeIfPresent<T?>.Type,
        forKey key: Key
    ) throws -> DecodeIfPresent<T?> {
        .init(wrappedValue: try decodeFromStringIfPresent(T.self, forKey: key) ?? Optional.defaultValue)
    }
}
