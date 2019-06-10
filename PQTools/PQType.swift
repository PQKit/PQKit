
/*
 如果优雅的给一个类进行扩展 2 3 顺序可换
 1、新建一个自己的协议
 2、新建一个自己的结构体或者新建一个自己的类 final class ，并且继承于自己的协议
 3、为你想要扩展的类新增一个成员变量，使用自己的结构体进行初始化
 4、为自己的协议实现方法
 */

import Foundation

public protocol PQType {
    associatedtype WrapperType
    var pq: WrapperType { get }
}


