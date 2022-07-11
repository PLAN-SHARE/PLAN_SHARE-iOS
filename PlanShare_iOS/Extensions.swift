//
//  Extensions.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/02/23.
//

import Foundation
import UIKit
import RxSwift

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    
    static let mainColor = UIColor.init(hex: "a1b5f5")
    static let mainBackgroundColor = UIColor.init(hex: "f2f2f2")
    
}

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}

extension Reactive where Base: CustomSearchBar {
    var endEditing: Binder<Void> {
        return Binder(base) { base, _ in
            base.endEditing(true)
        }
    }
}

extension UIFont {
    
    enum Family: String {
            case Bold, Light, Medium, Regular, Thin
        }
        
    static func noto(size: CGFloat = 12, family: Family = .Regular) -> UIFont! {
            return UIFont(name: "NotoSansKR-\(family)", size: size)
        }
}

extension Date {
    
    static func converToString(from date: Date,type: DateType) -> String {
        let dfMatter = DateFormatter()
        
        switch type {
        case .api : dfMatter.dateFormat = "yyyy-MM"
        case .calendar : dfMatter.dateFormat = "yyyy년 MM월"
        case .full : dfMatter.dateFormat = "yyyy-MM-dd"
        }
        
        dfMatter.locale = Locale(identifier: "ko_KR")
        
        return dfMatter.string(from: date)
    }
    
    static func convertToDate(from date: String) -> Date {
        let dfMatter = DateFormatter()
        dfMatter.dateFormat = "yyyy-MM-dd"
        dfMatter.locale = Locale(identifier: "ko_KR")
        return dfMatter.date(from: date)!
    }
    
    func dateCompare(fromDate: Date) -> GoalFilterOptions {
        let result: ComparisonResult = self.compare(fromDate)
        
        switch result {
        case .orderedAscending, .orderedSame:
            return .expected
        case .orderedDescending:
            return .past
        default :
            return .past
        }
    }
}

extension String {
    subscript(_ range: Range<Int>) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: range.startIndex)
        let toIndex = self.index(self.startIndex,offsetBy: range.endIndex)
        return String(self[fromIndex..<toIndex])
    }
}
