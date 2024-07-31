//
//  LKAsyncs.swift
//
//
//  Created by Anakin on 2024/7/31.
//

import Foundation

// 事件闭包
public typealias LKTask = () -> Void

// MARK: - LKAsyncs

public struct LKAsyncs {
    // MARK: 1.1、异步做一些任务

    /// 异步做一些任务
    /// - Parameter LKTask: 任务
    @discardableResult
    public static func async(_ LKTask: @escaping LKTask) -> DispatchWorkItem {
        return _asyncDelay(0, LKTask)
    }
    
    // MARK: 1.2、异步做任务后回到主线程做任务

    /// 异步做任务后回到主线程做任务
    /// - Parameters:
    ///   - LKTask: 异步任务
    ///   - mainLKTask: 主线程任务
    @discardableResult
    public static func async(_ LKTask: @escaping LKTask, _ mainLKTask: @escaping LKTask) -> DispatchWorkItem {
        return _asyncDelay(0, LKTask, mainLKTask)
    }
    
    // MARK: 1.3、异步延迟(子线程执行任务)

    /// 异步延迟(子线程执行任务)
    /// - Parameter seconds: 延迟秒数
    /// - Parameter LKTask: 延迟的block
    @discardableResult
    public static func asyncDelay(_ seconds: Double, _ LKTask: @escaping LKTask) -> DispatchWorkItem {
        return _asyncDelay(seconds, LKTask)
    }
    
    // MARK: 1.4、异步延迟回到主线程(子线程执行任务，然后回到主线程执行任务)

    /// 异步延迟回到主线程(子线程执行任务，然后回到主线程执行任务)
    /// - Parameter seconds: 延迟秒数
    /// - Parameter LKTask: 延迟的block
    /// - Parameter mainLKTask: 延迟的主线程block
    @discardableResult
    public static func asyncDelay(_ seconds: Double, _ LKTask: @escaping LKTask, _ mainLKTask: @escaping LKTask) -> DispatchWorkItem {
        return _asyncDelay(seconds, LKTask, mainLKTask)
    }
}

// MARK: - 私有的方法

private extension LKAsyncs {
    /// 延迟任务
    /// - Parameters:
    ///   - seconds: 延迟时间
    ///   - LKTask: 任务
    ///   - mainLKTask: 任务
    /// - Returns: DispatchWorkItem
    static func _asyncDelay(_ seconds: Double, _ LKTask: @escaping LKTask, _ mainLKTask: LKTask? = nil) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: LKTask)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + seconds,
                                          execute: item)
        if let main = mainLKTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
        return item
    }
}
