//
//  Parser.swift
//  Palettizer
//
//  Created by Scott Lougheed on 2019/06/10.
//  Copyright © 2019 Scott Lougheed. All rights reserved.
//

import Foundation

var listedColors = [PantoneColor]()
var colorDict = [String: String]()

// GET PATH OF JSON
func getPath() -> URL? {
	if let colorPath = Bundle.main.path(forResource: "colorList", ofType: "json") {
		let url = URL(fileURLWithPath: colorPath)
		return url
	} else {
		return nil
	}
}

// HANDLE JSON
func parse(json: Data) {
	let decoder = JSONDecoder()
	if let jsoncolors = try? decoder.decode([PantoneColor].self, from: json) {
		listedColors = jsoncolors
	} else {
		print("Parser's right fucked")
	}
}
