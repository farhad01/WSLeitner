//
//  Created by farhad jebelli on 14/03/2022.
//

import Foundation

public protocol CurrentDateProviding {
    var now: Date {get}
}

public struct CurrentDateProvider: CurrentDateProviding {
    public init() {}
    public var now: Date {
        Date()
    }
}
