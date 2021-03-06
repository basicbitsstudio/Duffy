//
//  Globals.swift
//  Duffy
//
//  Created by Patrick Rills on 7/8/18.
//  Copyright © 2018 Big Blue Fly. All rights reserved.
//

import UIKit

class Globals: NSObject
{
    private static let numberFormatter = NumberFormatter()
    private static let decimalFormatter = NumberFormatter()
    private static let dateFormatter = DateFormatter()
    private static let primary = UIColor(red: 0.0, green: 61.0/255.0, blue: 165.0/255.0, alpha: 1.0)
    private static let secondary = UIColor(red: 76.0/255.0, green: 142.0/255.0, blue: 218.0/255.0, alpha: 1.0)
    private static let lightText = UIColor.black.withAlphaComponent(0.2)
    private static let veryLightText = UIColor.black.withAlphaComponent(0.15)
    private static let success = UIColor(red: 0.25, green: 0.72, blue:0.48, alpha: 1.0)
    
    open class func stepsFormatter() -> NumberFormatter
    {
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.locale = Locale.current
        numberFormatter.maximumFractionDigits = 0
        
        return numberFormatter
    }
    
    open class func flightsFormatter() -> NumberFormatter
    {
        return stepsFormatter()
    }
    
    open class func distanceFormatter() -> NumberFormatter
    {
        decimalFormatter.numberStyle = NumberFormatter.Style.decimal
        decimalFormatter.locale = Locale.current
        decimalFormatter.maximumFractionDigits = 1
        
        return decimalFormatter
    }
    
    open class func dayFormatter() -> DateFormatter
    {
        dateFormatter.dateFormat = "eee, MMM d"
        return dateFormatter
    }
 
    open class func primaryColor() -> UIColor
    {
        return primary
    }
    
    open class func secondaryColor() -> UIColor
    {
        return secondary
    }
    
    open class func lightGrayColor() -> UIColor
    {
        return lightText
    }
    
    open class func veryLightGrayColor() -> UIColor
    {
        return veryLightText
    }
    
    open class func successColor() -> UIColor
    {
        return success
    }
    
    open class func isNarrowPhone() -> Bool
    {
        return UIScreen.main.bounds.size.width <= 320.0
    }
}
