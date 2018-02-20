import Foundation
import RxTest
import RxSwift

extension TestScheduler {
    
    public struct TimeValue<E> {
        let time: UInt
        let value: E
    }
    
    public func hotObservable<E>(for values: [E], complete: Bool = false) -> Observable<E> {
        var events = values.map { value in next(0, value) }
        if complete {
            events.append(completed(0))
        }
        
        return createHotObservable(events).asObservable()
    }
    
    public func hotObservable<E>(forTimeValues timeValues: [(UInt,E)], complete: Bool = false) -> Observable<E> {
        let events = convertToTimeEvents(timeValues: timeValues)
        return createHotObservable(events).asObservable()
    }
    
    public func observer<T>(for observable: Observable<T>, disposeBag: DisposeBag) -> TestableObserver<T> {
        let observer = createObserver(T.self)
        observable.subscribe(observer).disposed(by: disposeBag)
        
        return observer
    }
    
    public func convertToTimeEvents<E>(timeValues: [(UInt,E)], complete: Bool = false) -> [Recorded<Event<E>>] {
        let timeValueEvents = timeValues.map { (key: UInt, value: E) in
            return TimeValue(time: key, value: value)
        }
        
        var events = timeValueEvents.map { timeValue in next(TestTime(timeValue.time), timeValue.value) }
        
        if complete {
            if let lastTimeValue = timeValueEvents.last {
                events.append(completed(TestTime(lastTimeValue.time+1)))
            } else {
                events.append(completed(0))
            }
        }
        
        return events
    }
    
}
