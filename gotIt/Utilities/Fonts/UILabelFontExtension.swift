//
//  UILabelFontExtension.swift
//  gotIt
//
//  Created by Sergio Hernandez Jr on 02/04/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit

// https://codelle.com/blog/2016/10/overriding-the-ios-dynamic-type-font-family/
extension UILabel {
	@objc var fontFamily: String {
		get {
			return font.fontDescriptor.object(forKey: UIFontDescriptor.AttributeName.family) as! String
		}
		
		set {
			let weight = (font.fontDescriptor.object(forKey: UIFontDescriptor.AttributeName.traits) as! NSDictionary)[UIFontDescriptor.TraitKey.weight]!
			let attributes = [UIFontDescriptor.AttributeName.traits: [UIFontDescriptor.TraitKey.weight: weight]]
			let descriptor = UIFontDescriptor(name: font.fontName, size: font.pointSize)
				.withFamily(newValue)
				.addingAttributes(attributes)
			
			font = UIFont(descriptor: descriptor, size: font.pointSize)
			
		}
	}
}
