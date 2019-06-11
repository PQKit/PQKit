//
//  PQViewModel.swift
//  SmartMore
//
//  Created by 盘国权 on 2019/4/1.
//  Copyright © 2019 pgq. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol PQViewModelType {
    associatedtype E
    
    var bag: DisposeBag { get }
    var items: Observable<[E]> { get }
    
    var itemsSubject: BehaviorRelay<[E]> { get }
}

open class PQViewModel<Element>: NSObject, PQViewModelType {
    public typealias E = Element
    
    open var bag = DisposeBag()
    public var items: Observable<[Element]> {
        return itemsSubject.asObservable().share(replay: 1)
    }
    
    public override init() {
        self.itemsSubject = BehaviorRelay<[Element]>(value: [])
    }
    
    public init(localItems: [Element]) {
        self.itemsSubject = BehaviorRelay<[Element]>(value: localItems)
    }
    
    public internal(set) var itemsSubject: BehaviorRelay<[Element]>
    open var lastIndex: Int?
    
    
    // MARK: - 提供一些默认的方法
    open func delete(_ index: Int) {
        var list = itemsSubject.value
        if index >= 0 && index < list.count {
            list.remove(at: index)
        }
        itemsSubject.accept(list)
    }
    
    open func append(_ item: Element) {
        var list = itemsSubject.value
        list.append(item)
        itemsSubject.accept(list)
    }
    
    open func insert(_ item: Element, at index: Int) {
        var list = itemsSubject.value
        list.insert(item, at: index)
        itemsSubject.accept(list)
    }
    
    open func refresh() {
        let list = itemsSubject.value
        itemsSubject.accept(list)
    }
    
    open func removeAll() {
        itemsSubject.accept([])
    }
    
    open func model(_ index: Int) throws -> Element {
        if index < itemsSubject.value.count && index > -1{
            return itemsSubject.value[index]
        }
        throw  NSError(domain: "不在范围内", code: -1, userInfo: nil)
    }
}

extension PQViewModel where Element: PQEditType {
    func singleSelected(_ index: Int) {
        var list = itemsSubject.value
        
        if let lastIndex = lastIndex {
            list[lastIndex].isSelected = false
        }
        
        list[index].isSelected = true
        lastIndex = index
        
        itemsSubject.accept(list)
    }
    
    func multipleSelected(_ index: Int) {
        var list = itemsSubject.value
        list[index].isSelected = !list[index].isSelected
        itemsSubject.accept(list)
    }
}


