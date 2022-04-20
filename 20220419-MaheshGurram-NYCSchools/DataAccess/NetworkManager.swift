//
//  NetworkManager.swift
//  20220419-MaheshGurram-NYCSchools
//
//  Created by Mahesh on 4/18/22.
//

import Foundation
import UIKit

enum SchoolFetchError: Error {
    case invalidURL
    case invalidResponse(responseCode: Int)
}

class NetworkManager {
    
    public func getData<T: Codable>(url: String, type: T.Type = T.self, completion: @escaping(_ data: T?, _ error: String?) -> Void) {
        PrintLog.printToConsole(str: "Requesting data \(url)")
        guard let reqUrl = URL(string: url) else { return }
        let session = URLSession.shared
        
        let task = session.dataTask(with: reqUrl) { data, response, error in
            if let err = error {
                PrintLog.printToConsole(str: "Exception occured while making api call")
                completion(nil, err.localizedDescription)
                return
            }
            
            if let res = response as? HTTPURLResponse {
                // If the status code is not between 200-299, treat as failure and show the error message to user.
                if !(200...299).contains(res.statusCode) {
                    let message = self.displayError(statusCode: res.statusCode)
                    completion(nil, message)
                    return
                }
            }
            
            // Decode the Json using the model type
            if let dataVal = data, let result = try? JSONDecoder().decode(type, from: dataVal) {
                completion(result, nil)
            } else {
                completion(nil, "Data Parsing failed")
            }
            
        }
        
        task.resume()
        
    }
    
    public func getData<T:Codable>(url: String, type: T.Type = T.self) async throws -> T? {
        
        PrintLog.printToConsole(str: "Requesting data \(url)")
        guard let reqUrl = URL(string: url) else { throw SchoolFetchError.invalidURL }
        let session = URLSession.shared
        
        let (data, response) = try await session.data(from: reqUrl)
        
        if let res = response as? HTTPURLResponse {
            // If the status code is not between 200-299, treat as failure and show the error message to user.
            if !(200...299).contains(res.statusCode) {
//                let message = self.displayError(statusCode: res.statusCode)
                throw SchoolFetchError.invalidResponse(responseCode: res.statusCode)
            }
        }
        
        let result = try JSONDecoder().decode(type, from: data)
        return result
    }
    
    public func displayError(statusCode: Int) -> String {
        var message = ""
        switch statusCode {
        case 401:
            message = "Not authorized"
        case 404:
            message = "Page Not Found"
        case 400:
            message = "Bad Request"
        case 500:
            message = "Internal Server Error"
        default:
            message = "Error occured. Please contact support"
        }
        
        return message
        
    }
    
}
