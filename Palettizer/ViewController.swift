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
				sortColors(0)
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

		cell.textLabel?.textColor = cell.backgroundColor?.isDarkColor == true ? .lightText : .darkText
		cell.detailTextLabel?.textColor = cell.backgroundColor?.isDarkColor == true ? .lightText : .darkText
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let vc = storyboard?.instantiateViewController(withIdentifier: "colorDetail") as? ColorDetailView {
			
			vc.selectedColorHex = listedColors[indexPath.row].value
			vc.selectedColorName = listedColors[indexPath.row].name.capitalized
			
			navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	// sorts the array of colors. Ideally this will be tied to a settings toggle in navbar and the Tag of the toggle will be passed as an int. Currently tag == 1 means sort from white->black and tag == 2 means sort alpha.
	
	func sortColors(_ order: Int) {
		switch order {
		case 1:
			listedColors.sort(by: { $0.value > $1.value })
		case 2:
			listedColors.sort(by: {$0.name > $1.name})
		default:
			break
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

//determina luminance of background color: https://stackoverflow.com/questions/47365583/determining-text-color-from-the-background-color-in-swift

extension UIColor
{
	var isDarkColor: Bool {
		var r, g, b, a: CGFloat
		(r, g, b, a) = (0, 0, 0, 0)
		self.getRed(&r, green: &g, blue: &b, alpha: &a)
		let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
		return  lum < 0.50 ? true : false
	}
}
