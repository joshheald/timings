import Foundation
import RxSwift

struct TimerListEventProvider {
    let viewDidLoad: Observable<Void>
//    let viewWillAppear: Observable<Void>
//    let viewDidAppear: Observable<Void>
//    let viewWillDisappear: Observable<Void>
    let addTimerTapped: Observable<Void>
}
