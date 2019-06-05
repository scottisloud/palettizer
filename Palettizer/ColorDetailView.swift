//
//  ColorDetailView.swift
//  Palettizer
//
//  Created by Scott Lougheed on 2019/06/5.
//  Copyright © 2019 Scott Lougheed. All rights reserved.
//

import UIKit

class ColorDetailView: UIViewController {
	
	@IBOutlet var colorChip: UIView!
	@IBOutlet var colorName: UILabel!
	@IBOutlet var colorHex: UILabel!
	@IBOutlet var copyInstructions: UILabel!
	
	var selectedColorName: String?
	var selectedColorHex: String?
	var selectedColorRGBA: String?
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = selectedColorName
		navigationController?.navigationBar.prefersLargeTitles = false
		
		copyInstructions.text = "Tap the hex value to copy it to your clipboard"
		
		colorHex.isUserInteractionEnabled = true
		let recognizer = UITapGestureRecognizer(target: self, action: #selector(hexTapped))
		colorHex.addGestureRecognizer(recognizer)
		if let c = selectedColorHex {
			let bg = UIColor(hex: c)
			colorChip.backgroundColor = bg
		}
		colorName.text = selectedColorName
		colorHex.text = selectedColorHex
	}
	
	@objc func hexTapped() {
		UIPasteboard.general.string = colorHex.text
		print(UIPasteboard.general.string!)
	}
}
