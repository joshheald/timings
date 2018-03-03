import XCTest
@testable import Timings
import RxSwift
import RxTest

class TimingsListPresenterTests: XCTestCase {
    var disposeBag = DisposeBag()
    var scheduler: TestScheduler!
    var mockEventProvider: TimerListEventProviding!
    
    var sut: TimerListPresenter!
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    func test_viewDidLoad_NoStoredTimers_EmptyTimerSectionAndAddTimerButtonAtEndOfTable() {
        let viewDidLoad = scheduler.createHotObservable([next(100, ())])
        let results = scheduler.createObserver(([EquatableSectionModel<String, TableItem>]).self)
        mockEventProvider = MockTimerListEventProvider(viewDidLoad: viewDidLoad.asObservable(), addTimerTapped: Observable.never())
        sut = TimerListPresenter(eventProvider: mockEventProvider)
        scheduler.scheduleAt(0) { [unowned self] in
            self.sut.tableItems?.subscribe(results).disposed(by: self.disposeBag)
        }
        scheduler.start()
        let expected = next(100, [
            EquatableSectionModel(model: "Timers", items: []),
            EquatableSectionModel(model: "", items: [TableItem(reuseIdentifier: "AddTimerCell", title: "Add timer")])
            ])
        XCTAssert(results.events.first! == expected)
    }
    
}

struct MockTimerListEventProvider: TimerListEventProviding {
    var viewDidLoad: Observable<Void>
    var addTimerTapped: Observable<Void>
}
