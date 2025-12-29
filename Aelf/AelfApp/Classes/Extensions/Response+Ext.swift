//
//  Response+Ext.swift
//  RxExamples
//
//  Created by 晋先森 on 2019/5/29.
//  Copyright © 2019 AELF. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper

// MARK: - ObjectMapper Extension for Moya Response
// Replacement for Moya-ObjectMapper library

extension Response {
    
    /// Maps data received from the server into an object that implements the Mappable protocol.
    func mapObject<T: Mappable>(_ type: T.Type, context: MapContext? = nil) throws -> T {
        guard let jsonDictionary = try mapJSON() as? [String: Any],
              let object = Mapper<T>(context: context).map(JSON: jsonDictionary) else {
            throw MoyaError.jsonMapping(self)
        }
        return object
    }
    
    /// Maps data received from the server into an array of objects that implement the Mappable protocol.
    func mapArray<T: Mappable>(_ type: T.Type, context: MapContext? = nil) throws -> [T] {
        guard let jsonArray = try mapJSON() as? [[String: Any]] else {
            throw MoyaError.jsonMapping(self)
        }
        return Mapper<T>(context: context).mapArray(JSONArray: jsonArray)
    }
    
    func toResult() -> VResult {
        guard let r = try? mapObject(VResult.self) else {
            return VResult.parseError()
        }
        return r
    }
    
    func toMarketResult() -> VResult {
        guard let r = try? mapObject(VResult.self) else {
            return VResult.parseError()
        }
        return r
    }
}
