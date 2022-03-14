//
//  Created by farhad jebelli on 12/03/2022.
//

import XCTest
@testable import WSLeitner

class OrderedLinkedListTest: XCTestCase {
    
    func testInitializeWithArray() {
        let list = OrderedLinkedList<Int>(list: [1, 2, 3])
        
        XCTAssertEqual(Array(list), [3, 2, 1])
    }
    
    func testIsEmpty_whenEmpty() {
        let list = OrderedLinkedList<Int>()
        XCTAssertTrue(list.isEmpty)
    }
    
    func testIsEmpty_whenNotEmpty() {
        let list = OrderedLinkedList<Int>(list: [1])
        XCTAssertFalse(list.isEmpty)
    }

    func testListIsOrdered_whenInsertNode() throws {
        let list = OrderedLinkedList<Int>()
        let random = [5,1,3,4,2]
        random.forEach(list.insert(_:))
        
        XCTAssertEqual(Array(list), [5, 4, 3, 2, 1])
        
    }
    
    func testIterator() {
        let list = OrderedLinkedList<Int>(list: [1,2,3])
        
        let iterator = list.makeIterator()
        
        let results = [iterator.next(), iterator.next(), iterator.next(), iterator.next()]
        
        XCTAssertEqual(results, [3, 2, 1, nil])
        
    }
    
    func testElementRemoves_whenRemovingElement() throws {
        
        var list = OrderedLinkedList<Int>(list: [1, 2, 3])
        var iterator = list.makeIterator()
        let _ = iterator.next()
        iterator.remove()
        XCTAssertEqual(Array(list), [2, 1])
        
        list = OrderedLinkedList<Int>(list: [1, 2, 3])
        iterator = list.makeIterator()
        let _ = iterator.next()
        let _ = iterator.next()
        iterator.remove()
        XCTAssertEqual(Array(list), [3, 1])
        
        list = OrderedLinkedList<Int>(list: [1])
        iterator = list.makeIterator()
        let _ = iterator.next()
        iterator.remove()
        XCTAssertEqual(Array(list), [])
    }
}
