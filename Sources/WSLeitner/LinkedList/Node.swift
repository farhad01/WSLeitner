//
//  Created by farhad jebelli on 12/03/2022.
//

import Foundation

class Node<Element> {
    
    let element: Element
    var previous: Node?
    var next: Node?
    
    init(element: Element, privies: Node?, next: Node?) {
        self.element = element
        self.previous = privies
        self.next = next
        
    }
}
