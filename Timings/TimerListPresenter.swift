import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class TimerListPresenter {
    let eventProvider: TimerListEventProvider
    
    let disposeBag = DisposeBag()
    
    private var timersItems: Observable<[TableItem]>
    private var timersSection: Observable<SectionModel<String, TableItem>>
    private var addTimerSection: Observable<SectionModel<String, TableItem>>
    var tableItems: Observable<[SectionModel<String, TableItem>]>?
    
    init(eventProvider: TimerListEventProvider) {
        self.eventProvider = eventProvider
        
        timersItems = eventProvider.addTimerTapped.scan([], accumulator: { (oldValue, _) -> [TableItem] in
            var newItems = oldValue
            newItems.append(TableItem(reuseIdentifier: "TimerCell", title: "Totes a timer"))
            return newItems
        }).startWith([])
            .debug("timers rows")
        
        addTimerSection = eventProvider.viewDidLoad.map({ (_) -> SectionModel<String, TableItem> in
            return SectionModel(model: "", items: [TableItem(reuseIdentifier: "AddTimerCell", title: "Add timer")])
        }).debug("add timer")
        
        timersSection = timersItems.map({ (items) -> SectionModel<String, TableItem> in
            return SectionModel(model: "Timers", items: items)
        }).debug("timers section")
        
        tableItems = Observable.combineLatest([timersSection, addTimerSection]).debug("merged items")
    }
}
