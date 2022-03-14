//
//  Created by farhad jebelli on 14/03/2022.
//

import Foundation

class OrderedLinkedListIterator<Element: Comparable>: IteratorProtocol, ListItemRemovable {
    
    typealias NodeElement = Node<Element>
    
    private let list: OrderedLinkedList<Element>
    private let initialNode: NodeElement?
    private var node: NodeElement?
    
    internal init(_ list: OrderedLinkedList<Element>, initialNode: NodeElement?)
    {
        self.list = list
        self.initialNode = initialNode
    }
    
    func next() -> Element? {
        if node == nil {
            node = initialNode
        } else {
            node = node?.next
        }
        return node?.element
    }
    
    func remove() {
        if let node = node {
            list.remove(node)
        }
    }
}
