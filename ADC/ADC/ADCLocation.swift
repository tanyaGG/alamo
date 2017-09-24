//
//  ADCLocation.swift
//  ADC
//
//  Created by TANYA GYGI on 9/22/17.
//  Copyright © 2017 TANYA GYGI. All rights reserved.
//

import Foundation

public class ADCLocation {
    
    var mapUrl: String = ""
    var address: String = ""
    
    init(withJson json: [String: Any]) {

        if let annotations = json["annotations"] as? [String: Any],
            let OSM = annotations["OSM"] as? [String: String] {
        
            self.mapUrl = OSM["url"] ?? ""
        }
    
        if let address = json["formatted"] as? String {
            self.address = address
        }
    }

}
