import Foundation
import RxSwift
import RxTest

public func == <T: Equatable>(lhs: Recorded<Event<[T]>>, rhs: Recorded<Event<[T]>>) -> Bool {
    return lhs.time == rhs.time && lhs.value == rhs.value
}
