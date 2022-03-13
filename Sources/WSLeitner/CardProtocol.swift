//
//  Created by farhad jebelli on 13/03/2022.
//

import Foundation

public protocol CardProtocol: Identifiable, Comparable {
    var reviewTime: Date {get}
    var box: Int {get}
}
extension CardProtocol {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.reviewTime < rhs.reviewTime
    }
}
