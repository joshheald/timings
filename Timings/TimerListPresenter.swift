import Foundation
import RxSwift
import RxCocoa

struct SectionViewModel<Section: Equatable, ItemType: Equatable> : Equatable {
    
    var model: Section
    var items: [ItemType]
    
    init(model: Section, items: [ItemType]) {
        self.model = model
        self.items = items
    }
    
    static func ==(lhs: SectionViewModel<Section, ItemType>, rhs: SectionViewModel<Section, ItemType>) -> Bool {
        return lhs.model == rhs.model
        && lhs.items == rhs.items
    }
}

class TimerListPresenter {
    let eventProvider: TimerListEventProvider
    
    let disposeBag = DisposeBag()
    
    private var timersItems: Observable<[TableItem]>
    private var timersSection: Observable<SectionViewModel<String, TableItem>>
    private var addTimerSection: Observable<SectionViewModel<String, TableItem>>
    var tableItems: Observable<[SectionViewModel<String, TableItem>]>
    
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
            .map({ (_) -> SectionViewModel<String, TableItem> in
                return SectionViewModel(model: "", items: [TableItem(reuseIdentifier: "AddTimerCell", title: "Add timer")])
            })
            .debug("add timer")
        
        timersSection = timersItems
            .map({ (items) -> SectionViewModel<String, TableItem> in
                return SectionViewModel(model: "Timers", items: items)
            })
            .debug("timers section")
        
        tableItems = Observable.combineLatest([timersSection, addTimerSection])
    }
}
