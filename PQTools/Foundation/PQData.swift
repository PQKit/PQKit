

import Foundation

public struct PQData<T>: PQType {
    public let pq: T
    public init(pq: T){
        self.pq = pq
    }
}

extension Data {
    public var pq: PQData<Data> {
        return PQData(pq: self)
    }
}

public extension PQData where WrapperType == Data {
    /// 把data转为Uint8数组
    /// to UInt8 array
    ///
    /// - Returns: 数组
    func toUInt8() -> [UInt8]{
        var byteArray = [UInt8](repeating: 0, count: pq.count)
        pq.copyBytes(to: &byteArray, count: pq.count)
        return byteArray
    }
    
    /// 把Data转为字符串
    /// to hex string
    ///
    /// - Returns: 字符串
    func toHex() -> String {
        var hex: String = ""
        for i in 0..<toUInt8().count {
            hex.append(NSString(format: "%02x", pq[i]) as String)
            if (i + 1) % 4 == 0 { hex.append(" ") }
        }
        return hex
    }
    
    /// 提取 data
    /// sub data with location and length
    ///
    /// - Parameters:
    ///   - loc: 开始位置
    ///   - len: 结束位置
    /// - Returns: data
    func sub(_ loc: Int, _ len: Int) -> Data?{
        guard (loc + len < pq.count + 1) else { return nil }
        guard let range = Range(NSRange(location: loc, length: len)) else { return nil }
        return sub(range)
    }
    
    
    /// 提取 data
    /// sub data with Range
    ///
    /// - Parameter range: 范围
    /// - Returns: data
    func sub(_ range: Range<Int>) -> Data?{
        guard range.upperBound < pq.count + 1 else { return nil }
        return pq.subdata(in: range)
    }
    
    var bytes: Array<UInt8> {
        return Array(pq)
    }
    
}
