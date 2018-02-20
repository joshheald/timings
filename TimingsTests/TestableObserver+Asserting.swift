import Foundation
import RxSwift
import RxTest

extension TestableObserver where ElementType : Equatable {
    
    public func assertValues(_ values: [ElementType], using scheduler: TestScheduler, complete: Bool = false, start: Bool = true, file: StaticString = #file, line: UInt = #line) {
        if start {
            scheduler.start()
        }
        
        var expectedEvents = values.map { value in next(0, value)}
        if complete {
            expectedEvents.append(completed(0))
        }
        XCTAssertEqual(expectedEvents, self.events, file: file, line: line)
    }
    
    public func assertFirstValue(_ value: ElementType, using scheduler: TestScheduler, complete: Bool = false, file: StaticString = #file, line: UInt = #line) {
        scheduler.start()
        
        let expectedEvent = next(0, value)
        let recordedEvents: [Recorded<Event<ElementType>>] = self.events.first.map { [$0] } ?? []
        XCTAssertEqual([expectedEvent], recordedEvents, file: file, line: line)
    }
    
    public func assertLastValue(_ value: ElementType, using scheduler: TestScheduler, complete: Bool = false, start: Bool = true, file: StaticString = #file, line: UInt = #line) {
        if start {
            scheduler.start()
        }
        
        let expectedEvent = next(0, value)
        guard let recordedEvent: Recorded<Event<ElementType>> = self.events.last else {
            return XCTAssertEqual([expectedEvent.value], [], file: file, line: line)
        }
        XCTAssertEqual([expectedEvent.value], [recordedEvent.value], file: file, line: line)
    }
    
    public func assertTimeValues(_ timeValues: [(UInt, ElementType)], using scheduler: TestScheduler, complete: Bool = false, file: StaticString = #file, line: UInt = #line) {
        scheduler.start()
        
        let expectedEvents = scheduler.convertToTimeEvents(timeValues: timeValues, complete: complete)
        XCTAssertEqual(expectedEvents, self.events, file: file, line: line)
    }
    
}

extension TestableObserver {
    public func values(using scheduler: TestScheduler) -> [ElementType] {
        scheduler.start()
        return self.events.flatMap { $0.value.element }
    }
}
