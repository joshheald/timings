import Foundation
import RxSwift

class TimerListPresenter {
    let eventProvider: TimerListEventProvider
    
    let disposeBag = DisposeBag()
    
    private var tableItems: BehaviorSubject<[TableItem]>
    let tableItemStream: Observable<[TableItem]>
    
    init(eventProvider: TimerListEventProvider) {
        self.eventProvider = eventProvider
        tableItems = BehaviorSubject(value: [])
        tableItemStream = tableItems.asObserver()
        eventProvider.viewDidLoad.subscribe(onNext: { [weak self] in
            self?.tableItems.onNext([TableItem(reuseIdentifier: "AddTimerCell", title: "Add timer")])
        }).disposed(by: disposeBag)
    }
    
    
}
