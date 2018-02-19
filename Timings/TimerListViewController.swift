import UIKit
import RxSwift
import RxCocoa
import RxDataSources

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
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, TableItem>>(
        configureCell: { (_, tableview, indexPath, element) in
            if let cell = tableview.dequeueReusableCell(withIdentifier: element.reuseIdentifier) {
                (cell as? ConfigurableCell)?.configure(with: element)
                return cell
            }
            return UITableViewCell()
    },
        titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
    }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewDidLoadStream.onNext(())
    }

    private func setupTableView() {
        registerCells()
        presenter.tableItems.bind(to: timerListTableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    private func registerCells() {
        timerListTableView.register(
            UINib(nibName: String(describing: AddTimerCell.self),
                  bundle: .main),
            forCellReuseIdentifier: AddTimerCell.reuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

protocol ConfigurableCell {
    func configure(with tableItem: TableItem)
}

