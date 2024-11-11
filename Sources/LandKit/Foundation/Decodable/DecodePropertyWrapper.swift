/// `@Decode` property wrapper is used for automatically decoding `Codable` in a safer way,
/// you don't need to implement custom `init(from: Decoder)` with `decode` explicitly.
/// In the implementation it uses `decodeFromString(...)` and `container.decode(...)`
/// for `StringDecodable` and other types accordingly.
/// ```
/// struct Example: Codable {
///
///     @Decode var title: String
///     @Decode var count: Int
///
///     // THIS CODE IS NOT REQUIRED, @Decode do all the job
///     // init(from decoder: Decoder) throws {
///     //     let container = try decoder.container(keyedBy: CodingKeys.self)
///     //     title = try container.decode(String.self, forKey: .title)
///     //     count = try container.decodeFromString(Int.self, forKey: .count)
///     // }
/// }
/// ```
@propertyWrapper public struct Decode<T: Codable>: CodableContainer {
    public var wrappedValue: T

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
}

extension KeyedDecodingContainer {
    public func decode<T: Decodable>(
        _ type: Decode<T>.Type,
        forKey key: Key
    ) throws -> Decode<T> {
        .init(wrappedValue: try decode(T.self, forKey: key))
    }

    public func decode<T: LosslessStringDecodable>(
        _ type: Decode<T>.Type,
        forKey key: Key
    ) throws -> Decode<T> {
        .init(wrappedValue: try decodeFromString(T.self, forKey: key))
    }
}
