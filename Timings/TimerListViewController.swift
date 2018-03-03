import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol EquatableSectionModelType: SectionModelType, Equatable where Item: Equatable {}

struct EquatableSectionModel<Section:Equatable, Item:Equatable>: EquatableSectionModelType {
    public var model: Section
    public var items: [Item]
    
    public init(model: Section, items: [Item]) {
        self.model = model
        self.items = items
    }
    
    init(original: EquatableSectionModel<Section, Item>, items: [Item]) {
        self.model = original.model
        self.items = items
    }
    
    static func ==(lhs: EquatableSectionModel, rhs: EquatableSectionModel) -> Bool {
        return lhs.model == rhs.model &&
        lhs.items == rhs.items
    }
}

class TimerListViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let viewDidLoadStream = PublishSubject<Void>()
    let addTimerTappedStream = PublishSubject<Void>()
    private lazy var eventProvider: TimerListEventProvider = {
        TimerListEventProvider(viewDidLoad: viewDidLoadStream.asObserver(),
                               addTimerTapped: addTimerTappedStream.asObserver())
    }()
    private lazy var presenter: TimerListPresenter = {
        return TimerListPresenter(eventProvider: eventProvider)
    }()
    
    @IBOutlet weak var timerListTableView: UITableView!
    
    let dataSource = RxTableViewSectionedReloadDataSource<EquatableSectionModel<String, TableItem>>(
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
        let dataSource = self.dataSource
        registerCells()
        presenter.tableItems?.bind(to: timerListTableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        timerListTableView.rx
            .itemSelected
            .map { indexPath in
                return (indexPath, dataSource[indexPath])
            }
            .filter({ (_, tableItem) -> Bool in
                return tableItem.reuseIdentifier == AddTimerCell.reuseIdentifier
            })
            .subscribe(onNext: { [weak self] pair in
                self?.addTimerTappedStream.onNext(())
            })
            .disposed(by: disposeBag)

    }
    
    private func registerCells() {
        timerListTableView.register(
            UINib(nibName: String(describing: AddTimerCell.self),
                  bundle: .main),
            forCellReuseIdentifier: AddTimerCell.reuseIdentifier)
        timerListTableView.register(TimerCell.self, forCellReuseIdentifier: TimerCell.reuseIdentifier)
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

extension ConfigurableCell where Self: UITableViewCell {
    static var reuseIdentifier: String { return String(describing: Self.self) }
}

