//
//  ColorOvenAPICall.swift
//  ColorOven2
//
//  Created by Christopher Williams on 9/4/23.
//

import Foundation

class ColorOvenViewModel {
    var colorSchemes: [String: Any] = [:]
    var dataPosted: [String: Any] = [:]
    
    func fetchColorSchemes(r: Int, g: Int, b: Int, completion: @escaping () -> Void) {
        APIService.shared.fetchColorSchemes(r: r, g: g, b: b) { (data, error) in
            if let error = error {
                print("Failed to fetch color schemes: \(error)")
                return
            }
            if let data = data {
                self.colorSchemes = data
            }
            completion()
        }
    }
    
    func postData(completion: @escaping () -> Void) {
        APIService.shared.postData { (data, error) in
            if let error = error {
                print("Failed to post data: \(error)")
                return
            }
            if let data = data {
                self.dataPosted = data
            }
            completion()
        }
    }
}


