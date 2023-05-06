//
//  Created by farhad jebelli on 12/03/2022.
//

import XCTest
@testable import WSLeitner

final class WSLeitnerTests: XCTestCase {
    
    func testPicksCardFromEach25DayBox() throws {
        
        let dateProvider = TestDateProvider(now: Date())
        
        let initCards = [TestCard(reviewTime: dateProvider.createDate(daysAgo: 1), box: .daily, id: 0),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 3), box: .each3Day, id: 1),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 5), box: .each5Day, id: 2),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 10), box: .each10Day, id: 3),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 25), box: .each25Day, id: 4)]
        
        let leitner = Leitner<TestDelegate>(cards: initCards, now: dateProvider)
        let session = leitner.next()
        XCTAssertEqual(session?.card.id, 4)
    }
    
    func testPicksCardFromEach10DayBox() throws {
        
        let dateProvider = TestDateProvider(now: Date())
        
        let initCards = [TestCard(reviewTime: dateProvider.createDate(daysAgo: 1), box: .daily, id: 0),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 3), box: .each3Day, id: 1),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 5), box: .each5Day, id: 2),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 10), box: .each10Day, id: 3),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 1), box: .each25Day, id: 4)]
        
        let leitner = Leitner<TestDelegate>(cards: initCards, now: dateProvider)
        let session = leitner.next()
        XCTAssertEqual(session?.card.id, 3)
    }
    
    func testPicksCardFromEach5DayBox() throws {
        
        let dateProvider = TestDateProvider(now: Date())
        
        let initCards = [TestCard(reviewTime: dateProvider.createDate(daysAgo: 1), box: .daily, id: 0),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 3), box: .each3Day, id: 1),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 5), box: .each5Day, id: 2),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 1), box: .each10Day, id: 3),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 1), box: .each25Day, id: 4)]
        
        let leitner = Leitner<TestDelegate>(cards: initCards, now: dateProvider)
        let session = leitner.next()
        XCTAssertEqual(session?.card.id, 2)
    }
    
    func testPicksCardFromEach3DayBox() throws {
        
        let dateProvider = TestDateProvider(now: Date())
        
        let initCards = [TestCard(reviewTime: dateProvider.createDate(daysAgo: 1), box: .daily, id: 0),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 3), box: .each3Day, id: 1),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 1), box: .each5Day, id: 2),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 1), box: .each10Day, id: 3),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 1), box: .each25Day, id: 4)]
        
        let leitner = Leitner<TestDelegate>(cards: initCards, now: dateProvider)
        let session = leitner.next()
        XCTAssertEqual(session?.card.id, 1)
    }
    
    func testPicksCardFromEachDayBox() throws {
        
        let dateProvider = TestDateProvider(now: Date())
        
        let initCards = [TestCard(reviewTime: dateProvider.createDate(daysAgo: 1), box: .daily, id: 0),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 1), box: .each3Day, id: 1),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 1), box: .each5Day, id: 2),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 1), box: .each10Day, id: 3),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 1), box: .each25Day, id: 4)]
        
        let leitner = Leitner<TestDelegate>(cards: initCards, now: dateProvider)
        let session = leitner.next()
        XCTAssertEqual(session?.card.id, 0)
    }
    
    func testPicksCardOrderIsFromOldToNew() throws {
        let dateProvider = TestDateProvider(now: Date())
        
        let initCards = [TestCard(reviewTime: dateProvider.createDate(daysAgo: 1), box: .daily, id: 0),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 2), box: .daily, id: 1),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 3), box: .daily, id: 2),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 4), box: .daily, id: 3),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 5), box: .daily, id: 4)]
            .shuffled()

        let leitner = Leitner<TestDelegate>(cards: initCards, now: dateProvider)
        
        var session = leitner.next()
        XCTAssertEqual(session?.card.id, 4)
        
        session?.failure()
        
        session = leitner.next()
        XCTAssertEqual(session?.card.id, 3)
        session?.failure()
        
        session = leitner.next()
        XCTAssertEqual(session?.card.id, 2)
        session?.failure()
        
        session = leitner.next()
        XCTAssertEqual(session?.card.id, 1)
        session?.failure()
        
        session = leitner.next()
        XCTAssertEqual(session?.card.id, 0)
    }
    
    func testMovingCardToNextBoxIsCorrect_whenSuccess() throws {
        let dateProvider = TestDateProvider(now: Date())
        
        let initCards = [TestCard(reviewTime: dateProvider.createDate(daysAgo: 1), box: .daily, id: 0)]
        
        let leitner = Leitner<TestDelegate>(cards: initCards, now: dateProvider)
        var session = leitner.next()
        XCTAssertEqual(session?.card.id, 0)
        session?.success()
        session = leitner.next()
        XCTAssertNil(session)
        
        dateProvider.now = Date().advanced(by: .threeDays)
        session = leitner.next()
        XCTAssertEqual(session?.card.id, 0)
    }
    
    func testMovingCardToNextBoxIsCorrect_whenFail() throws {
        let dateProvider = TestDateProvider(now: Date())
        
        let initCards = [TestCard(reviewTime: dateProvider.createDate(daysAgo: 1), box: .daily, id: 0)]
        
        let leitner = Leitner<TestDelegate>(cards: initCards, now: dateProvider)
        var session = leitner.next()
        XCTAssertEqual(session?.card.id, 0)
        session?.failure()
        session = leitner.next()
        XCTAssertEqual(session?.card.id, 0)
    }
    
    func testDelegateCalls_whenSuccess() throws {
        let expectation = expectation(description: "delegate callback")
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true
        
        let dateProvider = TestDateProvider(now: Date())
        
        let initCards = [TestCard(reviewTime: dateProvider.createDate(daysAgo: 3), box: .each3Day, id: 0)]
        
        let leitner = Leitner<TestDelegate>(cards: initCards, now: dateProvider)
        let delegate = TestDelegate(callback: { card in
            if card.box == .each5Day {
                expectation.fulfill()
            }
        })
        leitner.delegate = delegate
        let session = leitner.next()
        session?.success()
        
        waitForExpectations(timeout: 0)
    }
    
    func testDelegateCalls_whenFail() throws {
        let expectation = expectation(description: "delegate callback")
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true
        
        let dateProvider = TestDateProvider(now: Date())
        
        let initCards = [TestCard(reviewTime: dateProvider.createDate(daysAgo: 3), box: .each3Day, id: 0)]
        
        let leitner = Leitner<TestDelegate>(cards: initCards, now: dateProvider)
        let delegate = TestDelegate(callback: { card in
            if card.box == .daily {
                expectation.fulfill()
            }
        })
        leitner.delegate = delegate
        let session = leitner.next()
        session?.failure()
        
        waitForExpectations(timeout: 0)
    }
    
    func testUpcomingCards() throws {
        let dateProvider = TestDateProvider(now: Date())
        let initCards = [TestCard(reviewTime: dateProvider.createDate(daysAgo: 1), box: .daily, id: 0),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 5), box: .each5Day, id: 1),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 25), box: .each25Day, id: 2),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 4), box: .learned, id: 3),
                         TestCard(reviewTime: dateProvider.createDate(daysAgo: 10), box: .each10Day, id: 4)]
        let leitner = Leitner<TestDelegate>(cards: initCards, now: dateProvider)
        
        let cards = leitner.upcomingCards(count: 3)
        let next = try XCTUnwrap(leitner.next()?.card.id)
        
        
        XCTAssertEqual(cards.map(\.id).first, next)
        XCTAssertEqual(cards.map(\.id), [2, 4, 1])
    }
}

private class TestDateProvider: CurrentDateProviding {
    var now: Date
    init(now: Date) {
        self.now = now
    }
    
    func tick() {
        now = now.advanced(by: 10)
    }
    
    func createDate(daysAgo n: Double) -> Date{
        now.advanced(by: -n * .oneDay)
    }
}

private struct TestCard: CardProtocol {
    var reviewTime: Date
    var box: Box
    var id: Int
}

private class TestDelegate: LeitnerCardDelegate {
    
    var callback: (TestCard) -> Void
    
    internal init(callback: @escaping (TestCard) -> Void) {
        self.callback = callback
    }
    
    func update(card: TestCard) {
        callback(card)
    }
}

extension TimeInterval {
    static var oneDay: Self {
        24 * 60 * 60
    }
    static var threeDays: Self {
        72 * 60 * 60
    }
}
