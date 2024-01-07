//
//  Logging.swift
//  LandKit
//
//  Created by LandKit on 2023/7/22.
//

import Foundation

public struct LKLogLevel: OptionSet {
    public let rawValue: Int
    public static let none = LKLogLevel([])
    public static let error = LKLogLevel(rawValue: 1)
    public static let warning = LKLogLevel(rawValue: 2)
    public static let debug = LKLogLevel(rawValue: 4)
    public static let info = LKLogLevel(rawValue: 8)
    public static let verbose = LKLogLevel(rawValue: 32)
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public protocol LKLoggingProtocol {
    /// 日志文件, 当DEBUG模式下为空
    var logFileURL: URL? { get }
    
    func verbose(_ message: String)
    func info(_ message: String)
    func debug(_ message: String)
    func warning(_ message: String)
    func error(_ message: String)
}

class LKLogging: LKLoggingProtocol {
    private let fileURL: URL
    private let fileLock: NSLock = .init()
    
    public init() {
        let cachePath = FileManager.default.urls(for: .cachesDirectory,
                                                 in: .userDomainMask)[0]
        let logURL = cachePath.appendingPathComponent("log_landkit.txt")
        fileURL = logURL
    }
    
    public init(file: URL) {
        fileURL = file
    }
    
    // MARK: - CKLoggingProtocol

    public var logFileURL: URL? {
        return fileURL
    }
    
    public func verbose(_ message: String) {
        let message = "\(dateFormatStr())[VERBOSE] \(message)"
        let print = LKLog.shared.logLevel.contains(.verbose)
        appLog(message, debugPrint: print)
    }
    
    public func info(_ message: String) {
        let message = "\(dateFormatStr())[INFO] \(message)"
        let print = LKLog.shared.logLevel.contains(.info)
        appLog(message, debugPrint: print)
    }
    
    public func debug(_ message: String) {
        let message = "\(dateFormatStr())[DEBUG] \(message)"
        let print = LKLog.shared.logLevel.contains(.debug)
        appLog(message, debugPrint: print)
    }
    
    public func warning(_ message: String) {
        let message = "\(dateFormatStr())[WARNING] \(message)"
        let print = LKLog.shared.logLevel.contains(.warning)
        appLog(message, debugPrint: print)
    }
    
    public func error(_ message: String) {
        let message = "\(dateFormatStr()) 🟥[ERROR] \(message)"
        let print = LKLog.shared.logLevel.contains(.error)
        appLog(message, debugPrint: print)
    }
    
    // MARK: - Private
    
    func dateFormatStr() -> String {
#if DEBUG
        let dformatter = DateFormatter()
        dformatter.dateFormat = ""
        let dateStr = dformatter.string(from: Date())
        return dateStr
#else
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss "
        let dateStr = dformatter.string(from: Date())
        return dateStr
#endif
    }
    
    private func appLog(_ message: String, debugPrint: Bool = true) {
        if debugPrint {
            print("\(message)")
        }
        appendText(fileURL: fileURL, string: "\(message)")
    }
    
    // MARK: 在文件末尾追加新内容

    func appendText(fileURL: URL, string: String) {
        // 如果文件不存在则新建一个
//        if !FileManager.default.fileExists(atPath: fileURL.path) {
//            FileManager.default.createFile(atPath: fileURL.path, contents: nil)
//        }
//        if let handle = try? FileHandle(forWritingTo: fileURL) {
//            handle.seekToEndOfFile()
//            let stringToWrite = "\n" + string
//            handle.write(stringToWrite.data(using: .utf8)!)
//            handle.closeFile()
//        } else {
//            try? string.data(using: .utf8)?.write(to: fileURL)
//        }
        
        // 文件大于1M
//        if CKFileUtil.returnFileSize(path: fileURL.path) > 0.5 {
//            with(lock: fileLock) {
//                let cachePath = FileManager.default.urls(for: .cachesDirectory,
//                                                         in: .userDomainMask)[0]
//                let logURL = cachePath.appendingPathComponent("log_cyberchat_bak.txt")
//                CKFileUtil.movingFile(sourceUrl: fileURL.path, targetUrl: logURL.path)
//                CKFileUtil.deleteFile(path: logURL.path)
//            }
//        }
    }
}

// @synchronized
func with(lock: NSLock, f: () -> Void) {
    lock.lock()
    f()
    lock.unlock()
}

public class LKLog {
    public static let shared = LKLog()
    /// 打印日志的等级,默认只打印高级别日志
    public var logLevel: LKLogLevel = [.error, .warning, .debug]
    
    // MARK: - Private
    
    /// 日志服务/log service
    private static func logging() -> LKLoggingProtocol? {
        return LKLogging()
    }
    
    /// 格式化输出
    private static func formatLog(file: String, function: String, line: Int) -> String {
        var message = ""
#if DEBUG

#else
        let fileName = (file as NSString).lastPathComponent
        message = "\(fileName):\(line) \(function) || "
#endif
        return message
    }
    
    // MARK: - Public
    
    public static func verbose<T>(_ message: T, file: String = #file, function: String = #function, line: Int = #line) {
        let formatStr = formatLog(file: file, function: function, line: line)
        logging()?.verbose("\(formatStr)\(message)")
    }
    
    public static func debug<T>(_ message: T, data: [String: Any] = [:], file: String = #file, function: String = #function, line: Int = #line) {
        let formatStr = formatLog(file: file, function: function, line: line)
        var logMessage = "\(message)"
        if !data.isEmpty {
            let data = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            if let str = String(data: data, encoding: .utf8) {
                logMessage = logMessage.appending("\n\(str)")
            }
        }
        logging()?.debug("\(formatStr)\(logMessage)")
    }
    
    public static func info<T>(_ message: T, file: String = #file, function: String = #function, line: Int = #line) {
        let formatStr = formatLog(file: file, function: function, line: line)
        logging()?.info("\(formatStr)\(message)")
    }
    
    public static func warning<T>(_ message: T, file: String = #file, function: String = #function, line: Int = #line) {
        let formatStr = formatLog(file: file, function: function, line: line)
        logging()?.warning("\(formatStr)\(message)")
    }
    
    public static func error<T>(_ message: T, file: String = #file, function: String = #function, line: Int = #line) {
        let formatStr = formatLog(file: file, function: function, line: line)
        logging()?.error("\(formatStr)\(message)")
    }
    
    public static func error<T>(_ message: T, data: [String: Any] = [:], file: String = #file, function: String = #function, line: Int = #line) {
        let formatStr = formatLog(file: file, function: function, line: line)
        var logMessage = "\(message)"
        if !data.isEmpty {
            let data = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            if let str = String(data: data, encoding: .utf8) {
                logMessage = logMessage.appending("\n\(str)")
            }
        }
        logging()?.error("\(formatStr)\(message)")
    }
}
