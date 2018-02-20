//
//  Models.swift
//  myProj
//
//  Created by Michael Ardizzone on 2/19/18.
//  Copyright © 2018 Michael Ardizzone. All rights reserved.
//

import Foundation

struct FoursquareModel : Codable {
    
    let response : FoursquareResponse
}

struct FoursquareResponse : Codable {
    let venues : [Venue]
}

struct Venue : Codable {
    let name: String
}

class parseJSON {
    class func parseInstagramData(data: Data) -> FoursquareModel? {
        let decoder = JSONDecoder()
        do {
            let foursquareData = try decoder.decode(FoursquareModel.self, from: data)
            return foursquareData
        } catch {
            print("error trying to convert data to JSON")
            return nil
        }
    }
}
