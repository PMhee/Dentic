//
//  Helper.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/17/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import Alamofire
import AlamofireImage
extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date)) Y"   }
        if months(from: date)  > 0 { return "\(months(from: date)) M"  }
        //if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date)) D"    }
        //if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        //if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        //if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
private let characterEntities : [ String : Character ] = [
    // XML predefined entities:
    "&quot;"    : "\"",
    "&amp;"     : "&",
    "&apos;"    : "'",
    "&lt;"      : "<",
    "&gt;"      : ">",
    
    // HTML character entity references:
    "&nbsp;"    : "\u{00a0}",
    // ...
    "&diams;"   : "♦",
]
extension String {
    
    /// Returns a new string made by replacing in the `String`
    /// all HTML character entity references with the corresponding
    /// character.
    var stringByDecodingHTMLEntities : String {
        
        // ===== Utility functions =====
        
        // Convert the number in the string to the corresponding
        // Unicode character, e.g.
        //    decodeNumeric("64", 10)   --> "@"
        //    decodeNumeric("20ac", 16) --> "€"
        func decodeNumeric(_ string : String, base : Int) -> Character? {
            guard let code = UInt32(string, radix: base),
                let uniScalar = UnicodeScalar(code) else { return nil }
            return Character(uniScalar)
        }
        
        // Decode the HTML character entity to the corresponding
        // Unicode character, return `nil` for invalid input.
        //     decode("&#64;")    --> "@"
        //     decode("&#x20ac;") --> "€"
        //     decode("&lt;")     --> "<"
        //     decode("&foo;")    --> nil
        func decode(_ entity : String) -> Character? {
            
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X"){
                return decodeNumeric(entity.substring(with: entity.index(entity.startIndex, offsetBy: 3) ..< entity.index(entity.endIndex, offsetBy: -1)), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.substring(with: entity.index(entity.startIndex, offsetBy: 2) ..< entity.index(entity.endIndex, offsetBy: -1)), base: 10)
            } else {
                return characterEntities[entity]
            }
        }
        
        // ===== Method starts here =====
        
        var result = ""
        var position = startIndex
        
        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = self.range(of: "&", range: position ..< endIndex) {
            result.append(self[position ..< ampRange.lowerBound])
            position = ampRange.lowerBound
            
            // Find the next ';' and copy everything from '&' to ';' into `entity`
            if let semiRange = self.range(of: ";", range: position ..< endIndex) {
                let entity = self[position ..< semiRange.upperBound]
                position = semiRange.upperBound
                
                if let decoded = decode(entity) {
                    // Replace by decoded character:
                    result.append(decoded)
                } else {
                    // Invalid entity, copy verbatim:
                    result.append(entity)
                }
            } else {
                // No matching ';'.
                break
            }
        }
        // Copy remaining characters to `result`:
        result.append(self[position ..< endIndex])
        return result
    }
}
class Helper{
    var color = Color()
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    func StringToDate(date:String) -> Date{
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return format.date(from: date)!
    }
    func FormatStringToDate(date:String) -> Date{
        let format = DateFormatter()
        format.dateStyle = .medium
        return format.date(from: date)!
    }
    func MediumDateStringToString(date:String) -> String{
        let format = DateFormatter()
        format.dateStyle = .medium
        return self.dateToServer(date: format.date(from: date))
    }
    func StringtoDOB(date:String) -> Date{
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd"
        return format.date(from: date)!
    }
    func isToday(date:Date) -> Bool{
        let cpFormat = DateFormatter()
        cpFormat.dateStyle = .short
        if cpFormat.string(from: date) == cpFormat.string(from: Date()){
            return true
        }else{
            return false
        }
    }
    func minimumDate() -> Date {
        var date = Date()
        let calendar = NSCalendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date as Date)
        components.hour = 1
        components.minute = 1
        components.second = 1
        components.year = 1
        components.month = 1
        components.day = 1
        date = (calendar.date(from: components))!
        return date
    }
    func setButtomBorder(tf:UITextField) {
        let bottomLine = CALayer()
        tf.tintColor = UIColor.black
        bottomLine.frame = CGRect(x: 0.0, y: tf.frame.height-1, width: tf.frame.width, height: 0.5)
        bottomLine.backgroundColor = UIColor.darkGray.cgColor
        tf.borderStyle = UITextBorderStyle.none
        tf.layer.addSublayer(bottomLine)
        tf.layer.masksToBounds = true
    }
    func subString(text:String,start:Int,end:Int) -> String{
        let start = text.index(text.startIndex, offsetBy: start)
        let end = text.index(text.startIndex, offsetBy: end)
        let range = start..<end
        return text[range]
    }
    func dateToString(date:Date!) -> String{
        if date != nil{
            let format = DateFormatter()
            let cpFormat = DateFormatter()
            cpFormat.dateStyle = .short
            if cpFormat.string(from: date) == cpFormat.string(from: Date()){
                format.timeStyle = .short
            }else{
                format.dateStyle = .medium
                format.timeStyle = .medium
            }
            return format.string(from: date)
        }else{
            return ""
        }
    }
    func dateToServer(date:Date!) -> String{
        if date != nil{
            let format = DateFormatter()
            //format.timeZone = TimeZone(secondsFromGMT: 0)
            format.dateFormat = "YYYY-MM-dd HH:mm:ss"
            return format.string(from: date)
        }else{
            return ""
        }
    }
    
    func compareDate(date1:Date,date2:Date) ->Bool{
        let format = DateFormatter()
        format.dateStyle = .medium
        if format.string(from: date1) == format.string(from: date2){
            return true
        }else{
            return false
        }
    }
    func stringToDateOnlyDate(date:String) -> Date{
        let format = DateFormatter()
        format.dateStyle = .medium
        return format.date(from: date)!
    }
    func stringToDateOnlyTime(date:String) -> Date{
        let format = DateFormatter()
        format.dateFormat = "HH:mm:ss"
        return format.date(from: date)!
    }
    func dateToStringOnlyDateInFormat(date:Date) -> String{
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd"
        return format.string(from:date)
    }
    func dateToStringOnlyDate(date:Date!) -> String{
        if date != nil{
            let format = DateFormatter()
            let cpFormat = DateFormatter()
            cpFormat.dateStyle = .short
            format.dateStyle = .medium
            return format.string(from: date)
        }else{
            return ""
        }
    }
    func dateToStringOnlyTime(date:Date!) -> String{
        if date != nil{
            let format = DateFormatter()
            let cpFormat = DateFormatter()
            cpFormat.dateStyle = .short
            format.timeStyle = .medium
            return format.string(from: date)
        }else{
            return ""
        }
    }
    func showDate(date:Date) -> String{
        let d = date
        if (-d.timeIntervalSinceNow/60 < 1){
            return "just now"
        }else if (-d.timeIntervalSinceNow/60 < 2){
            return String(Int(-d.timeIntervalSinceNow/60))+" min"
        }else if (-d.timeIntervalSinceNow/60 < 60){
            return String(Int(-d.timeIntervalSinceNow/60))+" mins"
        }else if (-d.timeIntervalSinceNow/(60*60) < 2){
            return String(Int(-d.timeIntervalSinceNow/(60*60)))+" hr"
        }else if (-d.timeIntervalSinceNow/(60*60) < 24){
            return String(Int(-d.timeIntervalSinceNow/(60*60)))+" hrs"
        }else if (-d.timeIntervalSinceNow/(60*60) < 48){
            return "yesterday"
        }else{
            let format = DateFormatter()
            format.dateStyle = .medium
            return format.string(from: d)
        }
    }
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    func downloadImageFrom(link:String, contentMode: UIViewContentMode,img:UIImageView) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                img.contentMode =  .scaleAspectFill
                if let data = data { img.image = UIImage(data: data) }
            }
        }).resume()
    }
    func loadLocalProfilePic(id:String,image:UIImageView){
        DispatchQueue.global(qos:.background).async {
            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
            let paths            = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            if paths.count > 0
            {
                let dirPath = paths[0]
                let readPath = dirPath.appending("/"+id)
                let img  = UIImage(contentsOfFile: readPath)
                img?.cgImage
                DispatchQueue.main.async {
                    image.image = img
                }
                // Do whatever you want with the image
            }
            
        }
    }
    func setGradientColorLeftRight(vw:UIView,color1:UIColor,color2:UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: vw.frame.size.width, height:vw.frame.size.height)
        vw.layer.insertSublayer(gradient, at: 0)
    }
    func setGradientColorTopBot(vw:UIView,color1:UIColor,color2:UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: vw.frame.size.width, height:vw.frame.size.height)
        vw.layer.insertSublayer(gradient, at: 0)
    }
    func setGradientColorSlide(vw:UIView,color1:UIColor,color2:UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: vw.frame.size.width, height:vw.frame.size.height)
        vw.layer.insertSublayer(gradient, at: 0)
    }
    func loadLocalImage(id:String) -> UIImage?{
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths            = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        let dirPath = paths[0]
        let readPath = dirPath.appending("/"+id)
        return UIImage(contentsOfFile: readPath)
    }
    func generateID() ->String{
        let time = String(Int(NSDate().timeIntervalSince1970), radix: 16, uppercase: false)
        let machine = String(arc4random_uniform(900000) + 100000)
        let pid = String(arc4random_uniform(9000) + 1000)
        let counter = String(arc4random_uniform(900000) + 100000)
        return time + machine + pid + counter
    }
    func inBound(x:CGFloat,y:CGFloat,view:UIView) ->Bool{
        if x < 0 || x > view.frame.width || y < 0 || y > view.frame.height{
            return false
        }else{
            return true
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    func saveLocalProfilePic(picurl:String,id:String){
        DispatchQueue.global(qos:.background).async {
            if let url = URL(string: picurl) {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        if let data = UIImageJPEGRepresentation(image,1.0) {
                            let filename = self.getDocumentsDirectory().appendingPathComponent(String(describing: id))
                            try? data.write(to: filename)
                        }
                    }
                }
            }
        }
    }
    func saveLocalProfilePicFromImage(image:UIImage,id:String){
        DispatchQueue.global(qos:.background).async {
        if let data = UIImageJPEGRepresentation(image,1.0) {
            let filename = self.getDocumentsDirectory().appendingPathComponent(String(describing: id))
            try? data.write(to: filename)
        }
    }
    }
    func removePic(id:String){
        let fileManager = FileManager.default
        do {
            let fileName = self.getDocumentsDirectory().appendingPathComponent(String(describing: id))
            try fileManager.removeItem(atPath: fileName.path)
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
}
