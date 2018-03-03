import Foundation

struct TableItem : Equatable {
    let reuseIdentifier: String
    let title: String
    
    static func ==(lhs: TableItem, rhs: TableItem) -> Bool {
        return lhs.reuseIdentifier == rhs.reuseIdentifier &&
        lhs.title == rhs.title
    }
}
