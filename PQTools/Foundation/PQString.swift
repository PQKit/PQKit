

import Foundation
import CommonCrypto


public struct PQString<T>: PQType{
    //internal 默认的访问级别，可以不写
    public let pq: T
    public init(pq: T){
        self.pq = pq
    }
}

extension String {
    public var pq: PQString<String> {
        return PQString(pq: self)
    }
}

public extension PQString where WrapperType == String {
    
    /// 国际化
    /// NSLocalizedString(str, comment: str)
    ///
    /// - Returns: string
    func localized() -> String{
        return NSLocalizedString(pq, comment: pq)
    }
    
    
    /// 字符串转 class
    /// string to class
    ///
    /// - Returns: T
    func controller() throws -> UIViewController {
        /*
         动态创建类，需要用到namesapce，命名空间，也就是前缀
         */
        
        //获取namespace info.plist中获取
        guard let infoPath : String = Bundle.main.path(forResource: "Info.plist", ofType: nil) else {
            throw NSError(domain: "Get info plist path failed", code: 0, userInfo: nil)
        }
        //得到
        guard let infoDict : NSDictionary = NSDictionary(contentsOfFile: infoPath) else {
            throw NSError(domain: "Get info dictionary failed", code: 0, userInfo: nil)
        }
        //获取命名空间
        guard let nameSpace = infoDict["CFBundleName"] as? String else {
            throw NSError(domain: "Get info dictionary failed, please check your plist file  key `CFBundleName` ", code: 0, userInfo: nil)
        }
        
        //动态创建类，一定要包括 "命名空间." 比如 "Project."
        guard let cls : AnyClass = NSClassFromString(String(nameSpace + "." + pq)) else {
            throw NSError(domain: "string to class failed", code: 0, userInfo: nil)
        }
        
        //类型指定
        guard let controller = cls as? UIViewController.Type else {
            throw NSError(domain: "class to T.type failed", code: 0, userInfo: nil)
        }
        
        return controller.init()
    }
    
    /// remove sapce char
    ///
    /// - Returns: string
    func removeSpaceCharacter() -> String {
        if pq.contains(" ") {
            return pq.filter { $0 != " " }
                .map(String.init)
                .reduce("", { $0 + $1 })
        }
        return pq
    }
    
    
    
    /// 字符串转化为16进制数据
    /// string to hex value
    ///
    /// - Returns: hex value
    func hex() -> UInt64 {
        let scanner = Scanner(string: pq)
        var hex: UInt64 = 0
        scanner.scanHexInt64(&hex)
        return hex
    }
    
    
    /// 把字符串拼接到 Cache目录下
    /// combine string to cache path
    ///
    /// - Returns: cache path
    func cacheDir() -> String{
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!  as NSString
        return path.appendingPathComponent(pq as String)
    }
    
    /// 把字符串拼接到 文档目录下
    /// combine string to document path
    ///
    /// - Returns: document path
    func documentDir() -> String
    {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!  as NSString
        return path.appendingPathComponent((pq as NSString).lastPathComponent)
    }
    
    /// 把字符串拼接到 缓存目录下
    /// combine string to temp path
    ///
    /// - Returns: temp path
    func tempDir() -> String
    {
        let path = NSTemporaryDirectory() as NSString
        return path.appendingPathComponent((pq as NSString).lastPathComponent)
    }
    
    /// 正则
    /// regex
    ///
    /// - Parameters:
    ///   - partten: 条件
    ///   - regexOptions: 模式
    ///   - match: 模式
    /// - Returns: bool
    func regex(partten: String, regexOptions: NSRegularExpression.Options = .caseInsensitive, match: NSRegularExpression.MatchingOptions = .reportProgress) -> Bool{
        do {
            //2、创建正则表达式
            let regex = try NSRegularExpression(pattern: partten, options: NSRegularExpression.Options.caseInsensitive)
            
            //3、匹配
            let range = regex.rangeOfFirstMatch(in: pq, options: NSRegularExpression.MatchingOptions(rawValue : 0), range: NSRange(location: 0, length: pq.count))
            
            if range.location == 0 && range.length >= 1 {
                return true
            }
            
        } catch{
            print(error)
        }
        
        return false
    }
    
    /// 判断是否输入的是全中文或者不包含中文
    /// Check if the string contains Chinese
    ///
    /// - Parameter all: 是否
    /// - Returns: bool
    func isAllChinese(_ all: Bool = true) -> Bool {
        let partten = all ? "^[\\u4e00-\\u9fa5]{0,}$" : "^[^\\u4e00-\\u9fa5]{0,}$"
        return regex(partten: partten)
    }
    
    /// 判断是否输入的是邮件
    /// Check if the string contains Chinese
    ///
    /// - Parameter all: 是否
    /// - Returns: bool
    func isEmail() -> Bool {
        return regex(partten: "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{2,4}$")
    }
    
    
    /// 判断是否输入的是手机号
    /// Check if the string contains Chinese
    ///
    /// - Returns: <#return value description#>
    func isPhoneNumber() -> Bool {
        return regex(partten: "^[1][3,4,5,7,8][0-9]{9}$")
    }
    
    /// 查找字符串
    /// from this string find str, "ddaabddssd".pq.findString(dd) []
    ///
    /// - Parameter string: 字符串
    /// - Returns: ranges
    func findString(_ string: String) -> [NSRange] {
        do{
            let partten = NSString.init(format: "\\b%@\\b", [pq]) as String
            let regex = try NSRegularExpression(pattern: partten, options: NSRegularExpression.Options.caseInsensitive)
            let results = regex.matches(in: pq, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: pq.count))
            return results.map({ (result) -> NSRange in
                return result.range
            })
        }catch{
            print("find error",error)
        }
        return []
    }
    
    
    
    /// 提取字符串
    /// sub str with character
    ///
    /// - Parameters:
    ///   - start: start char
    ///   - end: end char
    /// - Returns: string optional
    func sub(start: Character, end: Character) -> String? {
        guard var sIdx = pq.firstIndex(of: start),
            let eIdx = pq.firstIndex(of: end),
            sIdx < eIdx  else {
                return nil
        }
        sIdx = pq.index(sIdx, offsetBy: 1)
        return String(pq[sIdx..<eIdx])
    }
    
    //根据开始位置和长度截取字符串
    func subString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = pq.count - start
        }
        
        let st = pq.index(pq.startIndex, offsetBy:start)
        let en = pq.index(st, offsetBy:len)
        return String(pq[st ..< en])
    }
    
   
    
    /// 提取字符串，根据 Range
    /// The character string extraction Range
    ///
    /// - Parameter range: range
    subscript(_ range: Range<Int>) -> String {
        let newStartIndex = pq.index(pq.startIndex, offsetBy: range.lowerBound)
        let newEndIndex   = pq.index(pq.startIndex, offsetBy: range.upperBound)
        return String(pq[newStartIndex..<newEndIndex])
    }
    
    /// 提取字符串，根据 NSRange
    /// The character string extraction NSRange
    ///
    /// - Parameter range: range
    subscript(_ range: NSRange) -> String? {
        guard let dd = Range(range) else { return nil }
        let newStartIndex = pq.index(pq.startIndex, offsetBy: dd.lowerBound)
        let newEndIndex   = pq.index(pq.startIndex, offsetBy: dd.upperBound)
        return String(pq[newStartIndex..<newEndIndex])
    }
    
    
    /// 查找字符串，根据输入的字符串
    /// Find if string are included based on the input start and end strings
    ///
    /// - Parameters:
    ///   - start: start
    ///   - end: end
    /// - Returns: string optional
    func findStrStart(_ start: String, end: String) -> [String] {
        return findStart(start, end: end).compactMap { range -> String?in
            return self[range]
        }
    }
    
    /// 查找字符串，根据输入的字符串
    /// Find if string are included based on the input start and end strings
    ///
    /// - Parameters:
    ///   - start: start
    ///   - end: end
    /// - Returns: NSRange Array
    func findStart(_ first: String, end: String) -> [NSRange]{
        do{
            let partten = "\(first)(.+?)\(end)"
            let regex = try NSRegularExpression(pattern: partten, options: NSRegularExpression.Options.caseInsensitive)
            let results = regex.matches(in: pq, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: pq.count))
            return results.map({
                let range = $0.range
                let loction = range.location + first.count - 1
                let length = range.length - first.count - end.count + 2
                return NSRange(location: loction, length: length) })
        }catch{
            print("find error",error)
        }
        return []
    }
    
    /// 查找子串是否在字符串内
    /// check if parameter string is contains it
    ///
    /// - Parameter string: 子字符串
    /// - Returns: bool
    func has(_ string: String) -> Bool{
        do{
            let partten = "^.*(?=\(string).*$"
            let regex = try NSRegularExpression(pattern: partten, options: NSRegularExpression.Options.caseInsensitive)
            let results = regex.matches(in: pq, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: pq.count))
            return results.count > 0
        }catch{
            print("find error",error)
        }
        return false
    }
    
    /// 将十六进制字符串转化为 Data
    ///
    ///
    /// - Returns: data
    func data() -> Data? {
        return Data( bytes)
    }
    
    

    /// 将16进制字符串转化为 [UInt8]
    /// hex string to [UInt8]
    ///
    /// - Returns: [UInt8]
    func bytesFromHexString() throws -> [UInt8] {
        var hexStr = ""
        pq.components(separatedBy: " ").forEach({ hexStr.append($0) })

        if hexStr.count % 2 != 0 {
            throw NSError(domain: "Invalid string, maybe this length is not right", code: 0, userInfo: nil)
        }
        var bytes = [UInt8]()
        var sum = 0
        // 整形的 utf8 编码范围
        let intRange = 48...57
        // 小写 a~f 的 utf8 的编码范围
        let lowercaseRange = 97...102
        // 大写 A~F 的 utf8 的编码范围
        let uppercasedRange = 65...70
        for (index, c) in hexStr.utf8CString.enumerated() {
            var intC = Int(c.byteSwapped)
            if intC == 0 {
                break
            } else if intRange.contains(intC) {
                intC -= 48
            } else if lowercaseRange.contains(intC) {
                intC -= 87
            } else if uppercasedRange.contains(intC) {
                intC -= 55
            } else {
                throw NSError(domain: "Invalid string, this chars have to 0~9 or a~f/A~F", code: 1, userInfo: nil)
            }
            sum = sum * 16 + intC
            // 每两个十六进制字母代表8位，即一个字节
            if index % 2 != 0 {
                bytes.append(UInt8(sum))
                sum = 0
            }
        }
        return bytes
    }
    
    
    /// bytes
    var bytes: Array<UInt8> {
        return pq.data(using: String.Encoding.utf8, allowLossyConversion: true)?.pq.bytes ?? Array(pq.utf8)
    }
    
    /// md5
    var md5: String {
        let str = pq.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(pq.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
    
    var base64: String? {
        return pq.data(using: .utf8)?.base64EncodedString()
    }
}

// MARK: -  property
public extension String {
    /// Bundle.main.infoDictionary
    static var pq_infoDictionary: [String:Any] {
        return Bundle.main.infoDictionary ?? [:]
    }
    
    /// app version
    static var pq_appVersion: String? {
        return pq_infoDictionary["CFBundleShortVersionString"] as? String
    }
    
    /// app build version
    static var pq_appBuildVersion: String? {
        return pq_infoDictionary["CFBundleVersion"] as? String
    }
     
    /// app static name
    static var pq_appName: String? {
        return pq_infoDictionary["CFBundleName"] as? String
    }
}
