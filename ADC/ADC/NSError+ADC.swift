//
//  NSError+ADC.swift
//  ADC
//
//  Created by TANYA GYGI on 9/23/17.
//  Copyright © 2017 TANYA GYGI. All rights reserved.
//

import Foundation

let ADCErrorDomain = "com.adc"

enum ADCErrorCodes: Int {
    case appError = -1001
    case apiError = -1002
    case apiUrlError = -1003
    case apiEmptyError = -1004
    case apiKeyError = -1005
}

extension NSError {
    
    static func apiError() -> NSError {
        let userInfo: [AnyHashable : Any] = [NSLocalizedDescriptionKey :  NSLocalizedString("Api error occured", comment: "api error")]
        return NSError(domain: ADCErrorDomain, code: ADCErrorCodes.apiError.rawValue, userInfo: userInfo)
    }
    
    static func apiKeyError() -> NSError {
        let userInfo: [AnyHashable : Any] = [NSLocalizedDescriptionKey :  NSLocalizedString("Api key is missing", comment: "api key error")]
        return NSError(domain: ADCErrorDomain, code: ADCErrorCodes.apiError.rawValue, userInfo: userInfo)
    }
    
    static func apiUrlError() -> NSError {
        let userInfo: [AnyHashable : Any] = [NSLocalizedDescriptionKey :  NSLocalizedString("Api url error", comment: "api url error")]
        return NSError(domain: ADCErrorDomain, code: ADCErrorCodes.apiUrlError.rawValue, userInfo: userInfo)
    }
    
    static func appError() -> NSError {
        return NSError(domain: ADCErrorDomain, code: ADCErrorCodes.appError.rawValue, userInfo: nil)
    }
    
    static func apiEmptyResultError() -> NSError {
        let userInfo: [AnyHashable : Any] = [NSLocalizedDescriptionKey :  NSLocalizedString("Empty response from API", comment: "api response error")]
        return NSError(domain: ADCErrorDomain, code: ADCErrorCodes.apiEmptyError.rawValue, userInfo: userInfo)
    }
    
}
