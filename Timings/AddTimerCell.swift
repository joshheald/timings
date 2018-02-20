import UIKit

class AddTimerCell: UITableViewCell, ConfigurableCell {
    @IBOutlet weak var label: UILabel!
    
    func configure(with tableItem: TableItem) {
        label.text = tableItem.title
    }
}
