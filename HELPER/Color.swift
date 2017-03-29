//
//  Color.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/17/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//
import Foundation
import UIKit
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
class Color{
    public var flatPowderBlueLight = 0xABBAF2
    public var flatPowderBlueDark = 0x8898D0
    public var flatSkyBlueLight = 0x3182D9
    public var flatSkyBlueDark = 0x2769B0
    public var flatBlueLight = 0x404E95
    public var flatBlueDark = 0x2C3872
    public var flatPurpleLight = 0x5F42C0
    public var flatPurpleDark = 0x472F97
    public var flatMagentaLight = 0x853DAE
    public var flatMagentaDark = 0x7728A4
    public var flatPinkLight = 0xE960BB
    public var flatPinkDark = 0xC34291
    public var flatWatermelonLight = 0xE35A66
    public var flatWathermelonDark = 0xC93F45
    public var flatRedLight = 0xD93829
    public var flatRedDark = 0xAC281C
    public var flatOrangeDark = 0xC24100
    public var flatOrangeLight = 0xD96C00
    public var flatYellowDark = 0xF99A00
    public var flatYellowLight = 0xFBC700
    public var flatLimeLight = 0x98BF00
    public var flatLimeDark = 0x7FA500
    public var flatGreenLight = 0x3BC651
    public var flatGreenDark = 0x31A343
    public var flatMintLight = 0x2EB187
    public var flatMintDark = 0x27916F
    public var flatTealLight = 0x305B70
    public var flatTealDark = 0x2C4F60
    public var flatNavyBlueLight = 0x28384D
    public var flatNavyBlueDark = 0x222E40
    public var flatBlackLight = 0x202020
    public var flatBlackDark = 0x1D1D1D
    public var flatBrownDark = 0x3E2D1F
    public var flatBrownLight = 0x4A3625
    public var flatCoffeeDark = 0x7A5F49
    public var flatCoffeeLight = 0x90745B
    public var flatSandDark = 0xCAB77D
    public var flatSandLight = 0xEBD89F
    public var flatWhiteLight = 0xFFFFFF
    public var flatWhiteDark = 0xB0B6BB
    public var flatGreyLight = 0x849495
    public var flatGreyDark = 0x6D797A
    public var flatMaroonLight = 0x62231E
    public var flatMaroonDark = 0x501C18
    public var flatForestGreenLight = 0x2B4E2F
    public var flatForestGreenDark = 0x254026
    public var flatPlumLight = 0x49244E
    public var flatPlumDark = 0x3C1D40
    func listColor() ->[Int]{
        var color = [Int]()
        color.append(flatWhiteLight)
        color.append(flatWhiteDark)
        color.append(flatPowderBlueLight)
        color.append(flatPowderBlueDark)
        color.append(flatSkyBlueLight)
        color.append(flatSkyBlueDark)
        color.append(flatBlueLight)
        color.append(flatBlueDark)
        color.append(flatPurpleLight)
        color.append(flatPurpleDark)
        color.append(flatMagentaLight)
        color.append(flatMagentaDark)
        color.append(flatPinkLight)
        color.append(flatPinkDark)
        color.append(flatWatermelonLight)
        color.append(flatWathermelonDark)
        color.append(flatRedLight)
        color.append(flatRedDark)
        color.append(flatOrangeDark)
        color.append(flatOrangeLight)
        color.append(flatYellowDark)
        color.append(flatYellowLight)
        color.append(flatLimeLight)
        color.append(flatLimeDark)
        color.append(flatGreenLight)
        color.append(flatGreenDark)
        color.append(flatMintLight)
        color.append(flatMintDark)
        color.append(flatTealLight)
        color.append(flatTealDark)
        color.append(flatNavyBlueLight)
        color.append(flatNavyBlueDark)
        color.append(flatBlackLight)
        color.append(flatBlackDark)
        color.append(flatBrownDark)
        color.append(flatBrownLight)
        color.append(flatCoffeeDark)
        color.append(flatCoffeeLight)
        color.append(flatSandDark)
        color.append(flatSandLight)
        color.append(flatGreyLight)
        color.append(flatGreyDark)
        color.append(flatMaroonLight)
        color.append(flatMaroonDark)
        color.append(flatForestGreenLight)
        color.append(flatForestGreenDark)
        color.append(flatPlumLight)
        color.append(flatPlumDark)
        return color
    }
    func backEndColor(color:Int) -> String{
        var st = NSString(format:"%2X", color) as String
        st = "#"+st
        return st
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func frontEndColor(color:String) -> Int{
        var cString:String = color.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        cString.remove(at: cString.startIndex)
        return Int(cString, radix: 16)!
    }
    func letterColor(color:Int) -> UIColor{
        if color == self.flatWhiteDark || color == self.flatWhiteLight || color == self.flatSandLight || color == self.flatGreyLight{
            return UIColor(netHex:0x000000)
        }else{
            return UIColor(netHex:0xFFFFFF)
        }
    }
    func isBlack(color:Int) -> Bool{
        if color == self.flatWhiteDark || color == self.flatWhiteLight || color == self.flatSandLight || color == self.flatGreyLight{
            return true
        }else{
            return false
        }
    }
}
