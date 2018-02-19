import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class TimerListPresenter {
    let eventProvider: TimerListEventProvider
    
    let disposeBag = DisposeBag()
    
    let tableItems: BehaviorSubject<[SectionModel<String, TableItem>]>
    
    init(eventProvider: TimerListEventProvider) {
        self.eventProvider = eventProvider
        tableItems = BehaviorSubject(value: [])
        eventProvider.viewDidLoad.subscribe(onNext: { [weak self] in
            self?.tableItems.onNext([SectionModel(model: "", items: [TableItem(reuseIdentifier: "AddTimerCell", title: "Add timer")])])
        }).disposed(by: disposeBag)
    }
    
    
}
