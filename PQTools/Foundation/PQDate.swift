

import Foundation

public struct PQDate<T>: PQType{
    //internal 默认的访问级别，可以不写
    public let pq: T
    public init(pq: T){
        self.pq = pq
    }
}

extension Date {
    public var pq: PQDate<Date> {
        return PQDate(pq: self)
    }
}


public enum DateFormat: String {
    case g = "G"//      公元时代，例如AD公元
    case year2 = "yy"//     年的后2位
    case year4 = "yyyy"//   完整年
    case month2 = "MM"//     月，显示为1-12,带前置0
    case month3 = "MMM"//    月，显示为英文月份简写,如 Jan
    case month4 = "MMMM"//   月，显示为英文月份全称，如 Janualy
    case day2 = "dd"//     日，2位数表示，如02
    case day1 = "d"//      日，1-2位显示，如2，无前置0
    case week3 = "EEE"//    简写星期几，如Sun
    case weeek4 = "EEEE"//   全写星期几，如Sunday
    case amOrPm = "aa"//     上下午，AM/PM
    case hour24_1 = "H"//      时，24小时制，0-23
    case hour24_2 = "HH"//     时，24小时制，带前置0
    case hour12_1 = "h"//      时，12小时制，无前置0
    case hour12_2 = "hh"//     时，12小时制，带前置0
    case minute = "m"//      分，1-2位
    case minute2 = "mm"//     分，2位，带前置0
    case second = "s"//      秒，1-2位
    case second2 = "ss"//     秒，2位，带前置0
    case ms = "S"//      毫秒
    case zone = "Z"//      GMT（时区）
    
    
    case point = "."
    case lineVertical = "|"
    case lineHorizontal = "-"
}


public extension PQDate where WrapperType == Date {
    
    /// 获取当前日期 根据格式
    /// get date string for format string
    ///
    /// - Parameter format: string
    /// - Returns: string
    func format(_ format: String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: Date())
    }
    
    /// 获取当前日期，根据 DateFormat 枚举
    /// get current date string for 'DateFormat'
    ///
    /// - Parameter type: type
    /// - Returns: string
    func type(_ type: DateFormat) -> String {
        return format(type.rawValue)
    }
    
    /// 获取当前日期，根据 DateFormat 枚举
    /// get current date string for 'DateFormat's
    ///
    /// - Parameter types: type array
    /// - Returns: string
    func types(_ types: [DateFormat]) -> String{
        var str = ""
        types.forEach { (type) in
            str = str.appending(type.rawValue)
        }
        return format(str)
    }
    
    /// 获取当前时间 yyyy-MM-dd HH:mm:ss.sss
    /// get current date string 'yyyy-MM-dd HH:mm:ss.sss'
    func now() -> String{
        return format("yyyy-MM-dd HH:mm:ss.sss")
    }
    
    /// 获取当前时间 yyyy-MM-dd'T'HH:mm:ss.ssZ
    /// get current date string yyyy-MM-dd'T'HH:mm:ss.ssZ
    func nowUTC() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ssZ"
        return formatter.string(from: Date())
    }
    
    /// 获取UTC的时间戳
    /// get timestamp string UTC
    func utcTimeinterval() -> String {
        let date = Date()
        let time = date.timeIntervalSince1970 * 1000
        return "\(time)"
    }
    
    /// 获取GMT的时间戳
    /// get timestamp string GMT
    func gmtTimeinterval() -> String {
        let date = Date()
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: date)
        let localDate = date.addingTimeInterval(Double(interval))
        let time = localDate.timeIntervalSince1970 * 1000
        return "\(time)"
    }
    
    var hour: Int {
        return Int(type(DateFormat.hour24_2))!
    }
    
    var min: Int {
        return Int(type(DateFormat.minute2))!
    }
    
}


