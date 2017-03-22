//
//  FontManager.swift
//  SampleAgentExpo
//
//  Created by Sriram, Krishnan on 3/20/17.
//  Copyright © 2017 Sriram, Krishnan. All rights reserved.
//

import UIKit

class FontManager: DataManager {
    var fontDirectory: [AEFontType] = []
    
    static let sharedInstance : FontManager = {
        let instance = FontManager()
        instance.loadFonts()
        return instance
    }()
    
    
    func loadFonts() {
        let file = "fonts"
        let path = Bundle.main.path(forResource: file, ofType: "json")
        let pathURL = NSURL(fileURLWithPath: path!)
        
        if let jsonData = NSData(contentsOf: pathURL as URL) {
            if let dataDictionary = self.JSONToDictionary(data: jsonData) {
                self.loadFontsFromDictionary(fontArray: dataDictionary.object(forKey: "fonts") as! NSArray)
            }
        }
    }
    
    func loadFontsFromDictionary(fontArray: NSArray) {
        for fontItem in fontArray {
            if let fontDict: NSDictionary = fontItem as? NSDictionary {
                let fontTypeName = fontDict.object(forKey: "fontType")
                let fontDetails = fontDict.object(forKey: "details") as! NSDictionary
                let fontName = fontDetails.object(forKey: "name")
                let size = fontDetails.object(forKey: "size")
                let style = fontDetails.object(forKey: "style")
                let font = AEFont(name: fontName as! String, size: size as! CGFloat, style: style as! String)
                let fontType = AEFontType(fontType: fontTypeName as! String, font: font)
                self.fontDirectory.append(fontType)
            }
            
        }
    }
    
    func fontForName(name: String) -> UIFont {
        for fontType: AEFontType in self.fontDirectory {
            if fontType.fontType == name {
                return fontType.fontFromType()
            }
        }
        return UIFont()
    }
}
