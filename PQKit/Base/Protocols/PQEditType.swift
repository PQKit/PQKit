//
//  EditType.swift
//  SmartMore
//
//  Created by 盘国权 on 2019/4/14.
//  Copyright © 2019 pgq. All rights reserved.
//

import Foundation

public protocol PQEditType { }

fileprivate struct EditTypeKeys {
    static var isOnline = "PQEditType.isOnline"
    static var isOn = "PQEditType.isOn"
    static var isSelected = "PQEditType.isSelected"
    static var isEdit = "PQEditType.isEdit"
}

public extension PQEditType {
    
    
    var isOnline: Bool {
        get {
            guard let value = objc_getAssociatedObject(self, &EditTypeKeys.isOnline) as? Bool else {
                let isOnline = false
                objc_setAssociatedObject(self, &EditTypeKeys.isOnline, isOnline, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return isOnline
            }
            return value
        }
        set {
            objc_setAssociatedObject(self, &EditTypeKeys.isOnline, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var isOn: Bool {
        get {
            guard let value = objc_getAssociatedObject(self, &EditTypeKeys.isOn) as? Bool else {
                let isOn = false
                objc_setAssociatedObject(self, &EditTypeKeys.isOn, isOn, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return isOn
            }
            return value
        }
        set {
            objc_setAssociatedObject(self, &EditTypeKeys.isOn, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var isSelected: Bool {
        get {
            guard let value = objc_getAssociatedObject(self, &EditTypeKeys.isSelected) as? Bool else {
                let isSelected = false
                objc_setAssociatedObject(self, &EditTypeKeys.isSelected, isSelected, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return isSelected
            }
            return value
        }
        set {
            objc_setAssociatedObject(self, &EditTypeKeys.isSelected, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var isEdit: Bool {
        get {
            guard let value = objc_getAssociatedObject(self, &EditTypeKeys.isEdit) as? Bool else {
                let isEdit = false
                objc_setAssociatedObject(self, &EditTypeKeys.isEdit, isEdit, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return isEdit
            }
            return value
        }
        set {
            objc_setAssociatedObject(self, &EditTypeKeys.isEdit, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}
