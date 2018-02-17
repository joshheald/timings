import UIKit
import RxSwift
import RxCocoa

class TimerListViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let viewDidLoadStream = PublishSubject<Void>()
    private lazy var eventProvider: TimerListEventProvider = {
        TimerListEventProvider(viewDidLoad: viewDidLoadStream.asObserver())
    }()
    private lazy var presenter: TimerListPresenter = {
        return TimerListPresenter(eventProvider: eventProvider)
    }()
    
    @IBOutlet weak var timerListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewDidLoadStream.onNext(())
    }

    private func setupTableView() {
        registerCells()
        presenter.tableItemStream.bind(to: timerListTableView.rx.items) { (tableView, row, element) in
            if let cell = tableView.dequeueReusableCell(withIdentifier: element.reuseIdentifier) {
                if let configurableCell = cell as? AddTimerCell {
                    configurableCell.configureCell(tableItem: element)
                }
                return cell
            } else {
                return UITableViewCell()
            }
            }
            .disposed(by: disposeBag)
    }
    
    private func registerCells() {
        timerListTableView.register(
            UINib(nibName: String(describing: AddTimerCell.self),
                  bundle: .main),
            forCellReuseIdentifier: AddTimerCell.reuseIdentifier)
    }
}

protocol ConfigurableCell where Self : UITableViewCell {
    func configureCell(tableItem: TableItem)
}

