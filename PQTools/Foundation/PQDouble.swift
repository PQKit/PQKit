
import Foundation

public struct PQDouble<T>: PQType {
    public let pq: T
    public init(pq: T){
        self.pq = pq
    }
}

extension Double {
    public var pq: PQDouble<Double> {
        return PQDouble(pq: self)
    }
}

public extension PQDouble where WrapperType == Double {
    
    /// cn:把Double转化为摄氏度
    /// en:Double to Celcius
    ///
    /// - Returns: 摄氏度数据
    func toCelcius() -> Double {
        return (pq - 32.0) / 1.8
    }
    
    
}
