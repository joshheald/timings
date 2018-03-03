import Foundation
import RxDataSources

protocol EquatableSectionModelType: SectionModelType, Equatable where Item: Equatable {}

struct EquatableSectionModel<Section:Equatable, ItemType:Equatable> {
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

extension EquatableSectionModel
: EquatableSectionModelType {
    public typealias Identity = Section
    public typealias Item = ItemType
    
    public var identity: Section {
        return model
    }
}
