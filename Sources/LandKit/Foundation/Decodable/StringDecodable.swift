import Foundation

// MARK: StringDecodable

public protocol StringDecodable {
    init?(decodedString string: String)
}

extension Bool: StringDecodable {
    public init?(decodedString string: String) {
        switch string {
        case "0", "false":
            self = false
        case "1", "true":
            self = true
        default:
            return nil
        }
    }
}

extension Int: StringDecodable {
    public init?(decodedString string: String) {
        self.init(string)
    }
}

extension Int64: StringDecodable {
    public init?(decodedString string: String) {
        self.init(string)
    }
}

extension Float: StringDecodable {
    public init?(decodedString string: String) {
        self.init(string)
    }
}

extension Double: StringDecodable {
    public init?(decodedString string: String) {
        self.init(string)
    }
}

extension Decimal: StringDecodable {
    public init?(decodedString string: String) {
        self.init(string: string)
    }
}

// MARK: LosslessStringConvertible

// Additional conformance for Decimal
extension Decimal: LosslessStringConvertible {
    public init?(_ description: String) {
        self.init(string: description)
    }
}

// MARK: KeyedDecodingContainer extensions

public typealias LosslessStringDecodable = Decodable & StringDecodable & LosslessStringConvertible

// MARK: Decode as expected type first

/// - `decodeFromString` will always decode as the expected type(input) first, if it failed it will try to
/// decode as String type
/// - `decodeFromStringFirst` will decode as String Type first, if it failed it will try to decode as the
/// expected type
/// eg: if the raw data is String Type and the expected type is Decimal, it doesn't make any sense to decode
/// as Decimal first, and it is 3X slower comparing to direct decoding (tests result)
/// - NOTE: Before calling these `decode from string` functions to ensure the raw type is very friendly with
/// decode efficiency(anyway, they all can decode correctly), if the raw type is string(expected type is other type),
/// `decodeFromStringFirst` is the best choice, otherwise `decodeFromString` is better
extension KeyedDecodingContainer {
    // This s a replacement for `decodeFromString`,
    // which will be replaced by this implementation if no production issues
    public func decodeFromString<T>(
        _ type: T.Type,
        forKey key: KeyedDecodingContainer.Key
    ) throws -> T where T: LosslessStringDecodable {
        if let decoded = try? decode(type, forKey: key) {
            return decoded
        }

        let string = try decode(String.self, forKey: key)

        guard let decoded = T(decodedString: string) else {
            throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: desc(type, string))
        }

        return decoded
    }

    // This s a replacement for `decodeFromStringIfPresent`,
    // which will be replaced by this implementation if no production issues
    public func decodeFromStringIfPresent<T>(
        _ type: T.Type,
        forKey key: KeyedDecodingContainer.Key
    ) throws -> T? where T: LosslessStringDecodable {
        if let decoded = try? decodeIfPresent(type, forKey: key) {
            return decoded
        }

        let decodedString = try decodeIfPresent(String.self, forKey: key)

        guard let string = decodedString else { return nil }

        guard let decoded = T(decodedString: string) else {
            throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: desc(type, string))
        }

        return decoded
    }
}

extension UnkeyedDecodingContainer {
    // This s a replacement for `decodeFromString`,
    // which will be replaced by this implementation if no production issues
    public mutating func decodeFromString<T>(
        _ type: T.Type
    ) throws -> T where T: LosslessStringDecodable {
        if let decoded = try? decode(type) {
            return decoded
        }

        let string = try decode(String.self)

        guard let decoded = T(decodedString: string) else {
            throw DecodingError.dataCorruptedError(in: self, debugDescription: desc(type, string))
        }

        return decoded
    }
}

// MARK: Decode as string first

extension KeyedDecodingContainer {
    public func decodeFromStringFirst<T>(
        _ type: T.Type,
        forKey key: KeyedDecodingContainer.Key
    ) throws -> T where T: LosslessStringDecodable {
        guard let string = try? decode(String.self, forKey: key) else {
            return try decode(type, forKey: key)
        }

        guard let decoded = T(decodedString: string) else {
            throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: desc(type, string))
        }

        return decoded
    }

    public func decodeFromStringFirstIfPresent<T>(
        _ type: T.Type,
        forKey key: KeyedDecodingContainer.Key
    ) throws -> T? where T: LosslessStringDecodable {
        guard let string = try? decodeIfPresent(String.self, forKey: key) else {
            return try decodeIfPresent(type, forKey: key)
        }

        guard let decoded = T(decodedString: string) else {
            throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: desc(type, string))
        }

        return decoded
    }
}

extension UnkeyedDecodingContainer {
    public mutating func decodeFromStringFirst<T>(
        _ type: T.Type
    ) throws -> T where T: LosslessStringDecodable {
        guard let string = try? decode(String.self) else {
            return try decode(type)
        }

        guard let decoded = T(decodedString: string) else {
            throw DecodingError.dataCorruptedError(in: self, debugDescription: desc(type, string))
        }

        return decoded
    }
}

// MARK: Helpers

private func desc<T>(_ type: T.Type, _ string: String) -> String {
    "Expected to decode \(T.self) from a string (\"\(string)\") but the string was not valid."
}
