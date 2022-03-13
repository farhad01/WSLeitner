//
//  File.swift
//  
//
//  Created by farhad jebelli on 12/03/2022.
//

import Foundation

class OrderedLinkedList<Element: Comparable>: Sequence {
    typealias NodeElement = Node<Element>
    fileprivate var first: NodeElement?
    private var last: NodeElement?
    
    var isEmpty: Bool {
        first == nil
    }
    
    init(list: [Element] = []) {
        list.forEach(insert)
    }
    
    
    func insert(_ element: Element) {
        if var node = first {
            while node.element > element {
                if let next = node.next {
                    node = next
                } else {
                    let node = NodeElement(element: element, privies: node, next: nil)
                    node.next = node
                    last = node
                    return
                }
            }
            if node.previous != nil {
                let newNode = NodeElement(element: element, privies: node.previous, next: node)
                node.previous = newNode
                newNode.previous?.next = newNode
            } else {
                let newNode = NodeElement(element: element, privies: nil, next: node)
                node.previous = newNode
                first = newNode
            }
        } else {
            first = NodeElement(element: element, privies: nil, next: nil)
            last = first
        }
    }
        
    func makeIterator() -> OrderedLinkedListIterator<Element> {
        OrderedLinkedListIterator<Element>(self)
    }
    
    fileprivate func remove(_ node: NodeElement) {
        if first === last, first === node {
            first = nil
            last = nil
            return
        }
        
        if first === node {
            let next = node.next
            first = next
            next?.previous = nil
            return
        }
        if last === node {
            let previous = node.previous
            last = previous
            previous?.next = nil
            return
        }
        
        if first !== node && last !== node {
            let next = node.next
            let previous = node.previous
            
            next?.previous = previous
            previous?.next = next
        }
    }
}

class OrderedLinkedListIterator<Element: Comparable>: IteratorProtocol {
    
    typealias NodeElement = Node<Element>
    
    private let list: OrderedLinkedList<Element>
    private let initialNode: NodeElement?
    private var node: NodeElement?
    
    internal init(_ list: OrderedLinkedList<Element>)
    {
        self.list = list
        self.initialNode = list.first
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
