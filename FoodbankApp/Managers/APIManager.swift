//
//  APIManager.swift
//  
//
//  Created by Tim Windsor Brown on 01/05/2017.
//
//

import Foundation
import Alamofire
import AEXML

// MARK: - Setup
public struct APIManager {
    
    static let manager:SessionManager =  SessionManager(configuration: APIManager.configuration())
    
    static func configuration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 20.0
        
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        return configuration
    }
    
    static func authHeaders() -> [String: String] {
        
        var headers:[String: String] = [:]
        
        headers["X-API-KEY"] = "qazxsw_123"
       
        return headers
    }
    
    struct Constants {
        
        static let ChatPageDefaultSize = 20
    }
}

extension APIManager {
    
    typealias ResponseCompletion<T> = ((_ data:T?, _ error:ErrorType?) -> Void)
    
    enum ErrorType {
        case NoNetwork
        case NoData
        case ParsingError
    }
    
    static func loadAllDataForFoodbank(foodbankID:Int, completion:@escaping ResponseCompletion<[FoodItem]>) {
        
        let url = "https://foodbank.redemptionmedia.co.uk/api/index.php/foodbankData"
        let params = ["foodbankID":foodbankID]
        
        manager.request(url, method: .post, parameters: params, headers: authHeaders()).response { (response:DefaultDataResponse) in
            
            if let data = response.data,
                let stringXML = String(data: data, encoding: String.Encoding.utf8) {

                    let cleanString = stringXML.replacingOccurrences(of: "foodbankData=", with: "")
            
                do {
                let xmlDoc = try AEXMLDocument(xml: cleanString)
                    
                    var items:[FoodItem] = []
                    let itemList = xmlDoc["foodBank"]["foodItems"].children
                    for itemXML in itemList {
                        if let item = FoodItem.itemFromXML(element: itemXML) {
                            items.append(item)
                        }
                    }
                    
                    completion(items, nil)
                    print("Parsed \(items.count) food items")
                    
                }
                catch {
                    // ERROR
                    print("Error parsing XML")
                    print(error)
                    completion(nil, APIManager.ErrorType.ParsingError)
                }
                    
                

//                let xmlDoc = try AEXMLDocument(xml: data, options: options)

            }
        }
    }
}


struct FoodItem: CustomStringConvertible {
    
    enum Status:String {
        case low = "low"
        case medium = "medium"
        case high = "high"
    }
    
    var id:Int
    var name:String
    var status:Status
    
    
    
    static func itemFromXML(element:AEXMLElement) -> FoodItem? {
        
        if let id = element["id"].int {
            let name = element["name"].string
            let status = FoodItem.Status(rawValue: element["status"].string) ?? Status.medium
        
            let item = FoodItem(id: id, name: name, status: status)
            return item
        }
        return nil
    }
    
    var description:String {
        return "\(self.id) - \(self.name)\n\(self.status.rawValue)"
    }
}





