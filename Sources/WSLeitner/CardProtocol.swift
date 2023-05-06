//
//  Created by farhad jebelli on 13/03/2022.
//

import Foundation

public enum Box: Int16, CaseIterable {
    case daily = 0
    case each3Day
    case each5Day
    case each10Day
    case each25Day
    case learned
    
    static var learningBoxes: [Box] {
        Self.allCases.filter {$0 != .learned}.reversed()
    }
}

public protocol CardProtocol: Identifiable, Comparable {
    var reviewTime: Date {get set}
    var box: Box {get set}
}

public extension CardProtocol {
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.reviewTime > rhs.reviewTime
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

public extension Box {
    var duration: TimeInterval {
        let day = TimeInterval(24 * 60 * 60)
        switch self {
        case .daily:
            return day
        case .each3Day:
            return 3 * day
        case .each5Day:
            return 5 * day
        case .each10Day:
            return 10 * day
        case .each25Day:
            return 25 * day
        case .learned:
            return 0
        }
    }
    
    var next: Box {
        switch self {
        case .daily:
            return .each3Day
        case .each3Day:
            return .each5Day
        case .each5Day:
            return .each10Day
        case .each10Day:
            return .each25Day
        case .each25Day:
            return .learned
        case .learned:
            return .learned
        }
    }
}
