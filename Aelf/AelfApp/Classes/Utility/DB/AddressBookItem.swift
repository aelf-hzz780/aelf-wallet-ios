import UIKit
import WCDBSwift
import ObjectMapper

final class AddressBookItem: TableCodable, Mappable {
    
    var identifier: Int = 0
    var name: String?
    var creatTime: Date? = Date() // 创建时间
    var note: String? // 备注
    var address: String?
    var fc: String?
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = AddressBookItem
        
        case identifier
        case name
        case creatTime
        case note
        case address
        case fc
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(.identifier, isPrimary: true, isAutoIncrement: true)
        }
    }
    
    required init?(map: Map) {}
    
    init() {}
    
    func mapping(map: Map) {
        name <- map["name"]
        note <- map["note"]
        address <- map["address"]
        fc <- map["fc"]
    }
}
