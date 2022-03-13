//
//  Created by farhad jebelli on 12/03/2022.
//

import XCTest
@testable import WSLeitner

final class WSLeitnerTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        //XCTAssertEqual(WSLeitner<TestCard>(), "Hello, World!")
    }
}

private struct TestCard: CardProtocol {    
    var reviewTime: Date
    var box: Int
    var id: Int
}
