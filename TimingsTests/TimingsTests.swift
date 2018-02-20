//
//  TimingsTests.swift
//  TimingsTests
//
//  Created by Josh Heald on 16/02/2018.
//  Copyright © 2018 FanDuel. All rights reserved.
//

import XCTest
@testable import Timings
import RxSwift
import RxTest
//import RxCocoa
//import RxDataSources
class TimingsTests: XCTestCase {
    
    var disposeBag = DisposeBag()
    var scheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    func test_viewDidLoad_AddButtonItemIsShown() {
        let viewDidLoadStream = scheduler.hotObservable(for: [()])
        let eventProvider = TimerListEventProvider(viewDidLoad: viewDidLoadStream, addTimerTapped: Observable.never())
        let presenter = TimerListPresenter(eventProvider: eventProvider)
        let results = scheduler.observer(for: presenter.tableItems, disposeBag: disposeBag)
        results.assertFirstValue([SectionViewModel(model: "", items: [TableItem(reuseIdentifier: AddTimerCell.reuseIdentifier, title: "Add Timer")])])
    }
    
}
