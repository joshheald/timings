import UIKit

class TimerCell: UITableViewCell, ConfigurableCell {
    func configure(with tableItem: TableItem) {
        textLabel?.text = tableItem.title
    }
}
