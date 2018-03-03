import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class TimerListPresenter {
    let eventProvider: TimerListEventProvider
    
    let disposeBag = DisposeBag()
    
    private var timersItems: Observable<[TableItem]>
    private var timersSection: Observable<EquatableSectionModel<String, TableItem>>
    private var addTimerSection: Observable<EquatableSectionModel<String, TableItem>>
    var tableItems: Observable<[EquatableSectionModel<String, TableItem>]>?
    
    init(eventProvider: TimerListEventProvider) {
        self.eventProvider = eventProvider
        
        timersItems = eventProvider.addTimerTapped
            .scan([], accumulator: { (oldValue, _) -> [TableItem] in
                var newItems = oldValue
                newItems.append(TableItem(reuseIdentifier: "TimerCell", title: "Totes a timer"))
                return newItems
            })
            .startWith([])
            .debug("timers rows")
        
        addTimerSection = eventProvider.viewDidLoad
            .map({ (_) -> EquatableSectionModel<String, TableItem> in
                return EquatableSectionModel(model: "", items: [TableItem(reuseIdentifier: "AddTimerCell", title: "Add timer")])
            })
            .debug("add timer")
        
        timersSection = timersItems
            .map({ (items) -> EquatableSectionModel<String, TableItem> in
                return EquatableSectionModel(model: "Timers", items: items)
            })
            .debug("timers section")
        
        tableItems = Observable.combineLatest([timersSection, addTimerSection])
    }
}
