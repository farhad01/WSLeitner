//
//  Created by farhad jebelli on 12/03/2022.
//

import Foundation

public protocol LeitnerCardDelegate: AnyObject {
    associatedtype Card: CardProtocol
    func update(card: Card)
}

public final class Leitner<Delegate: LeitnerCardDelegate> {
    
    public typealias Card = Delegate.Card
    
    private var boxes: [Box: OrderedLinkedList<Card>]
    private var currentDateProviding: CurrentDateProviding
    
    public weak var delegate: Delegate?
    
    public init(cards: [Card], now: CurrentDateProviding = CurrentDateProvider()) {
        boxes = Dictionary(grouping: cards, by: \.box)
            .mapValues(OrderedLinkedList.init)
        for type in Box.allCases {
            if boxes[type] == nil {
                boxes[type] = OrderedLinkedList()
            }
        }
        self.currentDateProviding = now
    }
    
    public func next() -> LeitnerSession<Card>? {
        let boxTypes: [Box] = [.each25Day, .each10Day, .each5Day, .each3Day, .daily]
        for type in boxTypes {
            if let iterator = boxes[type]?.makeIterator(),
               let card = iterator.next(),
               let successList = boxes[type.next],
               let failList = boxes[.daily],
               card.reviewTime <= currentDateProviding.now.advanced(by: -type.duration) || type == .daily {
                return LeitnerSession(
                    card: card) { [currentDateProviding, weak delegate] in
                        var card = card
                        card.box = type.next
                        card.reviewTime = currentDateProviding.now
                        
                        delegate?.update(card: card)
                        iterator.remove()
                        successList.insert(card)
                    } onFail: { [currentDateProviding, weak delegate] in
                        var card = card
                        card.box = .daily
                        card.reviewTime = currentDateProviding.now
                        
                        delegate?.update(card: card)
                        iterator.remove()
                        failList.insert(card)
                    }
            }
        }
        return nil
    }
}

public final class LeitnerSession<Card: CardProtocol> {
    
    public let card: Card
    private let onSuccess: () -> Void
    private let onFail: () -> Void
    
    init(card: Card, onSuccess: @escaping () -> Void, onFail: @escaping () -> Void) {
        self.card = card
        self.onSuccess = onSuccess
        self.onFail = onFail
    }
    
    public func success() {
        onSuccess()
    }
    
    public func failure() {
        onFail()
    }
}
