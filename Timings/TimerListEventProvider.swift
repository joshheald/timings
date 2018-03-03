import Foundation
import RxSwift

protocol TimerListEventProviding {
    var viewDidLoad: Observable<Void> { get }
    var addTimerTapped: Observable<Void> { get }
}

struct TimerListEventProvider: TimerListEventProviding {
    var viewDidLoad: Observable<Void>
//    let viewWillAppear: Observable<Void>
//    let viewDidAppear: Observable<Void>
//    let viewWillDisappear: Observable<Void>
    var addTimerTapped: Observable<Void>
}
