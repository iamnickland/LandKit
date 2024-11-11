// This file contains wrappers for custom default values. If you need any extra custom default values
// for `@DecodeIfPresent` - implement them similarly to `DecodeIfPresentDefaultTrue`,
// e.g. - `DecodeIfPresentDefaultOne` for Int.self decoding with `?? 1` value
// or `DecodeIfPresentDefaultVISA` for String.self decoding with `?? "visa"` value.
// DO NOT ADD EXTRA TYPES IF YOU NEED ONLY SINGLE DEFAULT VALUE, USE `DecodableDefaultSource` INSTEAD.

// MARK: DecodeIfPresentDefaultTrue

/// `@DecodeIfPresentDefaultTrue` is similar to `@DecodeIfPresent`, but returns explicitly `true`
/// instead of `false` which is `DecodableDefaultSource` extension for `Bool`.
/// ```
/// struct Example: Codable {
///
///     @DecodeIfPresentDefaultTrue var isAvailable: Bool
///     @DecodeIfPresent var isRequired: Bool
///
///     // THIS CODE IS NOT REQUIRED
///     // init(from decoder: Decoder) throws {
///     //     let container = try decoder.container(keyedBy: CodingKeys.self)
///     //     isAvailable = try container.decodeFromStringIfPresent(Bool.self, forKey: .isAvailable) ?? true
///     //     isRequired = try container.decodeFromStringIfPresent(Bool.self, forKey: .isRequired) ?? false
///     // }
/// }
/// ```
@propertyWrapper public struct DecodeIfPresentDefaultTrue: CodableContainer {
    public var wrappedValue: Bool

    public init(wrappedValue: Bool) {
        self.wrappedValue = wrappedValue
    }
}

extension KeyedDecodingContainer {
    public func decode(
        _ type: DecodeIfPresentDefaultTrue.Type,
        forKey key: Key
    ) throws -> DecodeIfPresentDefaultTrue {
        .init(wrappedValue: try decodeFromStringIfPresent(Bool.self, forKey: key) ?? true)
    }
}
