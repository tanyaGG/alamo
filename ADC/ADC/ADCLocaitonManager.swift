//
//  ADCLocaitonManager.swift
//  ADC
//
//  Created by TANYA GYGI on 9/22/17.
//  Copyright © 2017 TANYA GYGI. All rights reserved.
//

import Foundation

class ADCLocationManager : NSObject {
    
    static let sharedInstance = ADCLocationManager()
    
    fileprivate let mapEndpoint = "https://api.opencagedata.com/geocode/v1/json?q=&key="
    fileprivate var apiKey:String?
    
    fileprivate override init() {
        super.init()
        apiKey = Bundle.main.object(forInfoDictionaryKey: "ADCMapApiKey") as? String
    }
    
    func fetchLocations(withQuery query: String,  completion: @escaping (_ results: [ADCLocation]?, _ error: NSError?) -> Void) {

        guard let apiKey = self.apiKey, apiKey.characters.count > 0 else {
            completion(nil, NSError.apiKeyError())
            return
        }
        
        var urlParams = URLComponents(string: self.mapEndpoint)
        urlParams?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "key", value: apiKey)
        ]

        let url = URL(string: (urlParams?.string)!)
        guard url != nil else {
            completion(nil, NSError.apiUrlError())
            return
        }
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, apiError in
            guard apiError == nil else {
             
                let userInfo: [AnyHashable : Any] = [NSLocalizedDescriptionKey :  apiError?.localizedDescription ?? "" ]
                
                let tmpError = NSError(domain: ADCErrorDomain, code: ADCErrorCodes.appError.rawValue, userInfo: userInfo)
                completion(nil, tmpError)
                return
            }
            
            var locations: [ADCLocation] = []
            guard let data = data else {
                completion(nil, NSError.apiEmptyResultError())
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            if let rows = json?["results"]  as? NSArray {
                for case let row in rows {

                    let location = ADCLocation(withJson: row as! [String : Any])
                    locations.append(location)
                }
            }
            
            completion(locations, nil)
        }
        
        task.resume()
        
    }
}
