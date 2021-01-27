//
//  Timeout.swift
//  RxSwift
//
//  Created by Tomi Koskinen on 13/11/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

public extension ObservableType {
    /**
     Applies a timeout policy for each element in the observable sequence. If the next element isn't received within the specified timeout duration starting from its predecessor, a TimeoutError is propagated to the observer.

     - seealso: [timeout operator on reactivex.io](http://reactivex.io/documentation/operators/timeout.html)

     - parameter dueTime: Maximum duration between values before a timeout occurs.
     - parameter scheduler: Scheduler to run the timeout timer on.
     - returns: An observable sequence with a `RxError.timeout` in case of a timeout.
     */
    func timeout(_ dueTime: RxTimeInterval, scheduler: SchedulerType)
        -> Observable<Element>
    {
        Timeout(source: asObservable(), dueTime: dueTime, other: Observable.error(RxError.timeout), scheduler: scheduler)
    }

    /**
     Applies a timeout policy for each element in the observable sequence, using the specified scheduler to run timeout timers. If the next element isn't received within the specified timeout duration starting from its predecessor, the other observable sequence is used to produce future messages from that point on.

     - seealso: [timeout operator on reactivex.io](http://reactivex.io/documentation/operators/timeout.html)

     - parameter dueTime: Maximum duration between values before a timeout occurs.
     - parameter other: Sequence to return in case of a timeout.
     - parameter scheduler: Scheduler to run the timeout timer on.
     - returns: The source sequence switching to the other sequence in case of a timeout.
     */
    func timeout<Source: ObservableConvertibleType>(_ dueTime: RxTimeInterval, other: Source, scheduler: SchedulerType)
        -> Observable<Element> where Element == Source.Element
    {
        Timeout(source: asObservable(), dueTime: dueTime, other: other.asObservable(), scheduler: scheduler)
    }
}

private final class TimeoutSink<Observer: ObserverType>: Sink<Observer>, LockOwnerType, ObserverType {
    typealias Element = Observer.Element
    typealias Parent = Timeout<Element>

    private let parent: Parent

    let lock = RecursiveLock()

    private let timerD = SerialDisposable()
    private let subscription = SerialDisposable()

    private var id = 0
    private var switched = false

    init(parent: Parent, observer: Observer, cancel: Cancelable) {
        self.parent = parent
        super.init(observer: observer, cancel: cancel)
    }

    func run() -> Disposable {
        let original = SingleAssignmentDisposable()
        subscription.disposable = original

        createTimeoutTimer()

        original.setDisposable(parent.source.subscribe(self))

        return Disposables.create(subscription, timerD)
    }

    func on(_ event: Event<Element>) {
        switch event {
        case .next:
            var onNextWins = false

            lock.performLocked {
                onNextWins = !self.switched
                if onNextWins {
                    self.id = self.id &+ 1
                }
            }

            if onNextWins {
                forwardOn(event)
                createTimeoutTimer()
            }
        case .error, .completed:
            var onEventWins = false

            lock.performLocked {
                onEventWins = !self.switched
                if onEventWins {
                    self.id = self.id &+ 1
                }
            }

            if onEventWins {
                forwardOn(event)
                dispose()
            }
        }
    }

    private func createTimeoutTimer() {
        if timerD.isDisposed {
            return
        }

        let nextTimer = SingleAssignmentDisposable()
        timerD.disposable = nextTimer

        let disposeSchedule = parent.scheduler.scheduleRelative(id, dueTime: parent.dueTime) { state in

            var timerWins = false

            self.lock.performLocked {
                self.switched = (state == self.id)
                timerWins = self.switched
            }

            if timerWins {
                self.subscription.disposable = self.parent.other.subscribe(self.forwarder())
            }

            return Disposables.create()
        }

        nextTimer.setDisposable(disposeSchedule)
    }
}

private final class Timeout<Element>: Producer<Element> {
    fileprivate let source: Observable<Element>
    fileprivate let dueTime: RxTimeInterval
    fileprivate let other: Observable<Element>
    fileprivate let scheduler: SchedulerType

    init(source: Observable<Element>, dueTime: RxTimeInterval, other: Observable<Element>, scheduler: SchedulerType) {
        self.source = source
        self.dueTime = dueTime
        self.other = other
        self.scheduler = scheduler
    }

    override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == Element {
        let sink = TimeoutSink(parent: self, observer: observer, cancel: cancel)
        let subscription = sink.run()
        return (sink: sink, subscription: subscription)
    }
}
