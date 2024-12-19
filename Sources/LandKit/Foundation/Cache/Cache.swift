//
//  Cache.swift
//  LandKit
//
//  Created by LandKit on 2023/7/22.
//

import Foundation

public protocol Cache {
    func cache(_ key: String, data: Data)
    func find(_ key: String) -> Data?
    func clear(_ key: String)
    func clear()
}

public protocol TopLevelEncoder {
    func encode<T: Encodable>(_ value: T) throws -> Data
}

public protocol TopLevelDecoder {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension JSONEncoder: TopLevelEncoder {}
extension JSONDecoder: TopLevelDecoder {}
extension PropertyListEncoder: TopLevelEncoder {}
extension PropertyListDecoder: TopLevelDecoder {}

// MARK: - CodableCache

public protocol CodableCache {
    /// 缓存服务
    var cacheService: Cache { get }
    /// 序列化
    var encoder: TopLevelEncoder { get }
    var decoder: TopLevelDecoder { get }
    
    /// 存储实体
    /// - Parameters:
    ///   - key: key
    ///   - entry: 实体
    func cacheEntry<T: Encodable>(_ key: String, entry: T)
    
    /// 读取实体
    /// - Parameter key: key
    /// - Returns: 实体
    func findEntry<T: Decodable>(_ key: String) -> T?
    
    /// 删除实体
    /// - Parameter key: key
    func removeEntry(_ key: String)
    
    /// 清空所有实体
    func clear()
}

public extension CodableCache {
    var encoder: TopLevelEncoder { JSONEncoder() }
    var decoder: TopLevelDecoder { JSONDecoder() }
    
    func cacheEntry<T: Encodable>(_ key: String, entry: T) {
        do {
            let data = try encoder.encode(entry)
            cacheService.cache(key, data: data)
        } catch {
//            print("Cache coding error", error)
        }
    }
    
    func findEntry<T: Decodable>(_ key: String) -> T? {
        if let data = cacheService.find(key) {
            return try? decoder.decode(T.self, from: data)
        }
        return nil
    }

    func removeEntry(_ key: String) {
        cacheService.clear(key)
    }

    func clear() {
        cacheService.clear()
    }
}

// MARK: - PersistingCache

public final class PersistingCache: Cache {
    private let fileCache: Cache
    private let memoryCache: Cache
    
    public init(fileCache: Cache, memoryCache: Cache) {
        self.fileCache = fileCache
        self.memoryCache = memoryCache
    }
    
    public func cache(_ key: String, data: Data) {
        fileCache.cache(key, data: data)
        memoryCache.cache(key, data: data)
    }
    
    public func find(_ key: String) -> Data? {
        if let item = memoryCache.find(key) {
            return item
        } else if let item = fileCache.find(key) {
            memoryCache.cache(key, data: item)
            return item
        } else {
            return nil
        }
    }

    public func clear(_ key: String) {
        memoryCache.clear(key)
        fileCache.clear(key)
    }

    public func clear() {
        memoryCache.clear()
        fileCache.clear()
    }
}

// MARK: - FileCache

public final class FileCache: Cache {
    private let manager: FileManager
    private let baseURL: URL
    
    public init(manager: FileManager = .default, container: String = "FileCache") {
        self.manager = manager
        let cacheDir = try! manager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        baseURL = cacheDir.appendingPathComponent(container, isDirectory: true)
        try! manager.createDirectory(at: baseURL, withIntermediateDirectories: true)
    }
    
    public func cache(_ key: String, data: Data) {
        do {
            let file = URL(fileURLWithPath: "\(key).cache", relativeTo: baseURL)
            try data.write(to: file)
        } catch {
            print("cache error", error)
        }
    }
    
    public func find(_ key: String) -> Data? {
        do {
            let file = URL(fileURLWithPath: "\(key).cache", relativeTo: baseURL)
            return try Data(contentsOf: file)
        } catch {
            return nil
        }
    }
    
    public func clear(_ key: String) {
        do {
            let file = URL(fileURLWithPath: "\(key).cache", relativeTo: baseURL)
            try manager.removeItem(at: file)
        } catch {
            print("cache clear error", error)
        }
    }
    
    public func clear() {
        do {
            try manager.removeItem(at: baseURL)
        } catch {
            print("cache error", error)
        }
    }
}

// MARK: - MemoryCache

public final class MemoryCache: Cache {
    private var _cache: NSCache<NSString, NSData> = .init()
    
    public init() {}
    
    public func cache(_ key: String, data: Data) {
        _cache.setObject(data as NSData, forKey: key as NSString)
    }
    
    public func find(_ key: String) -> Data? {
        _cache.object(forKey: key as NSString) as Data?
    }

    public func clear(_ key: String) {
        _cache.removeObject(forKey: key as NSString)
    }

    public func clear() {
        _cache.removeAllObjects()
    }
}
