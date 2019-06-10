//
//  PQSkip.swift
//  PQKit
//
//  Created by 盘国权 on 2019/6/10.
//  Copyright © 2019 pgq. All rights reserved.
//

import Foundation

public extension String {
    /// suport rgb rgba 
    var spColor: UIColor? {
        var str = self
        if !str.contains("0x") && !str.contains("0X") {
            str = "0x" + str
        }
        let scanner = Scanner(string: self)
        var hex: UInt64 = 0
        scanner.scanHexInt64(&hex)
        var alpha: CGFloat = 1
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        if str.count == 8 {
           red = CGFloat(hex >> 16 & 0xff) / 255.0
           green = CGFloat(hex >> 8 & 0xff) / 255.0
           blue = CGFloat(hex & 0xff) / 255.0
        }else if str.count == 10 {
            red = CGFloat(hex >> 32 & 0xff) / 255.0
            green = CGFloat(hex >> 16 & 0xff) / 255.0
            blue = CGFloat(hex >> 8 & 0xff) / 255.0
            alpha = CGFloat(hex & 0xff)
        } else {
            return nil
        }
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

public struct PQSkipFont: Codable {
    var size: CGFloat
    var color: String
    var family: String?
    var bold: Bool
    
    var font: UIFont {
        if let family = family {
            if let font = UIFont(name: family, size: size) {
                return font
            }
            return UIFont.systemFont(ofSize: size)
        }
        if bold {
            return UIFont.boldSystemFont(ofSize: size)
        }
        return UIFont.systemFont(ofSize: size)
        
    }
    
    static var largeTitle = PQSkipFont(size: 26, color: "0x000000ff", family: nil, bold: false)
    static var midTitle = PQSkipFont(size: 23, color: "0x000000ff", family: nil, bold: false)
    static var smallTitle = PQSkipFont(size: 20, color: "0x000000ff", family: nil, bold: false)
    static var context = PQSkipFont(size: 17, color: "0x000000ff", family: nil, bold: false)
    static var hint = PQSkipFont(size: 13, color: "0x000000ff", family: nil, bold: false)
    
    
    static var selectedTitle = PQSkipFont(size: 15, color: "0x000000ff", family: nil, bold: false)
    static var normalTitle = PQSkipFont(size: 15, color: "0x000000ff", family: nil, bold: false)
    
    
    static var textField = PQSkipFont(size: 15, color: "0x000000ff", family: nil, bold: false)
    static var textView = PQSkipFont(size: 15, color: "0x000000ff", family: nil, bold: false)
}

public struct PQSkipNavigationBar: Codable {
    var isHidden: Bool
    var barTintColor: String?
    var isTranslucent: Bool
    var tintColor: String?
    var font: PQSkipFont
    
    static let `default` = PQSkipNavigationBar(isHidden: false, barTintColor: "0xffffffff", isTranslucent: false, tintColor: "0xffffffff", font: PQSkipFont(size: 17, color: "0xffffffff", family: nil, bold: false))
}

public struct PQSkipController: Codable {
    var backgroundColor: String?
    
    static let `default` = PQSkipController(backgroundColor: "0xffffffff")
}

public struct PQSkipTBCell: Codable {
    var backgroundColor: String?
    var lineColor: String?
    var lineHeight: CGFloat
    var lineMargin: [CGFloat]
    static let `default` = PQSkipTBCell(backgroundColor: "0xffffffff", lineColor: "0xffffffff", lineHeight: 1, lineMargin: [0,0])
}

public struct PQSkipCVCell: Codable {
    var backgroundColor: String?
    
    static let `default` = PQSkipCVCell(backgroundColor: "0xffffffff")
}

public struct PQSkipLabel: Codable {
    var largeTitle: PQSkipFont
    var midTitle: PQSkipFont
    var smallTitle: PQSkipFont
    var context: PQSkipFont
    var hint: PQSkipFont
    
    static var `default` = PQSkipLabel(largeTitle: .largeTitle, midTitle: .midTitle, smallTitle: .smallTitle, context: .context, hint: .hint)
}

public struct PQSkipButton: Codable {
    var normalTitle: PQSkipFont
    var selectedTitle: PQSkipFont
    
    static var `default` = PQSkipButton(normalTitle: .normalTitle, selectedTitle: .selectedTitle)
}

public struct PQSkipTextField: Codable {
    var placehodloerColor: String?
    var cursorColor: String?
    var textColor: String?
    var font: PQSkipFont
    
    static var `default` = PQSkipTextField(placehodloerColor: "0x000000ff", cursorColor: "0x000000ff", textColor: "0x000000ff", font: .textField)
}

public struct PQSkipTextView: Codable {
    var placehodloerColor: String?
    var cursorColor: String?
    var textColor: String?
    var font: PQSkipFont
    
    static var `default` = PQSkipTextView(placehodloerColor: "0x000000ff", cursorColor: "0x000000ff", textColor: "0x000000ff", font: .textField)
}

open class PQSkip: NSObject, Codable {
    public static internal(set) var shared = PQSkip()
    
    var navigationBar: PQSkipNavigationBar = .default
    var controller: PQSkipController = .default
    var tbCell: PQSkipTBCell = .default
    var cvCell: PQSkipCVCell = .default
    var label: PQSkipLabel = .default
    var button: PQSkipButton = .default
    var textField: PQSkipTextField = .default
    var textView: PQSkipTextView = .default
    
    
    public func readSkip(for url: URL, completion: @escaping (Error?) -> ()) {
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                self.readSkip(for: data, completion: completion)
            } catch {
                completion(error)
            }
        }
    }
    
    public func readSkip(for data: Data, completion: @escaping (Error?) -> ()) {
        do {
            let skip = try JSONDecoder().decode(PQSkip.self, from: data)
            PQSkip.shared = skip
        } catch {
            completion(error)
        }
    }
    
    public func readSkip(for json: String, completion: @escaping (Error?) -> ()) {
        guard let data = json.data(using: .utf8) else {
            
            completion(NSError(domain: "Json str to data invalid", code: 0, userInfo: nil) as Error)
            return
        }
        readSkip(for: data, completion: completion)
    }
    
    open override var description: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if let data = try? encoder.encode(self),
            let jsonStr = String(data: data, encoding: .utf8) {
            return  jsonStr
        }
        return "\(self)"
    }
}
