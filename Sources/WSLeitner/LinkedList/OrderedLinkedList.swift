//
//  File.swift
//  
//
//  Created by farhad jebelli on 12/03/2022.
//

import Foundation

protocol ListItemRemovable {
    func remove()
}

final class OrderedLinkedList<Element: Comparable>: Sequence {
    typealias NodeElement = Node<Element>
    private var firstNode: NodeElement?
    private var lastNode: NodeElement?
    
    var first: Element? { firstNode?.element }
    var last: Element? { lastNode?.element }
    var isEmpty: Bool { firstNode == nil }
    
    init(list: [Element] = []) {
        list.forEach(insert)
    }
    
    func insert(_ element: Element) {
        if var node = firstNode {
            while node.element > element {
                if let next = node.next {
                    node = next
                } else {
                    let newNode = NodeElement(element: element, privies: node, next: nil)
                    node.next = newNode
                    lastNode = newNode
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
                firstNode = newNode
            }
        } else {
            firstNode = NodeElement(element: element, privies: nil, next: nil)
            lastNode = firstNode
        }
    }
    
    func makeIterator() -> OrderedLinkedListIterator<Element> {
        OrderedLinkedListIterator<Element>(self, initialNode: firstNode)
    }
    
    func remove(_ element: Element) {
        if let node = findNode(element) {
            remove(node)
        }
    }
    
    func remove(_ node: NodeElement) {
        if firstNode === lastNode, firstNode === node {
            firstNode = nil
            lastNode = nil
            return
        }
        
        if firstNode === node {
            let next = node.next
            firstNode = next
            next?.previous = nil
            return
        }
        if lastNode === node {
            let previous = node.previous
            lastNode = previous
            previous?.next = nil
            return
        }
        
        if firstNode !== node && lastNode !== node {
            let next = node.next
            let previous = node.previous
            
            next?.previous = previous
            previous?.next = next
        }
    }
    
    private func findNode(_ element: Element, node: NodeElement? = nil) -> NodeElement? {
        if let node = node ?? firstNode {
            if node.element == element  {
                return node
            }
            if node !== lastNode {
                return findNode(element, node: node.next)
            }
        }
        return nil
    }
}
