//
//  LKClock.swift
//  LandKit
//
//  Created by Anakin on 2024/7/29.
//

import Foundation

// MARK: - LKClock

public class LKClock {
    public enum Counter {
        case idle
        case counting(Int)

        public mutating func increment() {
            switch self {
            case .idle:
                self = .idle
            case let .counting(tick) where tick == Int.max:
                self = .counting(0)
            case let .counting(tick):
                self = .counting(tick + 1)
            }
        }

        public mutating func decrement() {
            switch self {
            case .idle:
                self = .idle
            case let .counting(tick) where tick <= 1:
                self = .idle
            case let .counting(tick):
                self = .counting(tick - 1)
            }
        }
    }

    public private(set) var counter: Counter = .idle {
        didSet {
            callback?(self)

            if case .idle = counter {
                stop()
            }
        }
    }

    private var timer: Timer? {
        willSet {
            timer?.invalidate()
        }
        didSet {
            if let timer = timer {
                startTime = Date().timeIntervalSince1970
                RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
            }
        }
    }

    private var callback: ((LKClock) -> Void)?

    public let interval: TimeInterval

    private var startTime: TimeInterval?
    private var startTick: Int?

    public init(interval: TimeInterval) {
        self.interval = interval
    }

    deinit {
        stop()
    }
}

public extension LKClock {
    func startCountingUp(from tick: Int = 0, at fireDate: Date = Date(), onTick: @escaping ((LKClock) -> Void)) {
        startTick = tick
        counter = .counting(tick)
        callback = onTick
        timer = Timer(
            fireAt: fireDate,
            interval: interval,
            target: self,
            selector: #selector(countUp),
            userInfo: nil,
            repeats: true
        )
    }

    func startCountingDown(from tick: Int, fireDate: Date = Date(), onTick: @escaping ((LKClock) -> Void)) {
        startTick = tick
        counter = .counting(tick)
        callback = onTick
        timer = Timer(
            fireAt: fireDate,
            interval: interval,
            target: self,
            selector: #selector(countDown),
            userInfo: nil,
            repeats: true
        )
    }

    func stop() {
        timer?.invalidate()

        timer = nil
        callback = nil
    }
}

extension LKClock {
    @objc private func countUp() {
        if let startTime = startTime, let tick = startTick {
            let current = Date().timeIntervalSince1970
            let steps = Int((current - startTime) / interval)
            switch counter {
            case .idle:
                counter = .idle
            case let .counting(tick) where tick == Int.max:
                counter = .counting(0)
            case .counting:
                counter = .counting(tick + steps)
            }
        } else {
            counter.increment()
        }
    }

    @objc private func countDown() {
        if let startTime = startTime, let tick = startTick {
            let current = Date().timeIntervalSince1970
            let steps = Int((current - startTime) / interval)
            switch counter {
            case let .counting(tick) where tick <= 1:
                counter = .idle
            case .counting:
                counter = .counting(tick - steps)
            default:
                counter.decrement()
            }
        } else {
            counter.decrement()
        }
    }
}
