import UIKit

class AddTimerCell: UITableViewCell, ConfigurableCell {
    @IBOutlet weak var label: UILabel!
    static var reuseIdentifier: String { return String(describing: self.self) }
    
    func configure(with tableItem: TableItem) {
        label.text = tableItem.title
    }
}
