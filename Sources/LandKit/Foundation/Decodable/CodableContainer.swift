// This is type for representing containers for Codable types, it is used for implementing `@Decode` and other
// property wrappers for custom decoding. Instances of this type shouldn't be constructed directly
// with `init(from: Decoder)` and also shouldn't be encoded directly using `encode(to: Encoder)` on this type.
public protocol CodableContainer: Codable {
    associatedtype Value: Codable
    var wrappedValue: Value { get }
}

extension CodableContainer {
    public init(from decoder: Decoder) throws {
        fatalError("""
        `IndirectDecodable` `\(#function)` shouldn't be called directly (`\(Self.self)`).
        The construction of the type should be handled in `KeyedDecodingContainer` extension and must be public.
        """)
    }

    public func encode(to encoder: Encoder) throws {
        fatalError("""
        `IndirectDecodable` `\(#function)` shouldn't be called directly (`\(Self.self)`).
        The encoding of the type should be handled in `KeyedEncodingContainer` extension and must be public.
        """)
    }
}

// This is default implementation for encoding `CodableContainer`. By default it just takes `wrappedValue`
// and tries to encode it. This implementation can be overridden for specific types with special encoding cases.
extension KeyedEncodingContainer {
    public mutating func encode<T: CodableContainer>(_ value: T, forKey key: KeyedEncodingContainer<K>.Key) throws {
        try encode(value.wrappedValue, forKey: key)
    }
}
