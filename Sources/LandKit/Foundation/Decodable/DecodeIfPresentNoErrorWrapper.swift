/// `@DecodeIfPresentNoError` is special version of `@DecodeIfPresent` for decoding values, especially enums.
/// It's used to safely decode enums, this wrapper doesn't emit error if backend responds with non-existing case.
/// In case of error it falls back to default value (`nil` for `Optional` or `defaultValue` if `DecodableDefaultSource`
/// is implemented)
/// ```
/// enum Side: String, Decodable {
///      case outSide = "ROLL_OUT"
///      case inSide = "ROLL_IN"
/// }
///
/// struct Example: Codable {
///
///     @DecodeIfPresentNoError var side: Side?
///
///     // THIS CODE IS NOT REQUIRED, @DecodeIfPresentNoError do all the job
///     // init(from decoder: Decoder) throws {
///     //     let container = try decoder.container(keyedBy: CodingKeys.self)
///     //     side = try? container.decodeIfPresent(Side.self, forKey: .side)
///     // }
/// }
/// ```

@propertyWrapper public struct DecodeIfPresentNoError<T: Codable & DecodableDefaultSource>: CodableContainer {
    public var wrappedValue: T

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
}

// All types - should use `decodeIfPresent`
extension KeyedDecodingContainer {
    public func decode<T>(
        _ type: DecodeIfPresentNoError<T>.Type,
        forKey key: Key
    ) throws -> DecodeIfPresentNoError<T> {
        .init(wrappedValue: (try? decodeIfPresent(T.self, forKey: key)) ?? T.defaultValue)
    }

    public func decode<T>(
        _ type: DecodeIfPresentNoError<T?>.Type,
        forKey key: Key
    ) throws -> DecodeIfPresentNoError<T?> {
        .init(wrappedValue: (try? decodeIfPresent(T.self, forKey: key)) ?? Optional.defaultValue)
    }
}

// `LosslessStringDecodable` types - should use `decodeFromStringIfPresent`
extension KeyedDecodingContainer {
    public func decode<T: LosslessStringDecodable>(
        _ type: DecodeIfPresentNoError<T>.Type,
        forKey key: Key
    ) throws -> DecodeIfPresentNoError<T> {
        .init(wrappedValue: (try? decodeFromStringIfPresent(T.self, forKey: key)) ?? T.defaultValue)
    }

    public func decode<T: LosslessStringDecodable>(
        _ type: DecodeIfPresentNoError<T?>.Type,
        forKey key: Key
    ) throws -> DecodeIfPresentNoError<T?> {
        .init(wrappedValue: (try? decodeFromStringIfPresent(T.self, forKey: key)) ?? Optional.defaultValue)
    }
}
