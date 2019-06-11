//
//  ViewController.swift
//  Palettizer
//
//  Created by Scott Lougheed on 2019/05/13.
//  Copyright © 2019 Scott Lougheed. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// SETTING UP THE UI
		self.title = "Palettizer"
		navigationController?.navigationBar.prefersLargeTitles = true
		self.tableView.separatorStyle = .none
		
		// GET PATH AND PARSE JSON
		if let url = getPath() {
			if let data = try? Data(contentsOf: url) {
				parse(json: data)
				tableView.reloadData()
				return
			} else {
				showErrors("parse")
			}
		} else {
			showErrors("path")
		}
	}
	
	// BUILD TABLE
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return listedColors.count
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80.0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "color", for: indexPath)
		let displayColor = listedColors[indexPath.row]
		let backgroundColor = UIColor(hex: displayColor.value) // CALLS UIColor EXTENSION TO CONVERT CURRENT CELL'S HEX TO UIColor
		cell.textLabel?.text = displayColor.name.capitalized
		cell.detailTextLabel?.text = displayColor.value
		cell.backgroundColor = backgroundColor
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let vc = storyboard?.instantiateViewController(withIdentifier: "colorDetail") as? ColorDetailView {
			
			vc.selectedColorHex = listedColors[indexPath.row].value
			vc.selectedColorName = listedColors[indexPath.row].name.capitalized
			
			navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	// ERRORS
	func showErrors(_ errorType: String) {
		switch errorType {
		case "parse":
			print("There was a problem with parsing")
		case "path":
			print("There was a problem with getting path")
		default:
			print("There was an unknown problem")
		}
	}
}

// EXTENSION to convert hex to UIColor courtesy of Paul Hudson (@twostraws): https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor

extension UIColor {
	public convenience init?(hex: String) {
		let r, g, b, a: CGFloat
		
		if hex.hasPrefix("#") {
			let start = hex.index(hex.startIndex, offsetBy: 1)
			let hexColor = String(hex[start...])
			
			if hexColor.count == 8 {
				let scanner = Scanner(string: hexColor)
				var hexNumber: UInt64 = 0
				
				if scanner.scanHexInt64(&hexNumber) {
					r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
					g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
					b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
					a = CGFloat(hexNumber & 0x000000ff) / 255
					
					self.init(red: r, green: g, blue: b, alpha: a)
					return
				}
			}
		}
		
		return nil
	}
}
