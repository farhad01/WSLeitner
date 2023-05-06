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
        
        
            if
                let card = upcomingCards(count: 1).first,
                let successList = boxes[card.box.next],
                let failList = boxes[.daily],
                let cardList = boxes[card.box],
                card.reviewTime <= currentDateProviding.now.advanced(by: -card.box.duration) || card.box == .daily {
                
                return LeitnerSession(
                    card: card) { [currentDateProviding, weak delegate] in
                        var card = card
                        card.box = card.box.next
                        card.reviewTime = currentDateProviding.now
                        
                        delegate?.update(card: card)
                        cardList.remove(card)
                        successList.insert(card)
                    } onFail: { [currentDateProviding, weak delegate] in
                        var card = card
                        card.box = .daily
                        card.reviewTime = currentDateProviding.now
                        
                        delegate?.update(card: card)
                        cardList.remove(card)
                        failList.insert(card)
                    }
            }
        
        return nil
    }
    
    public func upcomingCards(count: Int) -> [Card] {
        var cards = [Card]()
    main: for box in Box.learningBoxes {
        if let iterator = boxes[box] {
            for card in iterator {
                if card.reviewTime <= currentDateProviding.now.advanced(by: -box.duration) || box == .daily {
                    cards.append(card)
                    if cards.count == count {break main}
                }
                
            }
        }
    }
        return cards
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
