//
//  ColorOvenAPI.swift
//  ColorOven2
//
//  Created by Christopher Williams on 9/4/23.
//

import Foundation

class APIService {
    
    // Singleton instance
    static let shared = APIService()
    
    // Renaming this method to match the call in ColorOvenViewModel
    func fetchColorSchemes(r: Int, g: Int, b: Int, completion: @escaping ([String: Any]?, Error?) -> Void) {
        let urlString = "https://www.coloroven.com/api/converter?r=\(r)&g=\(g)&b=\(b)"
        
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
            } else if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        completion(json, nil)
                    }
                } catch let parseError {
                    completion(nil, parseError)
                }
            }
        }.resume()
    }

    // The postData method remains unchanged as it doesn't conflict with the ColorOvenViewModel
    func postData(completion: @escaping ([String: Any]?, Error?) -> Void) {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            completion(nil, NSError(domain: "", code: -1, userInfo: nil))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let newPost = ["title": "foo", "body": "bar", "userId": 1] as [String: Any]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: newPost, options: .prettyPrinted)
        } catch let error {
            completion(nil, error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
            } else if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        completion(json, nil)
                    }
                } catch let parseError {
                    completion(nil, parseError)
                }
            }
        }
        
        task.resume()
    }
}
