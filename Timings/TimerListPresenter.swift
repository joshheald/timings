import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class TimerListPresenter {
    let eventProvider: TimerListEventProvider
    
    let disposeBag = DisposeBag()
    
    private var timersSection: Observable<SectionModel<String, TableItem>>
    private var addTimerSection = SectionModel(model: "", items: [TableItem(reuseIdentifier: "AddTimerCell", title: "Add timer")])
    var tableItems: Observable<[SectionModel<String, TableItem>]>?
    
    init(eventProvider: TimerListEventProvider) {
        self.eventProvider = eventProvider
        timersSection = eventProvider.addTimerTapped.scan(SectionModel<String, TableItem>(model: "Timers", items: []), accumulator: { (oldValue, _) in
            var newSection = oldValue
            newSection.items.append(TableItem(reuseIdentifier: "TimerCell", title: "Totes a timer"))
            return newSection
        })
        tableItems = timersSection.flatMap({ (timerSection) -> Observable<[SectionModel<String, TableItem>]> in
            return Observable.of([timerSection, self.addTimerSection])
        })
    }
}
